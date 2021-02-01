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
