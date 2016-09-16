﻿using Resonance.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Resonance
{
    public interface IEventPublisher
    {
        TopicEvent Publish(string topicName, DateTime? publicationDateUtc = null, DateTime? expirationDateUtc = null, string functionalKey = null, Dictionary<string, string> headers = null, string payload = null);
        TopicEvent Publish<T>(string topicName, DateTime? publicationDateUtc = null, DateTime? expirationDateUtc = null, string functionalKey = null, Dictionary<string, string> headers=null, T payload = null) where T : class;

        IEnumerable<Topic> GetTopics(string partOfName = null);
        Topic GetTopic(string id);
        Topic GetTopicByName(string name);
        Topic AddOrUpdateTopic(Topic topic);
        void DeleteTopic(string id, bool inclSubscriptions);
    }
}