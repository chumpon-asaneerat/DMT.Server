SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSlideItem](
	[CustomerId] [nvarchar](30) NOT NULL,
	[QSetId] [nvarchar](30) NOT NULL,
	[QSeq] [int] NOT NULL,
	[QSSeq] [int] NOT NULL,
	[QText] [nvarchar](max) NOT NULL,
	[IsRemark] [bit] NOT NULL,
    [Choice] [int] NULL,
	[SortOrder] [int] NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_QSlideItem] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[QSetId] ASC,
	[QSeq] ASC,
	[QSSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[QSlideItem] ADD  CONSTRAINT [DF_QSlideItem_IsRemark]  DEFAULT ((0)) FOR [IsRemark]
GO

ALTER TABLE [dbo].[QSlideItem] ADD  CONSTRAINT [DF_QSlideItem_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[QSlideItem] ADD  CONSTRAINT [DF_QSlideItem_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Slide Seq.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'QSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Seq.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'QSSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'QText'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is Remark Item.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'IsRemark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Item Sort Order.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'SortOrder'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlideItem', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO
