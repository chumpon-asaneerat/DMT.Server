SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLicenseFeatures.
-- Description:	Get License Features.
-- [== History ==]
-- <2017-05-31> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- change language id from nvarchar(10) to nvarchar(3).
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LicenseTypeId to licenseTypeId
--	- change column LimitUnitId to limitUnitId
-- <2019-08-19> :
--	- Remove column LimitUnitDescriptionNative.
--	- Remove column LimitUnitTextNative.
--	- Rename column LimitUnitDescriptionEN to LimitUnitDescription.
--	- Rename column LimitUnitTextEN to LimitUnitText.
--
-- [== Example ==]
--
--exec GetLicenseFeatures N'EN';    -- for only EN language.
--exec GetLicenseFeatures;          -- for get all.
--exec GetLicenseFeatures N'EN', 1; -- for all features for LicenseTypeId = 1 in EN language.
--exec GetLicenseFeatures N'TH', 0; -- for all features for LicenseTypeId = 0 in TH language.
-- =============================================
CREATE PROCEDURE [dbo].[GetLicenseFeatures] 
(
  @langId nvarchar(3) = null
, @licenseTypeId int = null
)
AS
BEGIN
	SELECT langId
		 , licenseTypeId
		 , seq
		 , limitUnitId
		 , LimitUnitDescription
		 , NoOfLimit
		 , LimitUnitText
		 , SortOrder
		 , Enabled 
	  FROM LicenseFeatureMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND Enabled = 1
	   AND LicenseTypeId = COALESCE(@licenseTypeId, LicenseTypeId)
	 Order By SortOrder, LangId, LicenseTypeId;
END

GO
