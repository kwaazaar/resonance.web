﻿using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.PlatformAbstractions;
using Resonance.APIClient;
using Resonance.Models;
using Resonance.Repo;
using Resonance.Repo.Database;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace Resonance.Demo
{
    public class Program
    {
        private const int WORKER_COUNT = 20; // Multiple parallel workers, to make sure any issues related to parallellisation occur, if any.
        private const bool BATCHED = false;
        private const bool GENERATE_DATA = true; // Change to enable/disable the adding of data to the subscription

        private static IServiceProvider serviceProvider;

        public static void Main(string[] args)
        {
            var serviceCollection = new ServiceCollection();
            ConfigureServices(serviceCollection);
            serviceProvider = serviceCollection.BuildServiceProvider();

            var publisher = serviceProvider.GetRequiredService<IEventPublisherAsync>();
            var consumer = serviceProvider.GetRequiredService<IEventConsumerAsync>();

            // Make sure the topic exists
            var topic1 = publisher.GetTopicByNameAsync("Demo Topic 1").GetAwaiter().GetResult() ?? publisher.AddOrUpdateTopicAsync(new Topic { Name = "Demo Topic 1" }).GetAwaiter().GetResult();
            var subscription1 = consumer.GetSubscriptionByNameAsync("Demo Subscription 1").GetAwaiter().GetResult();
            subscription1 = consumer.AddOrUpdateSubscriptionAsync(new Subscription
            {
                Id = subscription1 != null ? subscription1.Id.Value : default(Int64?),
                Name = "Demo Subscription 1",
                MaxDeliveries = 2,
                Ordered = !BATCHED, // Batched processing of ordered subscription is usually not very usefull
                TopicSubscriptions = new List<TopicSubscription>
                {
                    new TopicSubscription
                    {
                        TopicId = topic1.Id.Value, Enabled = true,
                    },
                },
            }).GetAwaiter().GetResult();

            if (GENERATE_DATA)
            {
                var sw = new Stopwatch();
                sw.Start();

                var arrLen = 5000;
                var nrs = new List<int>(arrLen);
                for (int i = 0; i < arrLen; i++) { nrs.Add(i); };

                nrs.AsParallel().ForAll((i) => 
                    Task.Run(async () => // Threadpool task to wait for async parts in inner task
                        {
                            Console.WriteLine($"Run {i:D4} - Start  [{Thread.CurrentThread.ManagedThreadId}]");
                            for (int fk = 1; fk <= 10; fk++) // 1000 different functional keys, 4 TopicEvents per fk
                            {
                                //await Task.Delay(1).ConfigureAwait(false);
                                var fkAsString = i.ToString();
                                await publisher.PublishAsync(topic1.Name, functionalKey: fkAsString, payload: "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"); // 100 bytes
                            }
                            Console.WriteLine($"Run {i:D4} - Finish [{Thread.CurrentThread.ManagedThreadId}]");
                        }
                    ).GetAwaiter().GetResult() // Block until all async work is done (ForAll does not await on Task as result-type)
                );

                sw.Stop();
                Console.WriteLine($"Total time for publishing: {sw.Elapsed.TotalSeconds} sec");
            }

            //var ce = consumer.ConsumeNext(subscription1.Name).FirstOrDefault();
            //if (ce != null)
            //    consumer.MarkConsumed(ce.Id, ce.DeliveryKey);

            var workers = new EventConsumptionWorker[WORKER_COUNT];
            for (int i = 0; i < WORKER_COUNT; i++)
            {
                workers[i] = CreateWorker(consumer, "Demo Subscription 1", BATCHED);
                workers[i].Start();
            }

            // Wait for a user to press Ctrl+C or when windows sends the stop process signal
            Console.WriteLine("Press Ctrl+C to stop the worker(s)...");
            var handle = new ManualResetEvent(false);
            Console.CancelKeyPress += (s, e) => { handle.Set(); e.Cancel = true; }; // Cancel must be true, to make sure the process is not killed and we can clean up nicely below
            handle.WaitOne();

            for (int i = 0; i < WORKER_COUNT; i++)
            {
                if (workers[i].IsRunning())
                    workers[i].Stop();
            }

        }

        public static EventConsumptionWorker CreateWorker(IEventConsumerAsync consumer, string subscriptionName, bool batched)
        {
            var worker = new EventConsumptionWorker(
                eventConsumer: consumer,
                subscriptionName: subscriptionName,
                logger: serviceProvider.GetRequiredService<ILoggerFactory>().CreateLogger<EventConsumptionWorker>(),
                batchSize: batched ? 50 : 1,
                consumeModel: batched ? ConsumeModel.Batch : ConsumeModel.Single,

                consumeAction: !batched ? async (ceW) =>
                {
                    //Console.WriteLine($"Consumed {ceW.Id} from thread {System.Threading.Thread.CurrentThread.ManagedThreadId}.");
                    await Task.Delay(1); // Some processing delay

                    //if (DateTime.UtcNow.Millisecond < 50)
                    //    throw new Exception("This exception was unhandled by the ConsumeAction.");

                    //if (DateTime.UtcNow.Millisecond > 900)
                    //    return ConsumeResult.MustRetry("ConsumeAction decided this event has to be retried.");

                    return ConsumeResult.Succeeded;
                } : default(Func<ConsumableEvent, Task<ConsumeResult>>),

                consumeBatchAction: batched ? async (ces) =>
                {
                    await Task.Delay(ces.Count());

                    return ces
                        .Select(ce => new KeyValuePair<Int64, ConsumeResult>(ce.Id, ConsumeResult.Succeeded)) // Return success for all
                        .ToDictionary(kvp => kvp.Key, kvp => kvp.Value);
                    
                } : default(Func<IEnumerable<ConsumableEvent>, Task<IDictionary<Int64, ConsumeResult>>>)
                );

            return worker;
        }

        private static void ConfigureServices(IServiceCollection serviceCollection)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(PlatformServices.Default.Application.ApplicationBasePath)
                .AddJsonFile("appsettings.json", optional: true, reloadOnChange: true);
            //builder.AddEnvironmentVariables();
            var config = builder.Build();

            // Add IConfiguration dependency (reason: allows access to config from any injected component)
            serviceCollection.AddSingleton<IConfiguration>(config);

            ILoggerFactory loggerFactory = new LoggerFactory()
                .AddConsole(LogLevel.Information)
                .AddDebug(LogLevel.Trace);
            serviceCollection.AddSingleton<ILoggerFactory>(loggerFactory);

            ConfigureApiServices(serviceCollection, config); // When using the ApiClient, make sure Resonance.Web is also running
        }

        private static void ConfigureApiServices(IServiceCollection serviceCollection, IConfiguration config)
        {
            var baseAddressUri = new Uri(config["Resonance:APIClient:BaseAddressUrl"], UriKind.Absolute); // When debugging, make sure Resonance.Web is running
            serviceCollection.AddTransient<IEventPublisherAsync>(p => { return new APIEventPublisher(baseAddressUri); });
            serviceCollection.AddTransient< IEventConsumerAsync>(p => { return new APIEventConsumer(baseAddressUri); });
        }
    }
}
