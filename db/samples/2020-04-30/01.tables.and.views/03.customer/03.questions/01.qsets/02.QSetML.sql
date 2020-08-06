SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[QSetML](
	[QSetId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_QSetML] PRIMARY KEY CLUSTERED 
(
	[QSetId] ASC,
	[CustomerId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSetML', @level2type=N'COLUMN',@level2name=N'QSetId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSetML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Question Set Description.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QSetML', @level2type=N'COLUMN',@level2name=N'Description'
GO
