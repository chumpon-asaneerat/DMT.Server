/*********** Script Update Date: 2021-01-31  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

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
			   AND [FinishFlag] = 1
			   AND ([sendtaflag] IS NULL or [sendtaflag] = 0) -- CHECK IS ZERO OR NULL
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
				   AND [FinishFlag] = 1
				   AND ([sendtaflag] IS NULL or [sendtaflag] = 0) -- CHECK IS ZERO OR NULL
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
			   AND [FinishFlag] = 1
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
				   AND [FinishFlag] = 1
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


/*********** Script Update Date: 2021-01-31  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[TCTSoldCoupon] 
(
  @tsbid nvarchar(5)
, @coupontype nvarchar(2)
, @serialno nvarchar(7)
, @price decimal(6,0)
, @userid nvarchar(10)
, @solddate datetime
, @laneid nvarchar(10)
, @errNum as int = 0 out
, @errMsg as nvarchar(MAX) = N'' out
)
AS
BEGIN
DECLARE @tsb nvarchar(5) = NULL;
	BEGIN TRY
		SELECT @tsb = [TSBId]
		  FROM [dbo].[Lane]
		 WHERE [LaneId] = @laneid;
		 --AND [PlazaId] = @plazaid
		-- UPDATE SOLD COUPON BY TCT
		UPDATE [dbo].[TA_Coupon]
		   SET [CouponStatus] = 3
			 , [SoldDate] = @solddate
			 , [SoldBy] = @userid
			 , [LaneId] = @laneid
			 , [sendtaflag] = 0 -- MARK SENDING FLAG = 0 TO SEND TO TA APP LATER
		 WHERE [SerialNo] = @serialno 
		   AND [CouponType]  = @coupontype
		   --AND [TSBId] = @tsb
		   AND [UserId] = @userid;

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

/*********** Script Update Date: 2021-01-31  ***********/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*********** Script Update Date: 2020-08-06  ***********/
ALTER PROCEDURE [dbo].[GetUserCouponList]
(
    @tsbid nvarchar(5)  ,
	@userid nvarchar(10) ,
	@coupontype nvarchar(2)
)
AS
BEGIN
    SELECT [CouponPK], [CouponType], [SerialNo], [Price]
	FROM[dbo].[TA_Coupon] 
     WHERE ( [UserId] = COALESCE(@userid, [UserId]) or @userid is NULL) 
	and [TsbId] = COALESCE(@tsbid, [TsbId])  
	 and [couponType] = COALESCE(@coupontype, [couponType])
	 and [CouponStatus] = 2
     ORDER BY [SerialNo] asc
END

GO
