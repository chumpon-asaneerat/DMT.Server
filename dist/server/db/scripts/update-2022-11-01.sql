/*********** Script Update Date: 2022-11-01  ***********/

ALTER PROCEDURE [dbo].[TAGetCouponList2]
(
  @tsbid nvarchar(5)  
, @userid nvarchar(10) 
, @transactiontype char(1)
, @coupontype nvarchar(2) 
, @flag char(1) -- FLAG NULL for SEND ALL, 0 for SEND THE NEW ONE
, @pageNum as int = 1 out
, @rowsPerPage as int = 5 out
, @totalRecords as int = 0 out
, @maxPage as int = 0 out
, @errNum as int = 0 out
, @errMsg as nvarchar(100) = N'' out
)
AS
BEGIN
	BEGIN TRY
	    -- INIT PAGINATION VARIABLES
		SET @totalRecords = 0;
		
		SET @pageNum = ISNULL(@pageNum, 1);
		IF (@pageNum <= 0) SET @pageNum = 1;

		SET @rowsPerPage = ISNULL(@rowsPerPage, 5);
		IF (@rowsPerPage <= 0) SET @rowsPerPage = 5;

		IF (@flag IS NOT NULL)
		BEGIN
			-- calculate total records
			SELECT @totalRecords = COUNT(*) 
			  FROM [dbo].[TA_Coupon]
			 WHERE ([UserId] = COALESCE(@userid, [UserId]) OR @userid is NULL) 
			   AND [TsbId] = COALESCE(@tsbid, [TsbId])  
			   AND [couponType] = COALESCE(@coupontype, [couponType])
			   AND [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
			   --AND [FinishFlag] = 1
			    AND ([sendtaflag] IS NULL  or [sendtaflag] = 0) -- CHECK IS ZERO ONLY
			-- calculate max pages
			SELECT @maxPage = 
				CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
					(@totalRecords / @rowsPerPage) + 1
				ELSE 
					(@totalRecords / @rowsPerPage)
				END;
			-- select qurey with pagination
			WITH SQLPaging AS
			(
			    SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY [couponType], [SerialNo]) AS RowNo
				     , *
				  FROM [dbo].[TA_Coupon] 
				 WHERE ([UserId] = COALESCE(@userid, [UserId]) OR @userid is NULL) 
				   AND [TsbId] = COALESCE(@tsbid, [TsbId])  
				   AND [couponType] = COALESCE(@coupontype, [couponType])
				   AND [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
				   --AND [FinishFlag] = 1
				   AND ([sendtaflag] IS NULL  or [sendtaflag] = 0) -- CHECK IS ZERO ONLY
				 ORDER BY [couponType], [SerialNo] ASC
			)
			SELECT * FROM SQLPaging WITH (NOLOCK) 
				WHERE RowNo > ((@pageNum - 1) * @rowsPerPage);
		END
		ELSE
		BEGIN
			-- calculate total records
			SELECT @totalRecords = COUNT(*) 
			  FROM [dbo].[TA_Coupon]
			 WHERE ([UserId] = COALESCE(@userid, [UserId]) OR @userid is NULL) 
			   AND [TsbId] = COALESCE(@tsbid, [TsbId])  
			   AND [couponType] = COALESCE(@coupontype, [couponType])
			   AND [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
			  -- AND [FinishFlag] = 1
			-- calculate max pages
			SELECT @maxPage = 
				CASE WHEN (@totalRecords % @rowsPerPage > 0) THEN 
					(@totalRecords / @rowsPerPage) + 1
				ELSE 
					(@totalRecords / @rowsPerPage)
				END;

			-- select qurey with pagination
			WITH SQLPaging AS
			(
			    SELECT TOP(@rowsPerPage * @pageNum) ROW_NUMBER() OVER (ORDER BY [couponType], [SerialNo]) AS RowNo
				     , *
				  FROM [dbo].[TA_Coupon] 
				 WHERE ([UserId] = COALESCE(@userid, [UserId]) OR @userid is NULL) 
				   AND [TsbId] = COALESCE(@tsbid, [TsbId])  
				   AND [couponType] = COALESCE(@coupontype, [couponType])
				   AND [CouponStatus] = COALESCE(@transactiontype, [CouponStatus]) 
				 --  AND [FinishFlag] = 1
				 ORDER BY [couponType], [SerialNo] ASC
			)
			SELECT * FROM SQLPaging WITH (NOLOCK) 
				WHERE RowNo > ((@pageNum - 1) * @rowsPerPage);
		END
		-- SET SUCCESS
		SET @errNum = 0;
		SET @errMsg = N'Success'
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END
GO

/*********** Script Update Date: 2022-11-01  ***********/

ALTER PROCEDURE [dbo].[TA_EditSoldCoupon] (
  @tsbid nvarchar(5)
, @oldserialno nvarchar(7)
, @newserialno nvarchar(7)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out)
AS
BEGIN


	BEGIN TRY

	update a
	   set SoldDate = b.SoldDate
	   , SoldBy = b.SoldBy
	   , CouponStatus = b.CouponStatus
	   , LaneId = b.LaneId
	   , PayTypeID = b.PayTypeID
	   , PaytypeName = b.PaytypeName
	   , EdcAmount = b.EdcAmount
	   , EdcCardNo = b.EdcCardNo
	   , EdcDateTime = b.EdcDateTime
	   , EdcRef1 = b.EdcRef1
	   , EdcRef2 = b.EdcRef2
	   , EdcRef3 = b.EdcRef3
	   , EdcTerminalId = b.EdcTerminalId
	   , FinishFlag = b.FinishFlag
	   from TA_Coupon a , TA_Coupon b
	   where a.SerialNo = @newserialno
	   and b.SerialNo = @oldserialno ; 

	update TA_Coupon
	   set SoldDate = NULL
	   , SoldBy = NULL
	   , CouponStatus = 1
	   , LaneId = NULL
	   , PayTypeID = NULL
	   , PaytypeName = NULL
	   , EdcAmount = NULL
	   , EdcCardNo = NULL
	   , EdcDateTime = NULL
	   , EdcRef1 = NULL
	   , EdcRef2 = NULL
	   , EdcRef3 = NULL
	   , EdcTerminalId = NULL
	   , FinishFlag = 1
	   where SerialNo = @oldserialno ; 

		
	END TRY
	BEGIN CATCH
		SET @errNum = ERROR_NUMBER();
		SET @errMsg = ERROR_MESSAGE();
	END CATCH
END
GO
