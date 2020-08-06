SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetDeviceType.
-- Description:	Get Device Type.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetDeviceType NULL, 101, 1;  -- all enable languages
--exec GetDeviceType N'TH', 101;    -- only TH language
-- =============================================
CREATE PROCEDURE [dbo].[GetDeviceType]
(
  @langId nvarchar(3) = NULL
, @deviceTypeId int = NULL
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
      AND DeviceTypeId = @deviceTypeId
    ORDER BY SortOrder, LangId, DeviceTypeId;
END

GO
