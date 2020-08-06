SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: InitErrorMessages.
-- Description:	Init error messages.
-- [== History ==]
-- <2017-08-06> :
--	- Stored Procedure Created.
-- <2018-05-10> :
--	- Update new error messages.
-- <2019-10-01> :
--	- Update new error messages.
--
-- [== Example ==]
--
--exec InitErrorMessages
-- =============================================
CREATE PROCEDURE [dbo].[InitErrorMessages]
AS
BEGIN
    -- SUCCESS.
    EXEC SaveErrorMsg 0000, N'Success.'
    -- LANGUAGES.
    EXEC SaveErrorMsg 0101, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0102, N'Description cannot be null or empty string.'
    -- MASTER PK.
    EXEC SaveErrorMsg 0201, N'Table Name is null or empty string.'
    EXEC SaveErrorMsg 0202, N'Seed Reset Mode should be number 1-3.'
    EXEC SaveErrorMsg 0203, N'Seed Digits should be number 1-9.'
    EXEC SaveErrorMsg 0204, N'Table name is not exists in MasterPK table.'
    EXEC SaveErrorMsg 0205, N'Not supports reset mode.'
    EXEC SaveErrorMsg 0206, N'Cannot generate seed code for table:'
    -- PERIOD UNITS.
    EXEC SaveErrorMsg 0301, N'PeriodUnit Id cannot be null.'
    EXEC SaveErrorMsg 0302, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0303, N'Description (default) is duplicated.'
    EXEC SaveErrorMsg 0304, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0305, N'Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.'
    EXEC SaveErrorMsg 0306, N'Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.'
    -- LIMIT UNITS.
    EXEC SaveErrorMsg 0401, N'LimitUnit Id cannot be null.'
    EXEC SaveErrorMsg 0402, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0403, N'Description (default) is duplicated.'
    EXEC SaveErrorMsg 0404, N'UnitText (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0405, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0406, N'Language Id not found.'
    EXEC SaveErrorMsg 0407, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0408, N'Cannot add new Description (ML) because the Description (ML) in same Language Id is already exists.'
    EXEC SaveErrorMsg 0409, N'Cannot change Description (ML) because the Description (ML) in same Language Id is already exists.'
    -- USER INFO(S).
    EXEC SaveErrorMsg 0501, N'FirstName (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0502, N'UserName cannot be null or empty string.'
    EXEC SaveErrorMsg 0503, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 0504, N'User Full Name (default) already exists.'
    EXEC SaveErrorMsg 0505, N'UserName already exists.'
    EXEC SaveErrorMsg 0506, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0507, N'The Language Id not exist.'
    EXEC SaveErrorMsg 0508, N'User Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0509, N'FirstName (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0510, N'No User match UserId.'
    EXEC SaveErrorMsg 0511, N'User Full Name (ML) already exists.'
    -- LICENSE TYPES.
    EXEC SaveErrorMsg 0601, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0602, N'Advertise Text (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0603, N'PeriodUnitId cannot be null.'
    EXEC SaveErrorMsg 0604, N'PeriodUnitId not found.'
    EXEC SaveErrorMsg 0605, N'Number of Period cannot be null.'
    EXEC SaveErrorMsg 0606, N'Price cannot be null.'
    EXEC SaveErrorMsg 0607, N'Cannot add new item description because the description (default) is duplicated.'
    EXEC SaveErrorMsg 0608, N'Cannot change item description because the description (default) is duplicated.'
    EXEC SaveErrorMsg 0609, N'Cannot add new item because the period and number of period is duplicated.'
    EXEC SaveErrorMsg 0610, N'Cannot change item because the period and number of period is duplicated.'
    EXEC SaveErrorMsg 0611, N'LicenseTypeId cannot be null.'
    EXEC SaveErrorMsg 0612, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0613, N'Language Id not found.'    
    EXEC SaveErrorMsg 0614, N'Description (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0615, N'Advertise Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0616, N'Price (ML) cannot be null.'
    EXEC SaveErrorMsg 0617, N'Description (ML) is duplicated.'    
    -- LICENSE FEATURES.
    EXEC SaveErrorMsg 0701, N'LicenseType Id cannot be null.'
    EXEC SaveErrorMsg 0702, N'LicenseType Id not found.'
    EXEC SaveErrorMsg 0703, N'LimitUnit Id cannot be null.'
    EXEC SaveErrorMsg 0704, N'LimitUnit Id not found.'
    EXEC SaveErrorMsg 0705, N'LimitUnit Id already exists.'
    EXEC SaveErrorMsg 0706, N'No Of Limit cannot be null.'
    EXEC SaveErrorMsg 0707, N'No Of Limit should be zero or more.'
    EXEC SaveErrorMsg 0708, N'Invalid Seq Number.' 
    -- CUSTOMER PK.
    EXEC SaveErrorMsg 0801, N'CustomerId is null or empty string.'
    EXEC SaveErrorMsg 0802, N'Table Name is null or empty string.'
    EXEC SaveErrorMsg 0803, N'Seed Reset Mode should be number 1-4.'
    EXEC SaveErrorMsg 0804, N'Seed Digits should be number 1-9.'
    EXEC SaveErrorMsg 0805, N'Table Name not exists in CustomerPK table.'
    EXEC SaveErrorMsg 0806, N'Not supports reset mode.'
    EXEC SaveErrorMsg 0807, N'Cannot generate seed code for table:'    
    -- CUSTOMERS.
    EXEC SaveErrorMsg 0901, N'Customer Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 0902, N'The Customer Id is not exists.'
    EXEC SaveErrorMsg 0903, N'Customer Name (default) is already exists.'
    EXEC SaveErrorMsg 0904, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0905, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 0906, N'Lang Id not found.'
    EXEC SaveErrorMsg 0907, N'Customer Name (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 0908, N'Customer Name (ML) is already exist.'
    -- BRANCH.
    EXEC SaveErrorMsg 1001, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1002, N'Branch Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1003, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1004, N'Branch Id is not found.'
    EXEC SaveErrorMsg 1005, N'Branch Name (default) already exists.'
    EXEC SaveErrorMsg 1006, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1007, N'Language Id not exist.'
    EXEC SaveErrorMsg 1008, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1009, N'Branch Id is not found.'
    EXEC SaveErrorMsg 1010, N'Branch Name (ML) is already exists.'
    -- MEMBER INTO(S).
    EXEC SaveErrorMsg 1101, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1102, N'Customer Id not found.'
    EXEC SaveErrorMsg 1103, N'First Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1104, N'User Name cannot be null or empty string.'
    EXEC SaveErrorMsg 1105, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 1106, N'MemberType cannot be null.'
    EXEC SaveErrorMsg 1107, N'MemberType allow only value 200 admin, 210 exclusive, 280 staff, 290 Device.'
    EXEC SaveErrorMsg 1108, N'Member Full Name (default) already exists.'
    EXEC SaveErrorMsg 1109, N'User Name already exists.'
    EXEC SaveErrorMsg 1110, N'Member Id is not found.'
    EXEC SaveErrorMsg 1111, N'IDCard is already exists.'
    EXEC SaveErrorMsg 1112, N'Employee Code is already exists.'
    EXEC SaveErrorMsg 1113, N'TagId is already exists.'
    EXEC SaveErrorMsg 1114, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1115, N'Lang Id not exist.'
    EXEC SaveErrorMsg 1116, N'Member Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1117, N'No Member match MemberId in specificed Customer Id.'
    EXEC SaveErrorMsg 1118, N'Member Full Name (ML) already exists.'
    -- ORGS.
    EXEC SaveErrorMsg 1201, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1202, N'Customer Id not found.'
    EXEC SaveErrorMsg 1203, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1204, N'Branch Id not found.'
    EXEC SaveErrorMsg 1205, N'The Root Org already assigned.'
    EXEC SaveErrorMsg 1206, N'The Parent Org Id is not found.'
    EXEC SaveErrorMsg 1207, N'Org Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1208, N'Org Name (default) already exists.'
    EXEC SaveErrorMsg 1209, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1210, N'Lang Id not found.'
    EXEC SaveErrorMsg 1211, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1212, N'Customer Id not found.'
    EXEC SaveErrorMsg 1213, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1214, N'No Org match Org Id in specificed Customer Id.'
    EXEC SaveErrorMsg 1215, N'Org Name (ML) already exists.'
    -- QSETS.
    EXEC SaveErrorMsg 1401, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1402, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1403, N'QSet Id is not found.'
    EXEC SaveErrorMsg 1404, N'QSet is already used in vote table.'
    EXEC SaveErrorMsg 1405, N'Begin Date and/or End Date should not be null.'
    EXEC SaveErrorMsg 1406, N'Display Mode is null or value is not in 0 to 1.'
    EXEC SaveErrorMsg 1407, N'Begin Date should less than End Date.'
    EXEC SaveErrorMsg 1408, N'Begin Date or End Date is overlap with another Question Set.'
    EXEC SaveErrorMsg 1409, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1410, N'Lang Id not found.'
    EXEC SaveErrorMsg 1411, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1412, N'Customer Id not found.'
    EXEC SaveErrorMsg 1413, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 1414, N'No QSet match QSetId in specificed Customer Id.'
    EXEC SaveErrorMsg 1415, N'Description(ML) already exists.'
    EXEC SaveErrorMsg 1416, N'Description (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 1417, N'Description (default) already exists.'
    EXEC SaveErrorMsg 1418, N'Begin Date or End Date is overlap with another Question Set.'
    -- QSLIDES.
    EXEC SaveErrorMsg 1501, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1502, N'Question Set Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1503, N'Question Text cannot be null or empty string.'
    EXEC SaveErrorMsg 1504, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1505, N'QSetId is not found.'
    EXEC SaveErrorMsg 1506, N'QSeq is not found.'
    EXEC SaveErrorMsg 1507, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1508, N'Lang Id not found.'
    EXEC SaveErrorMsg 1509, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1510, N'Customer Id not found.'
    EXEC SaveErrorMsg 1511, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 1512, N'No QSet match QSetId in specificed Customer Id.'
    EXEC SaveErrorMsg 1513, N'QSeq is null or less than zero.'
    EXEC SaveErrorMsg 1514, N'No QSlide match QSetId and QSeq.'
    EXEC SaveErrorMsg 1515, N'Question Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 1516, N'Question Text (ML) already exists.'
    -- QSLIDEITEMS.
    EXEC SaveErrorMsg 1601, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1602, N'Question Set Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1603, N'QSeq cannot be null or less than zero.'
    EXEC SaveErrorMsg 1604, N'Question Text cannot be null or empty string.'
    EXEC SaveErrorMsg 1605, N'Customer Id is not found.'
    EXEC SaveErrorMsg 1606, N'QSetId is not found.'
    EXEC SaveErrorMsg 1607, N'QSlide is not found.'
    EXEC SaveErrorMsg 1608, N'QSSeq is not found.'
    EXEC SaveErrorMsg 1609, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1610, N'Lang Id not found.'
    EXEC SaveErrorMsg 1611, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1612, N'Customer Id not found.'
    EXEC SaveErrorMsg 1613, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 1614, N'No QSet match QSetId in specificed Customer Id.'
    EXEC SaveErrorMsg 1615, N'QSeq is null or less than zero.'
    EXEC SaveErrorMsg 1616, N'No QSlide match QSetId and QSeq.'
    EXEC SaveErrorMsg 1617, N'QSSeq is null or less than zero.'
    EXEC SaveErrorMsg 1618, N'No QSlideItem match QSetId, QSeq and QSSeq.'
    EXEC SaveErrorMsg 1619, N'Question Item Text (ML) cannot be null or empty string.'
    EXEC SaveErrorMsg 1620, N'Question Item Text (ML) already exists.'
    -- VOTES.
    EXEC SaveErrorMsg 1701, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1702, N'Customer Id not found.'
    EXEC SaveErrorMsg 1703, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1704, N'Branch Id not found.'
    EXEC SaveErrorMsg 1705, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1706, N'Org Id not found.'
    EXEC SaveErrorMsg 1707, N'QSet Id cannot be null or empty string.'
    EXEC SaveErrorMsg 1708, N'QSet Id not found.'
    -- REGISTER CUSTOMER.
    EXEC SaveErrorMsg 1801, N'CustomerName cannot be null or empty string.'
    EXEC SaveErrorMsg 1802, N'UserName and Password cannot be null or empty string.'
	EXEC SaveErrorMsg 1803, N'LicenseTypeId cannot be null.'
	EXEC SaveErrorMsg 1804, N'LicenseTypeId not exists.'
    -- SIGNIN.
    EXEC SaveErrorMsg 1901, N'User Name cannot be null or empty string.'
    EXEC SaveErrorMsg 1902, N'Password cannot be null or empty string.'
    EXEC SaveErrorMsg 1903, N'Cannot found User that match information.'
    EXEC SaveErrorMsg 1904, N'mode cannot be null or empty string.'
    EXEC SaveErrorMsg 1905, N'invalid mode.'
    -- GET VOTE SUMMARIES.
    EXEC SaveErrorMsg 2001, N'CustomerId cannot be null or empty string.'
    EXEC SaveErrorMsg 2002, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 2003, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 2004, N'The default OrgId not found.'
    EXEC SaveErrorMsg 2005, N'The BranchId not found.'
    -- GET RAW VOTES
    EXEC SaveErrorMsg 2101, N'CustomerId cannot be null or empty string.'
    EXEC SaveErrorMsg 2102, N'QSetId cannot be null or empty string.'
    EXEC SaveErrorMsg 2103, N'QSeq cannot be null or less than 1.'
    EXEC SaveErrorMsg 2104, N'Begin Date and End Date cannot be null.'
    EXEC SaveErrorMsg 2105, N'LangId Is Null Or Empty String.'
    -- ERROR MESSAGES
    EXEC SaveErrorMsg 2201, N'Error Code cannot be null or empty string.'
    EXEC SaveErrorMsg 2202, N'Language Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2203, N'Language Id not found.'
    EXEC SaveErrorMsg 2204, N'Error Message (ML) cannot be null or empty string.'
    -- CLIENTS
    EXEC SaveErrorMsg 2301, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2302, N'Access Id not found.'
    EXEC SaveErrorMsg 2303, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2304, N'Lang Id not found.'
    EXEC SaveErrorMsg 2305, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2306, N'Access Id not found.'
    EXEC SaveErrorMsg 2307, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2308, N'Access Id not found.'
    EXEC SaveErrorMsg 2309, N'mode cannot be null or empty string.'
    EXEC SaveErrorMsg 2310, N'invalid mode.'
    -- DEVICES
    EXEC SaveErrorMsg 2401, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2402, N'Device Type Id not found.'
    EXEC SaveErrorMsg 2403, N'Device Name (default) cannot be null or empty string.'
    EXEC SaveErrorMsg 2404, N'Customer Id is not found.'
    EXEC SaveErrorMsg 2405, N'Device Id is not found.'
    EXEC SaveErrorMsg 2406, N'Device Name (default) already exists.'
    EXEC SaveErrorMsg 2407, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2408, N'Lang Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2409, N'Lang Id not exist.'
    EXEC SaveErrorMsg 2410, N'Device Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2411, N'Device Id is not found.'
    EXEC SaveErrorMsg 2412, N'Device Name (ML) is already exists.'
	-- CHECK LICENSE
	EXEC SaveErrorMsg 2501, N'Customer Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2502, N'Customer Id not exists.'
	EXEC SaveErrorMsg 2503, N'LicenseTypeId cannot be null.'
	EXEC SaveErrorMsg 2504, N'LicenseTypeId not exists.'
	-- SAVE LICENSE HISTORY
	EXEC SaveErrorMsg 2601, N'Customer Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2602, N'Customer Id not exists.'
	EXEC SaveErrorMsg 2603, N'LicenseTypeId cannot be null.'
	EXEC SaveErrorMsg 2604, N'LicenseTypeId not exists.'
	EXEC SaveErrorMsg 2605, N'Request is on processing.'
	EXEC SaveErrorMsg 2606, N'Your Free License is already used.'
	-- REVOKE LICENSE HISTORY
	EXEC SaveErrorMsg 2701, N'History Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2702, N'History Id not exists.'	
	-- EXTEND LICENSE HISTORY
	EXEC SaveErrorMsg 2801, N'History Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2802, N'History Id not exists.'
    EXEC SaveErrorMsg 2803, N'License Still in active state.'
	-- SETUP DEVICE ORG
	EXEC SaveErrorMsg 2901, N'Customer Id cannot be null or empty string.'
	EXEC SaveErrorMsg 2902, N'Device Id cannot be null or empty string.'
    EXEC SaveErrorMsg 2903, N'Customer Id is not found.'
	EXEC SaveErrorMsg 2904, N'Device Id Not Found.'
    EXEC SaveErrorMsg 2905, N'Org Id is not found.'
	-- SETUP DEVICE USER
	EXEC SaveErrorMsg 3001, N'Customer Id cannot be null or empty string.'
	EXEC SaveErrorMsg 3002, N'Device Id cannot be null or empty string.'
    EXEC SaveErrorMsg 3003, N'Customer Id is not found.'
	EXEC SaveErrorMsg 3004, N'Device Id Not Found.'
    EXEC SaveErrorMsg 3005, N'Member Id is not found.'
    -- DELETE MEMBER INFO
    EXEC SaveErrorMsg 4001, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4002, N'Member Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4003, N'Cannot be remove default admin.'
    -- DELETE BRANCH
    EXEC SaveErrorMsg 4051, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4052, N'Branch Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4103, N'Cannot be remove default branch.'
    -- DELETE ORG
    EXEC SaveErrorMsg 4101, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4102, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4103, N'Cannot be remove default org.'
    -- DELETE QSET
    EXEC SaveErrorMsg 4151, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4152, N'Qset Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4153, N'Cannot be remove qset that already in used.'
    -- DELETE QSLIDE
    EXEC SaveErrorMsg 4201, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4202, N'Qset Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4203, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 4204, N'Cannot be remove qslide that already in used.'
    -- DELETE QSLIDEITEM
    EXEC SaveErrorMsg 4251, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4252, N'Qset Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4253, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 4254, N'QSSeq cannot be null.'
    EXEC SaveErrorMsg 4255, N'Cannot be remove qslideitem that already in used.'
    -- DELETE DEVICE
    EXEC SaveErrorMsg 4301, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4302, N'Device Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4303, N'Cannot be remove default device.'
    -- DELETE VOTE
    EXEC SaveErrorMsg 4351, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4352, N'Org Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4353, N'QSet Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4354, N'QSeq cannot be null.'
    EXEC SaveErrorMsg 4355, N'VoteSeq cannot be null.'
    EXEC SaveErrorMsg 4356, N'VoteDate cannot be null.'
    -- Change Customer
    EXEC SaveErrorMsg 4501, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4502, N'Access Id not found.'
    EXEC SaveErrorMsg 4503, N'Customer Id not found.'
    EXEC SaveErrorMsg 4504, N'mode cannot be null or empty string.'
    EXEC SaveErrorMsg 4505, N'invalid mode.'
    -- Set Access Device
    EXEC SaveErrorMsg 4601, N'Access Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4602, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4603, N'Access Id not found.'
    EXEC SaveErrorMsg 4604, N'Device Id not found.'
    EXEC SaveErrorMsg 4605, N'mode cannot be null or empty string.'
    EXEC SaveErrorMsg 4606, N'invalid mode.'
    -- Get QSet By Date
    EXEC SaveErrorMsg 4701, N'Customer Id cannot be null or empty string.'
    EXEC SaveErrorMsg 4702, N'Begin Date is null.'
    EXEC SaveErrorMsg 4703, N'Begin Date should less than End Date.'
    EXEC SaveErrorMsg 4704, N'No QSet Found.'
END

GO

EXEC InitErrorMessages;

GO
