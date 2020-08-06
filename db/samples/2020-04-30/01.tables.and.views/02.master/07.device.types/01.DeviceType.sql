SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[DeviceType](
	[DeviceTypeId] [int] NOT NULL,
	[Description] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_DeviceType] PRIMARY KEY CLUSTERED 
(
	[DeviceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The Device Type Id' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceType', @level2type=N'COLUMN',@level2name=N'DeviceTypeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'The device description (default).' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DeviceType', @level2type=N'COLUMN',@level2name=N'Description'
GO
