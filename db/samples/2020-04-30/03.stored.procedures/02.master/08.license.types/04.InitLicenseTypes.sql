SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitLicenseTypes.
-- Description:	Init Init License Types.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitLicenseTypes
-- =============================================
CREATE PROCEDURE [dbo].[InitLicenseTypes]
AS
BEGIN
DECLARE @id0 int;
DECLARE @id1 int;
DECLARE @id2 int;
DECLARE @id3 int;
	/* DELETE FIRST */
	DELETE FROM LicenseTypeML;
	DELETE FROM LicenseType;

	SET @id0 = 0
	SET @id1 = 1
	SET @id2 = 2
	SET @id3 = 3
	
	-- [DAY]
	INSERT INTO LicenseType VALUES (@id0, N'Trial', N'Free Full Functional', 1, 15, 0.00, N'฿', N'BAHT')
	-- [MONTH]
	INSERT INTO LicenseType VALUES (@id1, N'Monthly', N'Save 33% with full functions', 2, 1, 55.99, N'฿', N'BAHT')
	-- [6 Months]
	INSERT INTO LicenseType VALUES (@id2, N'6 Months', N'Save 40% with full functions', 2, 6, 315.99, N'฿', N'BAHT')
	-- [YEAR]
	INSERT INTO LicenseType VALUES (@id3, N'Yearly', N'Save 60% with full functions', 3, 1, 420.99, N'฿', N'BAHT')

	-- [ENGLISH]
	EXEC SaveLicenseTypeML @id0, N'EN', N'Trial', N'Free Full Functional', 0.00
	EXEC SaveLicenseTypeML @id1, N'EN', N'Monthly', N'Save 33% with full functions', 55.99
	EXEC SaveLicenseTypeML @id2, N'EN', N'6 Months', N'Save 40% with full functions', 315.99
	EXEC SaveLicenseTypeML @id3, N'EN', N'Yearly', N'Save 60% with full functions', 420.99
	-- [THAI]
	EXEC SaveLicenseTypeML @id0, N'TH', N'ทดลองใช้', N'ทดลองใช้ฟรี ทุกฟังก์ชั่น', 0.00, N'฿', N'บาท'
	EXEC SaveLicenseTypeML @id1, N'TH', N'รายเดือน', N'ประหยัดทันที 33% พร้อมใช้งานทุกฟังก์ชั่น', 2000.00, N'฿', N'บาท'
	EXEC SaveLicenseTypeML @id2, N'TH', N'6 เดือน', N'ประหยัดทันที 40% พร้อมใช้งานทุกฟังก์ชั่น', 10800.00, N'฿', N'บาท'
	EXEC SaveLicenseTypeML @id3, N'TH', N'รายปี', N'ประหยัดทันที 60% พร้อมใช้งานทุกฟังก์ชั่น', 14400.00, N'฿', N'บาท'
	-- [CHINESE]
	EXEC SaveLicenseTypeML @id0, N'ZH', N'审讯', N'免费试用 所有可用的功能', NULL
	EXEC SaveLicenseTypeML @id1, N'ZH', N'每月一次', N'ประหยัดทันที 33% 所有可用的功能', NULL
	EXEC SaveLicenseTypeML @id2, N'ZH', N'6个月', N'ประหยัดทันที 40% 所有可用的功能', NULL
	EXEC SaveLicenseTypeML @id3, N'ZH', N'每年', N'ประหยัดทันที 60% 所有可用的功能', NULL
	-- [JAPANESE]
	EXEC SaveLicenseTypeML @id0, N'JA', N'実験', N'無料体験. すべての利用可能な機能', NULL
	EXEC SaveLicenseTypeML @id1, N'JA', N'毎月', N'33％を保存. すべての利用可能な機能', NULL
	EXEC SaveLicenseTypeML @id2, N'JA', N'6 毎月', N'40％を保存. すべての利用可能な機能', NULL
	EXEC SaveLicenseTypeML @id3, N'JA', N'毎年', N'60％を保存. すべての利用可能な機能', NULL
	-- [GERMAN]
	EXEC SaveLicenseTypeML @id0, N'DE', N'Versuch', N'Voll funktionsfähige Prüfung. Alle verfügbaren Funktionen.', NULL
	EXEC SaveLicenseTypeML @id1, N'DE', N'monatlich', N'Sparen Sie 33%. Alle verfügbaren Funktionen.', NULL
	EXEC SaveLicenseTypeML @id2, N'DE', N'6 monatlich', N'Sparen Sie 40%. Alle verfügbaren Funktionen.', NULL
	EXEC SaveLicenseTypeML @id3, N'DE', N'jährlich', N'Sparen Sie 60%. Alle verfügbaren Funktionen.', NULL
	-- [FRENCH]
	EXEC SaveLicenseTypeML @id0, N'FR', N'épreuve', N'Complètement fonctionnel. Toutes les fonctions disponibles', NULL
	EXEC SaveLicenseTypeML @id1, N'FR', N'mensuel', N'Économisez 33% Toutes les fonctions disponibles', NULL
	EXEC SaveLicenseTypeML @id2, N'FR', N'6 mensuel', N'Économisez 40% Toutes les fonctions disponibles', NULL
	EXEC SaveLicenseTypeML @id3, N'FR', N'annuel', N'Économisez 60% Toutes les fonctions disponibles', NULL
	-- [KOREAN]
	EXEC SaveLicenseTypeML @id0, N'KO', N'공판', N'완전 기능 시험 사용 가능한 모든 기능을합니다.', NULL
	EXEC SaveLicenseTypeML @id1, N'KO', N'월', N'33 % 절감 사용 가능한 모든 기능을합니다.', NULL
	EXEC SaveLicenseTypeML @id2, N'KO', N'6 월', N'40 % 절감 사용 가능한 모든 기능을합니다.', NULL
	EXEC SaveLicenseTypeML @id3, N'KO', N'매년', N'50 % 절감 사용 가능한 모든 기능을합니다.', NULL
END

GO

EXEC InitLicenseTypes;

GO
