/****** Object:  StoredProcedure [dbo].[InitSampleData]    Script Date: 3/26/2020 14:04:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Description:	Init sample data
-- [== History ==]
-- <2020-03-26> :
--	- Stored Procedure Created.
--
-- [== Example ==]
--
--exec InitSampleData
-- =============================================
CREATE PROCEDURE [dbo].[InitSampleData]
  @customerId as nvarchar(30)
AS
BEGIN
DECLARE @memberId nvarchar(30);
DECLARE @branchId nvarchar(30);
DECLARE @orgId nvarchar(30);
DECLARE @parentId nvarchar(30);
DECLARE @deviceId nvarchar(30);

DECLARE @qSetId nvarchar(30);
DECLARE @qSeq int;
DECLARE @qSSeq int;

DECLARE @beginDate datetime;
DECLARE @endDate datetime;

DECLARE @voteDate datetime;
DECLARE @voteValue int;
DECLARE @voteSeq int;
	-- SETUP ORG FOR EDL
	SET @parentId = N'O0001'
	SET @branchId = N'B0001'

	-- LEVEL 1
	SET @orgId = NULL;
	EXEC SaveOrg @customerId, @parentId, @branchId, N'Office', @orgId out
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'ออฟฟิส'

	SET @orgId = NULL
	EXEC SaveOrg @customerId, @parentId, @branchId, N'PCB Design', @orgId out
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'พีซีบี ดีไซน์'

	SET @orgId = NULL
	EXEC SaveOrg @customerId, @parentId, @branchId, N'R&D', @orgId out
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'อาร์ แอน ดี'

	SET @orgId = NULL
	EXEC SaveOrg @customerId, @parentId, @branchId, N'Restroom', @orgId out
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'ห้องน้ำ'

	-- LEVEL 2 - (Office)
	SET @parentId = N'O0002'
	SET @branchId = N'B0001'

	SET @orgId = NULL;
	EXEC SaveOrg @customerId, @parentId, @branchId, N'Off.Counter 1', @orgId out
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'เค้าเตอร์ ที่ 1'

	SET @orgId = NULL;
	EXEC SaveOrg @customerId, @parentId, @branchId, N'Off.Counter 2', @orgId out
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'เค้าเตอร์ ที่ 2'

	-- LEVEL 2 - (Restroom)
	SET @parentId = N'O0005'
	SET @branchId = N'B0001'

	SET @orgId = NULL;
	EXEC SaveOrg @customerId, @parentId, @branchId, N'Restroom L.', @orgId out
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'ห้องน้ำฝั่งซ้าย'

	SET @orgId = NULL;
	EXEC SaveOrg @customerId, @parentId, @branchId, N'Restroom R.', @orgId out
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'ห้องน้ำฝั่งขวา'

	SET @orgId = NULL;
	EXEC SaveOrg @customerId, @parentId, @branchId, N'Restroom Fr.2', @orgId out
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'ห้องน้ำชั้น 2'

	-- LEVEL 0 Change Name
	SET @orgId = N'O0001';
	SET @parentId = NULL;
	SET @branchId = N'B0001'
	EXEC SaveOrg @customerId, @parentId, @branchId, N'EDL Co., Ltd.'
	EXEC SaveOrgML @customerId, @orgId, N'TH', N'บริษัท อีดีแอล จำกัด'

	-- MEMBERS
	-- Admin (200)
	EXEC SaveMemberInfo @customerId, N'Mr.', N'Nitipat', N'Tanasinwiroj', N'nitipat@edl.co.th', N'1234', 200, N'000000B03B78B7', NULL, NULL, @memberId out
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นาย', N'นิธิภัทร์', N'ธนสินวิโรจน์'
	SET @memberId = NULL

	EXEC SaveMemberInfo @customerId, N'Mr.', N'Teedej', N'Puttimanoradekul', N'teedate@edl.co.th', N'1234', 200, N'00000010006AB7', NULL, NULL, @memberId out
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นาย', N'ธีเดช', N'พุฒิมานรดีกุล'
	SET @memberId = NULL

	-- Exclusive (210)
	EXEC SaveMemberInfo @customerId, N'Mrs.', N'Sodsri', N'Sinda', N'sodsri@edl.co.th', N'1234', 210, NULL, NULL, NULL, @memberId out
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นาง', N'สดศรี', N'สินดา'
	SET @memberId = NULL

	EXEC SaveMemberInfo @customerId, N'Mr.', N'Chaisem', N'Dokkloy', N'chaisem@edl.co.th', N'1234', 210, NULL, NULL, NULL, @memberId out
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นาย', N'ชัยเษม', N'ดอกกลอย'
	SET @memberId = NULL

	EXEC SaveMemberInfo @customerId, N'Ms.', N'Rattiya', N'Sopha', N'rattiya@edl.co.th', N'1234', 210, N'0000003A4C24A4', NULL, NULL, @memberId out
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นางสาว', N'รัตติยา', N'โสภา'
	SET @memberId = NULL
	-- Staff (280)
	EXEC SaveMemberInfo @customerId, N'Mrs.', N'Kanya', N'Sawangjang', N'kanya@edl.co.th', N'1234', 280, N'000000FD5F24A4', NULL, NULL, @memberId out
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'นางสาว', N'กันยา', N'สว่างแจ้ง'
	SET @memberId = NULL

	EXEC SaveMemberInfo @customerId, N'Mrs.', N'Tim', N'Pinij', N'tim@edl.co.th', N'1234', 280, N'000000668724A4', NULL, NULL, @memberId out
	EXEC SaveMemberInfoML @customerId, @memberId, N'TH', N'ป้า', N'ติ๋ม', N'พินิจ'
	SET @memberId = NULL

	-- DEVICES
	EXEC SaveDevice @customerId, 101, N'EDL Showroom', N'EDL Showroom Front', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'อีดีแอล โชว์รูม', N'หน้าบริษัทอีดีแอล'
	SET @deviceId = NULL;

	EXEC SaveDevice @customerId, 201, N'R&D 1', N'R&D Front', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'อาร์ แอน ดี 1', N'หน้าห้อง อาร์ แอน ดี ด้านหน้า'
	SET @deviceId = NULL;

	EXEC SaveDevice @customerId, 201, N'R&D 2', N'R&D (L.Side)', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'อาร์ แอน ดี 2', N'หน้าห้อง อาร์ แอน ดี ด้านซ้าย'
	SET @deviceId = NULL;

	EXEC SaveDevice @customerId, 202, N'Main Office', N'Main Office Front', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'ออฟฟิสหลัก', N'หน้าออฟฟิสหลัก'
	SET @deviceId = NULL;

	EXEC SaveDevice @customerId, 202, N'PCB Design', N'PCB Design Front', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'พีซีบี ดีไซน์', N'หน้าห้อง พีซีบี ดีไซน์'
	SET @deviceId = NULL;

	EXEC SaveDevice @customerId, 202, N'counter 1', N'Off.Counter 1', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'เค้าเตอร์ที่ 1', N'หน้าโต๊ะเค้าเตอร์ที่ 1'
	SET @deviceId = NULL;

	EXEC SaveDevice @customerId, 201, N'counter 2', N'Off.Counter 1', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'เค้าเตอร์ที่ 2', N'หน้าโต๊ะเค้าเตอร์ที่ 2'
	SET @deviceId = NULL;

	EXEC SaveDevice @customerId, 202, N'Restroom (L)', N'Restroom L.', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'ห้องน้ำฝั่งซ้าย', N'หน้าห้องน้ำฝั่งซ้าย'
	SET @deviceId = NULL;

	EXEC SaveDevice @customerId, 201, N'Restroom (R)', N'Restroom R.', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'ห้องน้ำฝั่งขวา', N'หน้าห้องน้ำฝั่งขวา'
	SET @deviceId = NULL;

	EXEC SaveDevice @customerId, 201, N'Restroom (Fr.2)', N'Restroom Fr.2', @deviceId out
	EXEC SaveDeviceML @customerId, @deviceId, N'TH', N'ห้องน้ำชั้น 2', N'ด้านในห้องน้ำชั้น 2'
	SET @deviceId = NULL;

	--SET QUESTIONS 1
	SET @qSetId = NULL;
	SET @beginDate = N'2020-01-01'
	SET @endDate = N'2022-12-31'

	EXEC SaveQSet @customerId, N'General Questions', 0, 0, 0, @beginDate, @endDate, @qSetId out
	EXEC SaveQSetML @customerId, @qSetId, N'TH', N'ชุดคำถามทั่วไป'

	-- Set 1-Slide 1
	SET @qSeq = NULL;
	EXEC SaveQSlide @customerId, @qSetId, N'Plase rate for product`s quality.', 0, 1, @qSeq out
	EXEC SaveQSlideML @customerId, @qSetId, @qSeq, N'TH', N'กรุณาให้คะแนน ด้านคุณภาพสินค้าที่ได้รับ'
	-- CHOICES
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Poor', 0, 1, 1, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'แย่'
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Fair', 0, 2, 2, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'พอใช้'
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Good', 0, 3, 3, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'ดี'
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Excellent', 0, 4, 4, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'ดีมาก'

	-- Set 1-Slide 2
	SET @qSeq = NULL;
	EXEC SaveQSlide @customerId, @qSetId, N'Plase rate for our services', 0, 2, @qSeq out
	EXEC SaveQSlideML @customerId, @qSetId, @qSeq, N'TH', N'กรุณาให้คะแนน ด้านคุณภาพการให้บริการ'
	-- CHOICES
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Poor', 0, 1, 1, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'แย่'
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Fair', 0, 2, 2, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'พอใช้'
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Good', 0, 3, 3, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'ดี'
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Excellent', 0, 4
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'ดีมาก'

	-- Set 1-Slide 3
	SET @qSeq = NULL;
	EXEC SaveQSlide @customerId, @qSetId, N'Please rate for overall company', 0, 3, @qSeq out
	EXEC SaveQSlideML @customerId, @qSetId, @qSeq, N'TH', N'กรุณาให้คะแนน ภาพรวมขององค์กร'
	-- CHOICES
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Poor', 0, 1, 1, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'แย่'
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Fair', 0, 2, 2, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'พอใช้'
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Good', 0, 3, 3, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'ดี'
	SET @qSSeq = NULL;
	EXEC SaveQSlideItem @customerId, @qSetId, @qSeq, N'Excellent', 0, 4, 4, @qSSeq out
	EXEC SaveQSlideItemML @customerId, @qSetId, @qSeq, @qSSeq, N'TH', N'ดีมาก'

	--SET QUESTIONS 2
	SET @qSetId = NULL;
	SET @beginDate = N'2020-04-01'
	SET @endDate = N'2020-07-31'

	EXEC SaveQSet @customerId, N'Food Questions', 0, 0, 0, @beginDate, @endDate, @qSetId out
	EXEC SaveQSetML @customerId, @qsetId, N'TH', N'ชุดคำถามเกี่ยวกับอาหาร'
	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate food teste', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Poor'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Fair'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Good'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Excellent'

	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate food quality', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Poor'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Fair'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Good'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Excellent'

	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate service', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Poor'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Fair'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Good'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Excellent'

	--SET QUESTIONS 3
	SET @qSetId = NULL;
	SET @beginDate = N'2020-06-01'
	SET @endDate = N'2020-08-31'

    EXEC SaveQSet @customerId, N'Movie Questions', 0, 0, 0, @beginDate, @endDate, @qSetId out
	EXEC SaveQSetML @customerId, @qsetId, N'TH', N'ชุดคำถามเกี่ยวกับโรงภาพยนตร์'
	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate movie story', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'boring'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Not bad'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'So-good'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Very trill'

	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate movie 3D quality', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Very bad'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Plain'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Over standard'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Very advance'

	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate movie overall', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Bad'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'So-so'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'First rate'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Industial leader'

	--SET QUESTIONS 4
	SET @qSetId = NULL;
	SET @beginDate = N'2020-08-01'
	SET @endDate = N'2020-10-31'

    EXEC SaveQSet @customerId, N'Music Questions', 0, 0, 0, @beginDate, @endDate, @qSetId out
	EXEC SaveQSetML @customerId, @qsetId, N'TH', N'ชุดคำถามเกี่ยวกับดนตรี'
	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate sound quality', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Bad'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Good'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Excellent'

	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate composer score', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Score 1'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Score 2'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Score 3'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Score 4'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Score 5'

	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate overall music', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Poor'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Fair'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Good'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Exellent'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Top ten'

	--SET QUESTIONS 5
	SET @qSetId = NULL;
	SET @beginDate = N'2020-08-01'
	SET @endDate = N'2020-10-31'

    --EXEC SaveQSet @customerId, N'Cloud service Questions', 0, 0, 1, @beginDate, @endDate, @qSetId out
    EXEC SaveQSet @customerId, N'Cloud service Questions', 0, 0, 0, @beginDate, @endDate, @qSetId out
	EXEC SaveQSetML @customerId, @qsetId, N'TH', N'ชุดคำถามเกี่ยวกับคลาวด์เซอร์วิส'
	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate our cloud speed', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Very slow'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Slow'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Normal'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Fast'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Ultra fast'

	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate our cloud GUI', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'No good'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'A bit confusing'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Genreal'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Easy to use'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Very impressive'

	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate our cloud supports', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Slow response'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Noraml'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Good'

	--SET QUESTIONS 6
	SET @qSetId = NULL;
	SET @beginDate = N'2020-12-01'
	SET @endDate = N'2020-03-31'

    EXEC SaveQSet @customerId, N'Spa service Questions', 0, 0, 0, @beginDate, @endDate, @qSetId out
	EXEC SaveQSetML @customerId, @qsetId, N'TH', N'ชุดคำถามเกี่ยวกับสปา'
	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate our spa service', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Bad'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Normal'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Good'

	SET @qseq = NULL
	EXEC SaveQSlide @customerId, @qsetid, 'Please rate our spa quality', 0, 0, @qseq out
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Bad'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Normal'
	EXEC SaveQSlideItem @customerId, @qsetid, @qseq, 'Good'
END

GO
