SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetDevice.
-- Description:	Get Device.
-- [== History ==]
-- <2020-04-30> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec GetDevice NULL, N'EDL-C2020030001', N'D0001', 1;  -- get devices by CustomerID and DeviceId in all enable languages
--exec GetDevice N'TH', N'EDL-C2020030001', N'D0001';    -- get devices by CustomerID and DeviceId in TH language.
--exec GetDevice N'TH', NULL, N'D0001';			       -- no data returns
--exec GetDevice N'TH', N'EDL-C2020030001', NULL;        -- no data returns
-- =============================================
CREATE PROCEDURE [dbo].[GetDevice] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
, @deviceId nvarchar(30) = NULL
, @enabled bit = NULL
)
AS
BEGIN
	SELECT DMLV.langId
		 , DMLV.customerId
		 , DMLV.deviceId
		 , DMLV.deviceTypeId
		 , DTMV.Description as Type
		 , DMLV.DeviceName
		 , DMLV.Location
		 , DMLV.orgId
		 , DMLV.memberId
		 , DMLV.SortOrder
		 , DMLV.Enabled 
	  FROM DeviceMLView DMLV
	     , DeviceTypeMLView DTMV
		 --, OrgMLView OMLV
		 --, MemberInfoMLView MIMLV
	 WHERE DMLV.[ENABLED] = COALESCE(@enabled, DMLV.[ENABLED])
	   AND UPPER(LTRIM(RTRIM(DMLV.LangId))) = UPPER(LTRIM(RTRIM(COALESCE(@langId, DMLV.LangId))))
       AND UPPER(LTRIM(RTRIM(DTMV.LangId))) = UPPER(LTRIM(RTRIM(DMLV.LangId)))
	   AND UPPER(LTRIM(RTRIM(DMLV.CustomerId))) = UPPER(LTRIM(RTRIM(@customerId)))
	   AND UPPER(LTRIM(RTRIM(DMLV.DeviceId))) = UPPER(LTRIM(RTRIM(@deviceId)))
	   AND DMLV.DeviceTypeId = DTMV.DeviceTypeId
	   --AND OMLV.CustomerId = DMLV.CustomerId
	   --AND OMLV.OrgID = DMLV.OrgId
	   --AND MIMLV.CustomerId = DMLV.CustomerId
	   --AND MIMLV.MemberID = DMLV.MemberID
	 ORDER BY DMLV.SortOrder, DMLV.LangId, DMLV.CustomerId, DMLV.DeviceId;
END

GO
