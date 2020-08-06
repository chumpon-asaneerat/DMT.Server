SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Device](
	[CustomerId] [nvarchar](30) NOT NULL,
	[DeviceId] [nvarchar](30) NOT NULL,
	[DeviceTypeId] [int] NOT NULL,
	[DeviceName] [nvarchar](80) NOT NULL,
	[Location] [nvarchar](150) NULL,
	[OrgId] [nvarchar](30) NULL,
	[MemberId] [nvarchar](30) NULL,
	[ObjectStatus] [int] NOT NULL,
 CONSTRAINT [PK_Devices] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[DeviceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[Device] ADD  CONSTRAINT [DF_Devices_DeviceType]  DEFAULT ((0)) FOR [DeviceTypeId]
GO

ALTER TABLE [dbo].[Device] ADD  CONSTRAINT [DF_Device_ObjectStatus]  DEFAULT ((1)) FOR [ObjectStatus]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'See device types.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Device', @level2type=N'COLUMN',@level2name=N'DeviceTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Org Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Device', @level2type=N'COLUMN',@level2name=N'OrgId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - Inactive, 1 - Active' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Device', @level2type=N'COLUMN',@level2name=N'ObjectStatus'
GO
