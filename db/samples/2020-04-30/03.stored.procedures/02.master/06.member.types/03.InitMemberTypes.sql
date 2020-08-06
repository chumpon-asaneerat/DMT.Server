SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Member Types.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitMemberTypesS
-- =============================================
CREATE PROCEDURE [dbo].[InitMemberTypes]
AS
BEGIN
    DELETE FROM MemberTypeML;
    DELETE FROM MemberType;

	-- [EDL - ADMIN]
	INSERT INTO MemberType VALUES (100, N'EDL - Admin')
	-- [EDL - POWER USER]
	INSERT INTO MemberType VALUES (110, N'EDL - Power User')
	-- [EDL - STAFF]
	INSERT INTO MemberType VALUES (180, N'EDL - Staff')
	-- [CUSTOMER - ADMIN]
	INSERT INTO MemberType VALUES (200, N'Admin')
	-- [CUSTOMER - EXCLUSIVE]
	INSERT INTO MemberType VALUES (210, N'Exclusive')
	-- [CUSTOMER - STAFF]
	INSERT INTO MemberType VALUES (280, N'Staff')
	-- [CUSTOMER - DEVICE]
	INSERT INTO MemberType VALUES (290, N'Device')

	-- [ENGLISH]
	INSERT INTO MemberTypeML VALUES(100, N'EN', N'EDL - Admin');
	INSERT INTO MemberTypeML VALUES(110, N'EN', N'EDL - Power User');
	INSERT INTO MemberTypeML VALUES(180, N'EN', N'EDL - Staff');
	INSERT INTO MemberTypeML VALUES(200, N'EN', N'Admin');
	INSERT INTO MemberTypeML VALUES(210, N'EN', N'Exclusive');
	INSERT INTO MemberTypeML VALUES(280, N'EN', N'Staff');
	INSERT INTO MemberTypeML VALUES(290, N'EN', N'Device');
	-- [THAI]
	INSERT INTO MemberTypeML VALUES(100, N'TH', N'อีดีแอล - ผู้ดูแลระบบ');
	INSERT INTO MemberTypeML VALUES(110, N'TH', N'อีดีแอล - เจ้าหน้าที่ระดับควบคุม');
	INSERT INTO MemberTypeML VALUES(180, N'TH', N'อีดีแอล - เจ้าหน้าที่ปฏิบัติการ');
	INSERT INTO MemberTypeML VALUES(200, N'TH', N'ผู้ดูแลระบบ');
	INSERT INTO MemberTypeML VALUES(210, N'TH', N'ผู้บริหาร');
	INSERT INTO MemberTypeML VALUES(280, N'TH', N'เจ้าหน้าที่ปฏิบัติการ');
	INSERT INTO MemberTypeML VALUES(290, N'TH', N'อุปกรณ์');
	-- [CHINESE]
	INSERT INTO MemberTypeML VALUES(100, N'ZH', N'EDL - 管理员');
	INSERT INTO MemberTypeML VALUES(110, N'ZH', N'EDL - 管理者');
	INSERT INTO MemberTypeML VALUES(180, N'ZH', N'EDL - 员工');
	INSERT INTO MemberTypeML VALUES(200, N'ZH', N'管理员');
	INSERT INTO MemberTypeML VALUES(210, N'ZH', N'管理者');
	INSERT INTO MemberTypeML VALUES(280, N'ZH', N'员工');
	INSERT INTO MemberTypeML VALUES(290, N'ZH', N'设备');
	-- [JAPANESE]
	INSERT INTO MemberTypeML VALUES(100, N'JA', N'EDL - 支配人');
	INSERT INTO MemberTypeML VALUES(110, N'JA', N'EDL - 監督');
	INSERT INTO MemberTypeML VALUES(180, N'JA', N'EDL - 職員');
	INSERT INTO MemberTypeML VALUES(200, N'JA', N'支配人');
	INSERT INTO MemberTypeML VALUES(210, N'JA', N'監督');
	INSERT INTO MemberTypeML VALUES(280, N'JA', N'職員');
	INSERT INTO MemberTypeML VALUES(290, N'JA', N'デバイス');
	-- [GERMAN]
	INSERT INTO MemberTypeML VALUES(100, N'DE', N'EDL - Administrator');
	INSERT INTO MemberTypeML VALUES(110, N'DE', N'EDL - Aufsicht');
	INSERT INTO MemberTypeML VALUES(180, N'DE', N'EDL - Belegschaft');
	INSERT INTO MemberTypeML VALUES(200, N'DE', N'Administrator');
	INSERT INTO MemberTypeML VALUES(210, N'DE', N'Exklusiv');
	INSERT INTO MemberTypeML VALUES(280, N'DE', N'Belegschaft');
	INSERT INTO MemberTypeML VALUES(290, N'DE', N'Device');
	-- [FRENCH]
	INSERT INTO MemberTypeML VALUES(100, N'FR', N'EDL - Administrateur');
	INSERT INTO MemberTypeML VALUES(110, N'FR', N'EDL - Superviseur');
	INSERT INTO MemberTypeML VALUES(180, N'FR', N'EDL - Personnel');
	INSERT INTO MemberTypeML VALUES(200, N'FR', N'Administrateur');
	INSERT INTO MemberTypeML VALUES(210, N'FR', N'Exclusif');
	INSERT INTO MemberTypeML VALUES(280, N'FR', N'Personnel');
	INSERT INTO MemberTypeML VALUES(290, N'FR', N'Appareil');
	-- [KOREAN]
	INSERT INTO MemberTypeML VALUES(100, N'KO', N'EDL - 관리자');
	INSERT INTO MemberTypeML VALUES(110, N'KO', N'EDL - 감독자');
	INSERT INTO MemberTypeML VALUES(180, N'KO', N'EDL - 직원');
	INSERT INTO MemberTypeML VALUES(200, N'KO', N'관리자');
	INSERT INTO MemberTypeML VALUES(210, N'KO', N'감독자');
	INSERT INTO MemberTypeML VALUES(280, N'KO', N'직원');
	INSERT INTO MemberTypeML VALUES(290, N'KO', N'장치');
END

GO

EXEC InitMemberTypes;

GO
