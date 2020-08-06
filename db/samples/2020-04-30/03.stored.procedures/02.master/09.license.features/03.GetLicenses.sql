SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: GetLicenses.
-- Description:	Get Licenses.
-- [== History ==]
-- <2018-05-09> :
--	- Stored Procedure Created.
-- <2018-05-15> :
--	- change column LangId to langId
--	- change column LicenseTypeId to licenseTypeId
--	- change column PeriodUnitId to periodUnitId
--  - change column NumberOfUnit to NoOfUnit
--	- change column LimitUnitId to limitUnitId
-- <2019-08-19> :
--	- Remove column LimitUnitDescriptionNative.
--	- Remove column LimitUnitTextNative.
--	- Remove column AdTextNative.
--	- Rename column LimitUnitDescriptionEN to LimitUnitDescription.
--	- Rename column LimitUnitTextEN to LimitUnitText.
--	- Rename column AdTextEN to AdText.
--
-- [== Example ==]
--
--exec GetLicenses N'EN';    -- for only EN language.
--exec GetLicenses;          -- for get all.
-- =============================================
CREATE PROCEDURE [dbo].[GetLicenses] 
(
  @langId nvarchar(3) = null
, @licenseTypeId int = null  
)
AS
BEGIN
	SELECT langId
		 , licenseTypeId
		 , seq
		 , LicenseTypeDescription
		 , AdText
		 , periodUnitId
		 , NumberOfUnit as NoOfUnit
		 , UseDefaultPrice
		 , Price
		 , CurrencySymbol
		 , CurrencyText
		 , limitUnitId
		 , LimitUnitDescription
		 , NoOfLimit
		 , LimitUnitText
		 , SortOrder
		 , Enabled
	  FROM LicenseMLView
	 WHERE langId = COALESCE(@langId, langId)
	   AND LicenseTypeId = COALESCE(@licenseTypeId, LicenseTypeId)
	   AND Enabled = 1
	 Order By SortOrder, LicenseTypeId, Seq
END

GO
