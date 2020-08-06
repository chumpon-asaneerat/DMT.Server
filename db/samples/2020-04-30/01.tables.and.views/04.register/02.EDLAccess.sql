SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EDLAccess](
	[AccessId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NULL,
	[MemberId] [nvarchar](30) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EDLAccess] PRIMARY KEY CLUSTERED 
(
	[AccessId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[EDLAccess] ADD  CONSTRAINT [DF_EDLAccess_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Unique Access Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDLAccess', @level2type=N'COLUMN',@level2name=N'AccessId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id. Allow Null for EDL User.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDLAccess', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Member Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDLAccess', @level2type=N'COLUMN',@level2name=N'MemberId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Created Date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EDLAccess', @level2type=N'COLUMN',@level2name=N'CreateDate'
GO
