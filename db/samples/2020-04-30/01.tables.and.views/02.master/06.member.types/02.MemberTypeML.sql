SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: MemberTypeML.
-- Description:	The MemberType ML Table.
-- [== History ==]
-- <2018-04-16> :
--	- Table Created.
--	  - LangId is used ISO 639-1 alpha 2 code.
--
-- [== Example ==]
--
-- =============================================
CREATE TABLE [dbo].[MemberTypeML](
	[MemberTypeId] [int] NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[Description] [nvarchar](50) NULL,
 CONSTRAINT [PK_MemberTypeML] PRIMARY KEY CLUSTERED 
(
	[MemberTypeId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO