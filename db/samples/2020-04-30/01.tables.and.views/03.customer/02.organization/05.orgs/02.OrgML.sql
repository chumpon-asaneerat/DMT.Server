SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[OrgML](
	[CustomerId] [nvarchar](30) NOT NULL,
	[OrgId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[OrgName] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_OrgML] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[OrgId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrgML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Org Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrgML', @level2type=N'COLUMN',@level2name=N'OrgId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrgML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native Org Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'OrgML', @level2type=N'COLUMN',@level2name=N'OrgName'
GO
