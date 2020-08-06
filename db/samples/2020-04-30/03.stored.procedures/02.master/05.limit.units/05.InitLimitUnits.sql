SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Init Limit Units.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-04-16> :
--	- replace insert with sp call.
--
-- [== Example ==]
--
--exec InitLimitUnits
-- =============================================
CREATE PROCEDURE [dbo].[InitLimitUnits]
AS
BEGIN
	/* DEFAULT LIMIT UNITS. */
    EXEC SaveLimitUnit 1, N'Number of Device(s)', N'device(s)'
    EXEC SaveLimitUnit 2, N'Number of User(s)', N'user(s)'
    EXEC SaveLimitUnit 3, N'Number of Client(s)', N'client(s)'

	/* [== ENGLISH ==] */
	EXEC SaveLimitUnitML 1, N'EN', N'Number of Device(s)', N'device(s)'
	EXEC SaveLimitUnitML 2, N'EN', N'Number of User(s)', N'user(s)'
	EXEC SaveLimitUnitML 3, N'EN', N'Number of Client(s)', N'client(s)'
	/* [== THAI ==] */
	EXEC SaveLimitUnitML 1, N'TH', N'จำนวนเครื่อง', N'เครื่อง'
	EXEC SaveLimitUnitML 2, N'TH', N'จำนวนบัญชีผู้ใช้', N'คน'
	EXEC SaveLimitUnitML 3, N'TH', N'จำนวนจุดติดตั้ง', N'จุด'
	/* [== JAPANESE ==] */
	EXEC SaveLimitUnitML 1, N'JA', N'番号', N'デバイス'
	EXEC SaveLimitUnitML 2, N'JA', N'ユーザー数', N'人'
	EXEC SaveLimitUnitML 3, N'JA', N'同時ユーザー', N'ポイント'
END

GO

EXEC InitLimitUnits;

GO
