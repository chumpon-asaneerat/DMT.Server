SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Customer](
	[CustomerId] [nvarchar](30) NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[TaxCode] [nvarchar](30) NULL,
	[Address1] [nvarchar](80) NULL,
	[Address2] [nvarchar](80) NULL,
	[City] [nvarchar](50) NULL,
	[Province] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](8) NULL,
	[Phone] [nvarchar](80) NULL,
	[Mobile] [nvarchar](80) NULL,
	[Fax] [nvarchar](80) NULL,
	[Email] [nvarchar](80) NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING ON

GO

/****** Object:  Index [IX_CustomerName]    Script Date: 4/23/2018 02:02:36 ******/
CREATE NONCLUSTERED INDEX [IX_CustomerName] ON [dbo].[Customer]
(
	[CustomerName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Customer Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'CustomerName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default TaxCode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'TaxCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Address1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Address1'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Address2' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Address2'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default City' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'City'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Province' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Province'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default PostalCode' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'PostalCode'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Phone Number(s)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Phone'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Mobile Number(s)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Mobile'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Fax Number(s)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Fax'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Default Email Address (For Company)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'Email'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Customer Name Index' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Customer', @level2type=N'INDEX',@level2name=N'IX_CustomerName'
GO
