USE [ResonanceDB]
GO
/****** Object:  Table [dbo].[ConsumedSubscriptionEvent]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConsumedSubscriptionEvent](
	[Id] [varchar](36) NOT NULL,
	[SubscriptionId] [varchar](36) NOT NULL,
	[PublicationDateUtc] [datetime2](7) NOT NULL,
	[FunctionalKey] [nvarchar](100) NULL,
	[Priority] [int] NOT NULL,
	[PayloadId] [varchar](36) NULL,
	[DeliveryDateUtc] [datetime2](7) NOT NULL,
	[ConsumedDateUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_DeliveredSubscriptionEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EventPayload]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EventPayload](
	[Id] [varchar](36) NOT NULL,
	[Payload] [ntext] NOT NULL,
 CONSTRAINT [PK_EventPayload] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FailedSubscriptionEvent]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FailedSubscriptionEvent](
	[Id] [varchar](36) NOT NULL,
	[SubscriptionId] [varchar](36) NOT NULL,
	[PublicationDateUtc] [datetime2](7) NOT NULL,
	[FunctionalKey] [nvarchar](100) NULL,
	[Priority] [int] NOT NULL,
	[PayloadId] [varchar](36) NULL,
	[DeliveryDateUtc] [datetime2](7) NOT NULL,
	[FailedDateUtc] [datetime2](7) NOT NULL,
	[Reason] [int] NOT NULL,
	[ReasonOther] [nvarchar](1000) NULL,
 CONSTRAINT [PK_FailedSubscriptionEvents] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[LastConsumedSubscriptionEvent]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LastConsumedSubscriptionEvent](
	[SubscriptionId] [varchar](36) NOT NULL,
	[FunctionalKey] [nvarchar](100) NOT NULL,
	[PublicationDateUtc] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_LastConsumedSubscriptionEvent] PRIMARY KEY CLUSTERED 
(
	[SubscriptionId] ASC,
	[FunctionalKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Subscription]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Subscription](
	[Id] [varchar](36) NOT NULL,
	[Name] [nvarchar](36) NOT NULL,
	[Ordered] [bit] NOT NULL,
	[TimeToLive] [int] NULL,
	[MaxDeliveries] [int] NOT NULL,
	[DeliveryDelay] [int] NULL,
 CONSTRAINT [PK_Subscription] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_Subscription_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SubscriptionEvent]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SubscriptionEvent](
	[Id] [varchar](36) NOT NULL,
	[SubscriptionId] [varchar](36) NOT NULL,
	[TopicEventId] [varchar](36) NOT NULL,
	[PublicationDateUtc] [datetime2](7) NOT NULL,
	[FunctionalKey] [nvarchar](100) NULL,
	[Priority] [int] NOT NULL,
	[PayloadId] [varchar](36) NULL,
	[ExpirationDateUtc] [datetime2](7) NULL,
	[DeliveryDelayedUntilUtc] [datetime2](7) NULL,
	[DeliveryCount] [int] NOT NULL,
	[DeliveryDateUtc] [datetime2](7) NULL,
	[DeliveryKey] [varchar](36) NULL,
	[InvisibleUntilUtc] [datetime2](7) NULL,
 CONSTRAINT [PK_SubscriptionEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Topic]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Topic](
	[Id] [varchar](36) NOT NULL,
	[Name] [nvarchar](36) NOT NULL,
	[Notes] [nvarchar](500) NULL,
 CONSTRAINT [PK_Topic] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_Topic_Name] UNIQUE NONCLUSTERED 
(
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TopicEvent]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TopicEvent](
	[Id] [varchar](36) NOT NULL,
	[TopicId] [varchar](36) NOT NULL,
	[PublicationDateUtc] [datetime2](7) NOT NULL,
	[ExpirationDateUtc] [datetime2](7) NULL,
	[FunctionalKey] [nvarchar](100) NULL,
	[Headers] [nvarchar](1000) NULL,
	[Priority] [int] NOT NULL,
	[PayloadId] [varchar](36) NULL,
 CONSTRAINT [PK_TopicEvent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TopicSubscription]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TopicSubscription](
	[Id] [varchar](36) NOT NULL,
	[TopicId] [varchar](36) NOT NULL,
	[SubscriptionId] [varchar](36) NOT NULL,
	[Enabled] [bit] NOT NULL,
	[Filtered] [bit] NOT NULL,
 CONSTRAINT [PK_TopicSubscription] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TopicSubscriptionFilter]    Script Date: 16-9-2016 21:51:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TopicSubscriptionFilter](
	[Id] [varchar](36) NOT NULL,
	[TopicSubscriptionId] [varchar](36) NOT NULL,
	[Header] [nvarchar](100) NOT NULL,
	[MatchExpression] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_TopicSubscriptionFilter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_SubscriptionEvent_Find]    Script Date: 16-9-2016 21:51:35 ******/
