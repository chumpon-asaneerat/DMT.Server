SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DeviceML](
	[CustomerId] [nvarchar](30) NOT NULL,
	[DeviceId] [nvarchar](30) NOT NULL,
	[LangId] [nvarchar](3) NOT NULL,
	[DeviceName] [nvarchar](80) NOT NULL,
	[Location] [nvarchar](150) NULL,
 CONSTRAINT [PK_DeviceML_1] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC,
	[DeviceId] ASC,
	[LangId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Language Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceML', @level2type=N'COLUMN',@level2name=N'LangId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Device Name (ML)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceML', @level2type=N'COLUMN',@level2name=N'DeviceName'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Location (ML)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceML', @level2type=N'COLUMN',@level2name=N'Location'
GO