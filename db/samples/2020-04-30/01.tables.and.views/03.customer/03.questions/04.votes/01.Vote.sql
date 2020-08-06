SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Vote](
	[CustomerId] [nvarchar](30) NOT NULL,
	[OrgId] [nvarchar](30) NOT NULL,
	[BranchId] [nvarchar](30) NOT NULL,
	[DeviceId] [nvarchar](30) NOT NULL,
	[QSetId] [nvarchar](30) NOT NULL,
	[QSeq] [int] NOT NULL,
	[VoteSeq] [int] NOT NULL,
	[UserId] [nvarchar](30) NULL,
	[VoteDate] [datetime] NOT NULL,
	[VoteValue] [int] NOT NULL,
	[Remark] [nvarchar](100) NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_Vote] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[OrgId] ASC,
	[BranchId] ASC,
	[DeviceId] ASC,
	[QSetId] ASC,
	[QSeq] ASC,
	[VoteSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_UserId]    Script Date: 4/23/2018 04:32:54 ******/
CREATE NONCLUSTERED INDEX [IX_UserId] ON [dbo].[Vote]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_VoteDate]    Script Date: 4/23/2018 04:32:54 ******/
CREATE NONCLUSTERED INDEX [IX_VoteDate] ON [dbo].[Vote]
(
	[VoteDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [IX_VoteValue]    Script Date: 4/23/2018 04:32:54 ******/
CREATE NONCLUSTERED INDEX [IX_VoteValue] ON [dbo].[Vote]
(
	[VoteValue] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Vote] ADD  CONSTRAINT [DF_Vote_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO
