SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ErrorMessageML](
	[ErrCode] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[ErrMsg] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ErrorMessageML] PRIMARY KEY CLUSTERED 
(
	[ErrCode] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Error Code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessageML', @level2type=N'COLUMN',@level2name=N'ErrCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The ISO 639-1 alpha 2 code.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessageML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Error Message.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ErrorMessageML', @level2type=N'COLUMN',@level2name=N'ErrMsg'
GO
