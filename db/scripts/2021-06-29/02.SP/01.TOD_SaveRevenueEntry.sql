/****** Object:  StoredProcedure [dbo].[TOD_SaveRevenueEntry]    Script Date: 5/6/2564 11:05:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-13  ***********/

ALTER PROCEDURE [dbo].[TOD_SaveRevenueEntry] (
   @pkid nvarchar(36)
, @entrydate datetime
, @revenuedate datetime
, @revenueid nvarchar(20)
, @bagno nvarchar(10)
, @beltno nvarchar(20)
, @ishistorical bit
, @lanes nvarchar(100)
, @plazanames nvarchar(100)
, @shiftbegin datetime
, @shiftend datetime
, @tsbid nvarchar(10)
, @plazagroupid nvarchar(10)
, @shiftid int
, @userid nvarchar(10)
, @collectornameen nvarchar(150)
, @collectornameth nvarchar(150)
, @supervisorid nvarchar(10)
, @supervisornameen nvarchar(150)
, @supervisornameth nvarchar(150)
, @trafficst25 int
, @trafficst50 int
, @trafficbht1 int
, @trafficbht2 int
, @trafficbht5 int
, @trafficbht10 int
, @trafficbht20 int
, @trafficbht50 int
, @trafficbht100 int
, @trafficbht500 int
, @trafficbht1000 int
, @trafficbhttotal int
, @trafficremark nvarchar(255)
, @otherbhttotal int
, @otherremark nvarchar(255)
, @couponusagebht30 int
, @couponusagebht35 int
, @couponusagebht60 int
, @couponusagebht70 int
, @couponusagebht80 int
, @freepassusageclassa int
, @freepassusageother int
, @couponsoldbht35 int
, @couponsoldbht80 int
, @couponsoldbht35factor float
, @couponsoldbht80factor float
, @couponsoldbht35total float
, @couponsoldbht80total float
, @couponsoldbhttotal float
, @status int
, @lastupdate datetime
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN

	BEGIN TRY
	IF EXISTS (
		SELECT *	 
		FROM [dbo].[TODRevenueEntry]
		WHERE [TSBId] = @tsbid
		and [PKId] = @pkid
		and [RevenueId] = @revenueid
		
		
	)
	BEGIN

	UPDATE [dbo].[TODRevenueEntry]
	SET [EntryDate] = @entrydate
	,	[RevenueDate] =@revenuedate
	,   [BagNo] = @bagno
	,	[BeltNo] =@beltno
	,	[IsHistorical] = @ishistorical
	,	[Lanes] = @lanes
	,	[PlazaNames] = @plazanames
	,	[ShiftBegin] = @shiftbegin
	,	[ShiftEnd] = @shiftend
	,	[PlazaGroupId] = @plazagroupid
	,   [ShiftId]= @shiftid
	,	[UserId]= @userid
	,	[CollectorNameEN] = @collectornameen
	,	[CollectorNameth] = @collectornameth
	,	[SupervisorId] = @supervisorid
	,	[SupervisorNameEN] = @supervisornameen
	,	[SupervisorNameTH] = @supervisornameth
	,	[TrafficST25] = @trafficst25
	,	[TrafficST50] = @trafficst50
	,	[TrafficBHT1] = @trafficbht1
	,	[TrafficBHT2] = @trafficbht2
	,	[TrafficBHT5] = @trafficbht5
	,	[TrafficBHT10] = @trafficbht10
	,	[TrafficBHT20] = @trafficbht20
	,	[TrafficBHT50] = @trafficbht50
	,	[TrafficBHT100] = @trafficbht100
	,	[TrafficBHT500] = @trafficbht500
	,	[TrafficBHT1000] = @trafficbht1000
	,	[TrafficBHTTotal] = @trafficbhttotal
	,	[TrafficRemark]	= @trafficremark
	,	[OtherBHTTotal] = @otherbhttotal
	,	[OtherRemark] = @otherremark
	,	[CouponUsageBHT30] = @couponusagebht30
	,	[CouponUsageBHT35] = @couponusagebht35
	,	[CouponUsageBHT60] = @couponusagebht60
	,	[CouponUsageBHT70] = @couponusagebht70
	,	[CouponUsageBHT80] = @couponusagebht80
	,	[FreePassUsageClassA] = @freepassusageclassa
	,	[FreePassUsageOther]= @freepassusageother
	,	[CouponSoldBHT35]= @couponsoldbht35
	,	[CouponSoldBHT80]= @couponsoldbht80
	,	[CouponSoldBHT35Factor]= @couponsoldbht35factor
	,	[CouponSoldBHT80Factor]= @couponsoldbht80factor
	,	[CouponSoldBHT35Total]= @couponsoldbht35total
	,	[CouponSoldBHT80Total]= @couponsoldbht80total
	,	[CouponSoldBHTTotal]= @couponsoldbhttotal
	,	[Status] = @status
	,	[LastUpdate] = @lastupdate
	WHERE [TSBId] = @tsbid
		and [PKId] = @pkid
		and [RevenueId] = @revenueid

	END
	ELSE
		
INSERT INTO [dbo].[TODRevenueEntry]
           ([PKId] ,[EntryDate] ,[RevenueDate] ,[RevenueId] ,[BagNo] ,[BeltNo] ,[IsHistorical] ,[Lanes]
           ,[PlazaNames] ,[ShiftBegin] ,[ShiftEnd] ,[TSBId] ,[PlazaGroupId] ,[ShiftId] ,[UserId]
           ,[CollectorNameEN] ,[CollectorNameTH],[SupervisorId] ,[SupervisorNameEN] ,[SupervisorNameTH]
           ,[TrafficST25] ,[TrafficST50] ,[TrafficBHT1] ,[TrafficBHT2] ,[TrafficBHT5] ,[TrafficBHT10]
           ,[TrafficBHT20],[TrafficBHT50] ,[TrafficBHT100] ,[TrafficBHT500] ,[TrafficBHT1000]
           ,[TrafficBHTTotal] ,[TrafficRemark] ,[OtherBHTTotal] ,[OtherRemark]
           ,[CouponUsageBHT30] ,[CouponUsageBHT35] ,[CouponUsageBHT60] ,[CouponUsageBHT70] ,[CouponUsageBHT80]
           ,[FreePassUsageClassA] ,[FreePassUsageOther] ,[CouponSoldBHT35] ,[CouponSoldBHT80] ,[CouponSoldBHT35Factor]
           ,[CouponSoldBHT80Factor] ,[CouponSoldBHT35Total] ,[CouponSoldBHT80Total] ,[CouponSoldBHTTotal]
           ,[Status],[LastUpdate])
     VALUES
           (@pkid , @entrydate, @revenuedate,@revenueid, @bagno, @beltno, @ishistorical, @lanes, @plazanames
		   , @shiftbegin, @shiftend, @tsbid, @plazagroupid, @shiftid, @userid, @collectornameen, @collectornameth
		   , @supervisorid, @supervisornameen, @supervisornameth, @trafficst25, @trafficst50, @trafficbht1
		   , @trafficbht2, @trafficbht5, @trafficbht10, @trafficbht20, @trafficbht50, @trafficbht100, @trafficbht500
		   , @trafficbht1000, @trafficbhttotal, @trafficremark, @otherbhttotal, @otherremark, @couponusagebht30
		   , @couponusagebht35, @couponusagebht60, @couponusagebht70, @couponusagebht80, @freepassusageclassa
		   , @freepassusageother, @couponsoldbht35, @couponsoldbht80, @couponsoldbht35factor, @couponsoldbht80factor
		   , @couponsoldbht35total, @couponsoldbht80total, @couponsoldbhttotal, @status, @lastupdate)

		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END


/*********** Script Update Date: 2020-08-13  ***********/

GO

