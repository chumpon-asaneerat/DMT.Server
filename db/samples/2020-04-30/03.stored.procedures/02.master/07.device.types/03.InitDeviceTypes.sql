SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init Device Types.
-- [== History ==]
-- <2018-05-22> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitDeviceTypes
-- =============================================
CREATE PROCEDURE [dbo].[InitDeviceTypes]
AS
BEGIN
	--DELETE FROM DeviceTypeML;
	--DELETE FROM DeviceType;

	-- Unknown
	INSERT INTO DeviceType VALUES (0, N'Unknown')
	-- Browser desktop - Chrome
	INSERT INTO DeviceType VALUES (101, N'Chrome desktop browser')
	-- Browser desktop - IE-Edge
	INSERT INTO DeviceType VALUES (102, N'IE-Edge desktop browser')
	-- Browser desktop - FireFox
	INSERT INTO DeviceType VALUES (103, N'FireFox desktop browser')
	-- Browser desktop - Opera
	INSERT INTO DeviceType VALUES (104, N'Opera desktop browser')
	-- Browser desktop - Safari
	INSERT INTO DeviceType VALUES (105, N'Safari desktop browser')
	-- Browser Mobile - Chrome
	INSERT INTO DeviceType VALUES (201, N'Chrome mobile browser')
	-- Browser Mobile - Andriod
	INSERT INTO DeviceType VALUES (202, N'Andriod mobile browser')
	-- Browser Mobile - FireFox
	INSERT INTO DeviceType VALUES (203, N'FireFox mobile browser')
	-- Browser Mobile - Opera
	INSERT INTO DeviceType VALUES (204, N'Opera mobile browser')
	-- Browser Mobile - Safari
	INSERT INTO DeviceType VALUES (205, N'Safari mobile browser')
	-- Browser Mobile - Safari
	INSERT INTO DeviceType VALUES (206, N'Edge mobile browser')

	-- [ENGLISH]
	INSERT INTO DeviceTypeML VALUES(  0, N'EN', N'Unknown');
	INSERT INTO DeviceTypeML VALUES(101, N'EN', N'Chrome desktop browser');
	INSERT INTO DeviceTypeML VALUES(102, N'EN', N'IE-Edge desktop browser');
	INSERT INTO DeviceTypeML VALUES(103, N'EN', N'FireFox desktop browser');
	INSERT INTO DeviceTypeML VALUES(104, N'EN', N'Opera desktop browser');
	INSERT INTO DeviceTypeML VALUES(105, N'EN', N'Safari desktop browser');
	INSERT INTO DeviceTypeML VALUES(201, N'EN', N'Chrome mobile browser');
	INSERT INTO DeviceTypeML VALUES(202, N'EN', N'Andriod mobile browser');
	INSERT INTO DeviceTypeML VALUES(203, N'EN', N'FireFox mobile browser');
	INSERT INTO DeviceTypeML VALUES(204, N'EN', N'Opera mobile browser');
	INSERT INTO DeviceTypeML VALUES(205, N'EN', N'Safari mobile browser');
	INSERT INTO DeviceTypeML VALUES(206, N'EN', N'Edge mobile browser');
	-- [THAI]
	INSERT INTO DeviceTypeML VALUES(  0, N'TH', N'ไม่ระบุ');
	INSERT INTO DeviceTypeML VALUES(101, N'TH', N'โคลม เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(102, N'TH', N'ไออี-เอจ เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(103, N'TH', N'ไฟร์ฟอกซ์ เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(104, N'TH', N'โอเปร่า เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(105, N'TH', N'ซาฟารี เดสก์ท็อป เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(201, N'TH', N'โคลม โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(202, N'TH', N'แอนดรอยด์ โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(203, N'TH', N'ไฟร์ฟอกซ์ โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(204, N'TH', N'โอเปร่า โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(205, N'TH', N'ซาฟารี โมบาย เบราว์เซอร์');
	INSERT INTO DeviceTypeML VALUES(206, N'TH', N'เอจ โมบาย เบราว์เซอร์');
END

GO

EXEC InitDeviceTypes;

GO
