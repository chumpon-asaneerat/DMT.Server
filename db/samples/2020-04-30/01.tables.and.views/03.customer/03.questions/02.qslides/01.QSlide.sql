SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSlide](
	[CustomerId] [nvarchar](30) NOT NULL,
	[QSetId] [nvarchar](30) NOT NULL,
	[QSeq] [int] NOT NULL,
	[QText] [nvarchar](max) NOT NULL,
	[HasRemark] [bit] NOT NULL,
	[SortOrder] [int] NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_QSlide] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[QSetId] ASC,
	[QSeq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[QSlide] ADD  CONSTRAINT [DF_QSlide_HasRemark]  DEFAULT ((0)) FOR [HasRemark]
GO

ALTER TABLE [dbo].[QSlide] ADD  CONSTRAINT [DF_QSlide_SortOrder]  DEFAULT ((0)) FOR [SortOrder]
GO

ALTER TABLE [dbo].[QSlide] ADD  CONSTRAINT [DF_QSlide_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The QSet Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Sequence (Unique).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'QSeq'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Text.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'QText'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Is Question Slide Has remark (0 - No Remark, 1 - Has Remark).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'HasRemark'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Sort Order.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'SortOrder'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSlide', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO
