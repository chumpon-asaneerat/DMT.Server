SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSet](
	[QSetId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
	[HasRemark] [bit] NOT NULL,
	[DisplayMode] [tinyint] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[BeginDate] [datetime] NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_QSet] PRIMARY KEY CLUSTERED 
(
	[QSetId] ASC,
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[QSet] ADD  CONSTRAINT [DF_QSet_HasRemark]  DEFAULT ((0)) FOR [HasRemark]
GO

ALTER TABLE [dbo].[QSet] ADD  CONSTRAINT [DF_QSet_DisplayMode]  DEFAULT ((0)) FOR [DisplayMode]
GO

ALTER TABLE [dbo].[QSet] ADD  CONSTRAINT [DF_QSet_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
GO

ALTER TABLE [dbo].[QSet] ADD  CONSTRAINT [DF_QSet_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'Description'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is Question Set allow to enter remark.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'HasRemark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - One slide per page, 1 Continuous slide' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'DisplayMode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1 to set as default Question Set.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'IsDefault'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The begin date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'BeginDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The end date.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'EndDate'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSet', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO
