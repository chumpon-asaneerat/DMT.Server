SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitLicenseFeatures.
-- Description:	Init InitLicense Features.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitLicenseFeatures
-- =============================================
CREATE PROCEDURE [dbo].[InitLicenseFeatures]
AS
BEGIN
    -- DELETE FIRST.
    DELETE FROM LicenseFeature

	/* Trial */
	INSERT INTO LicenseFeature
		VALUES (0, 1, 1, 1);
	INSERT INTO LicenseFeature
		VALUES (0, 2, 2, 1);
	INSERT INTO LicenseFeature
		VALUES (0, 3, 3, 1);
	/* Monthly */
	INSERT INTO LicenseFeature
		VALUES (1, 1, 1, 5);
	INSERT INTO LicenseFeature
		VALUES (1, 2, 2, 10);
	INSERT INTO LicenseFeature
		VALUES (1, 3, 3, 10);

	/* 6 Months */
	INSERT INTO LicenseFeature
		VALUES (2, 1, 1, 5);
	INSERT INTO LicenseFeature
		VALUES (2, 2, 2, 10);
	INSERT INTO LicenseFeature
		VALUES (2, 3, 3, 10);

	/* Yearly */
	INSERT INTO LicenseFeature
		VALUES (3, 1, 1, 10);
	INSERT INTO LicenseFeature
		VALUES (3, 2, 2, 20);
	INSERT INTO LicenseFeature
		VALUES (3, 3, 3, 20);
END

GO

EXEC InitLicenseFeatures;

GO
