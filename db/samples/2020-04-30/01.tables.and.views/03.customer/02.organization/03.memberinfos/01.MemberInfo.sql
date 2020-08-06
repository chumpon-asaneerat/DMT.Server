SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[MemberInfo](
	[MemberId] [nvarchar](30) NOT NULL,
	[CustomerId] [nvarchar](30) NOT NULL,
	[TagId] [nvarchar](30) NULL,
	[IDCard] [nvarchar](30) NULL,
	[EmployeeCode] [nvarchar](30) NULL,
	[Prefix] [nvarchar](10) NULL,
	[FirstName] [nvarchar](40) NOT NULL,
	[LastName] [nvarchar](50) NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[Password] [nvarchar](20) NOT NULL,
	[MemberType] [int] NOT NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_MemberInfo] PRIMARY KEY CLUSTERED 
(
	[MemberId] ASC,
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[MemberInfo] ADD  CONSTRAINT [DF_MemberInfo_MemberType]  DEFAULT ((280)) FOR [MemberType]
GO

ALTER TABLE [dbo].[MemberInfo] ADD  CONSTRAINT [DF_MemberInfo_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

ALTER TABLE [dbo].[MemberInfo]  WITH CHECK ADD  CONSTRAINT [CK_MemberInfo_MemberType] CHECK  (([MemberType]=(290) OR [MemberType]=(280) OR [MemberType]=(210) OR [MemberType]=(200)))
GO

ALTER TABLE [dbo].[MemberInfo] CHECK CONSTRAINT [CK_MemberInfo_MemberType]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Member Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'MemberId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'CustomerId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Employee Smartcard TagId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'TagId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Employee IDCard' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'IDCard'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Employee Code (assigned by customer company)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'EmployeeCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Prefix' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'Prefix'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default First Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'FirstName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Last Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'LastName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LogIn Member UserName' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'UserName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The LogIn Member Password' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'Password'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'200 admin, 210 exclusive, 280 staff, 290 Device' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'MemberType'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - InActive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Prevent Enter Invalid Member Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MemberInfo', @level2type=N'CONSTRAINT',@level2name=N'CK_MemberInfo_MemberType'
GO