CREATE NONCLUSTERED INDEX [IX_SubscriptionEvent_Find] ON [dbo].[SubscriptionEvent]
(
	[Priority] DESC,
	[PublicationDateUtc] ASC,
	[DeliveryDelayedUntilUtc] ASC,
	[InvisibleUntilUtc] ASC,
	[SubscriptionId] ASC,
	[ExpirationDateUtc] ASC
)
INCLUDE ( 	[Id],
	[FunctionalKey],
	[PayloadId],
	[DeliveryCount],
	[DeliveryKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ConsumedSubscriptionEvent]  WITH CHECK ADD  CONSTRAINT [FK_ConsumedSubscriptionEvent_EventPayload] FOREIGN KEY([PayloadId])
REFERENCES [dbo].[EventPayload] ([Id])
GO
ALTER TABLE [dbo].[ConsumedSubscriptionEvent] CHECK CONSTRAINT [FK_ConsumedSubscriptionEvent_EventPayload]
GO
ALTER TABLE [dbo].[FailedSubscriptionEvent]  WITH CHECK ADD  CONSTRAINT [FK_FailedSubscriptionEvent_EventPayload] FOREIGN KEY([PayloadId])
REFERENCES [dbo].[EventPayload] ([Id])
GO
ALTER TABLE [dbo].[FailedSubscriptionEvent] CHECK CONSTRAINT [FK_FailedSubscriptionEvent_EventPayload]
GO
ALTER TABLE [dbo].[SubscriptionEvent]  WITH CHECK ADD  CONSTRAINT [FK_SubscriptionEvent_EventPayload] FOREIGN KEY([PayloadId])
REFERENCES [dbo].[EventPayload] ([Id])
GO
ALTER TABLE [dbo].[SubscriptionEvent] CHECK CONSTRAINT [FK_SubscriptionEvent_EventPayload]
GO
ALTER TABLE [dbo].[SubscriptionEvent]  WITH CHECK ADD  CONSTRAINT [FK_SubscriptionEvent_TopicEvent] FOREIGN KEY([TopicEventId])
REFERENCES [dbo].[TopicEvent] ([Id])
GO
ALTER TABLE [dbo].[SubscriptionEvent] CHECK CONSTRAINT [FK_SubscriptionEvent_TopicEvent]
GO
ALTER TABLE [dbo].[TopicEvent]  WITH CHECK ADD  CONSTRAINT [FK_TopicEvent_EventPayload] FOREIGN KEY([PayloadId])
REFERENCES [dbo].[EventPayload] ([Id])
GO
ALTER TABLE [dbo].[TopicEvent] CHECK CONSTRAINT [FK_TopicEvent_EventPayload]
GO
ALTER TABLE [dbo].[TopicSubscription]  WITH CHECK ADD  CONSTRAINT [FK_TopicSubscription_Subscription] FOREIGN KEY([SubscriptionId])
REFERENCES [dbo].[Subscription] ([Id])
GO
ALTER TABLE [dbo].[TopicSubscription] CHECK CONSTRAINT [FK_TopicSubscription_Subscription]
GO
ALTER TABLE [dbo].[TopicSubscription]  WITH CHECK ADD  CONSTRAINT [FK_TopicSubscription_Topic] FOREIGN KEY([TopicId])
REFERENCES [dbo].[Topic] ([Id])
GO
ALTER TABLE [dbo].[TopicSubscription] CHECK CONSTRAINT [FK_TopicSubscription_Topic]
GO
ALTER TABLE [dbo].[TopicSubscriptionFilter]  WITH CHECK ADD  CONSTRAINT [FK_TopicSubscriptionFilter_TopicSubscription] FOREIGN KEY([TopicSubscriptionId])
REFERENCES [dbo].[TopicSubscription] ([Id])
GO
ALTER TABLE [dbo].[TopicSubscriptionFilter] CHECK CONSTRAINT [FK_TopicSubscriptionFilter_TopicSubscription]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0=Unknown, 1=Expired, 2=MaxRetriesReached, 3=Other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FailedSubscriptionEvent', @level2type=N'COLUMN',@level2name=N'Reason'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Time to live in seconds' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Subscription', @level2type=N'COLUMN',@level2name=N'TimeToLive'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Delay the delivery by number of seconds' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Subscription', @level2type=N'COLUMN',@level2name=N'DeliveryDelay'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Custom payload for this subscriber, in case the payload was transformed/modified for this subscription.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SubscriptionEvent', @level2type=N'COLUMN',@level2name=N'PayloadId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Json-formatted key-value pair. Only used for topic-subscription filtering.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TopicEvent', @level2type=N'COLUMN',@level2name=N'Headers'
GO
