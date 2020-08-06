SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetDevices.
-- Description:	Get Devices.
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
-- <2020-04-30> :
--  - reorder parameter @enabled
--  - remove parameter @deviceId
--
-- [== Example ==]
--
--exec GetDevices NULL, N'EDL-C2020030001', 1; -- get devices in all enable languages.
--exec GetDevices N'TH', N'EDL-C2020030001';   -- get devices in TH language.
--exec GetDevices N'TH', NULL;                 -- no data returns.
-- =============================================
CREATE PROCEDURE [dbo].[GetDevices] 
(
  @langId nvarchar(3) = NULL
, @customerId nvarchar(30) = NULL
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
	   AND DMLV.DeviceTypeId = DTMV.DeviceTypeId
	   --AND OMLV.CustomerId = DMLV.CustomerId
	   --AND OMLV.OrgID = DMLV.OrgId
	   --AND MIMLV.CustomerId = DMLV.CustomerId
	   --AND MIMLV.MemberID = DMLV.MemberID
	 ORDER BY DMLV.SortOrder, DMLV.LangId, DMLV.CustomerId, DMLV.DeviceId;
END

GO
