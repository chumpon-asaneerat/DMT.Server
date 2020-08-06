SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Branch](
	[CustomerId] [nvarchar](30) NOT NULL,
	[BranchId] [nvarchar](30) NOT NULL,
	[BranchName] [nvarchar](80) NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[BranchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Branch] ADD  CONSTRAINT [DF_Branch_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Branch Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'COLUMN',@level2name=N'BranchId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Branch Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'COLUMN',@level2name=N'BranchName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Branch Primary Key' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Branch', @level2type=N'CONSTRAINT',@level2name=N'PK_Branch'
GO
