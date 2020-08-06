SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetDeviceTypes.
-- Description:	Get Devices.
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
-- <2020-04-30> :
--	- Remove parameter @deviceTypeId.
--  - Add parameter @enabled.
--
-- [== Example ==]
--
--exec GetDeviceTypes N'EN';
--exec GetDeviceTypes N'TH';
--exec GetDeviceTypes NULL, 1;
--exec GetDeviceTypes NULL, 0;
-- =============================================
CREATE PROCEDURE [dbo].[GetDeviceTypes]
(
  @langId nvarchar(3) = NULL
, @enabled bit = NULL
)
AS
BEGIN
    SELECT langId
		 , deviceTypeId
		 , Description as Type
		 , SortOrder
		 , Enabled
    FROM DeviceTypeMLView
    WHERE [ENABLED] = COALESCE(@enabled, [ENABLED])
      AND UPPER(LTRIM(RTRIM(LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, LangId))))
    ORDER BY SortOrder, LangId, deviceTypeId;
END

GO
