SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MemberInfoML](
	[MemberId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Prefix] [nvarchar](10) NULL,
	[FirstName] [nvarchar](40) NOT NULL,
	[LastName] [nvarchar](50) NULL,
 CONSTRAINT [PK_MemberInfoML] PRIMARY KEY CLUSTERED 
(
	[MemberId] ASC,
	[CustomerId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Member Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'MemberId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native Prefix' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'Prefix'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native First Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'FirstName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Native Last Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfoML', @level2type=N'COLUMN',@level2name=N'LastName'
GO
