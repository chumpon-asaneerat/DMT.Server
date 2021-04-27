SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[UpdateAR_Head] (

 @DocDate nvarchar(8)
, @DocDueDate nvarchar(8)
, @CardCode nvarchar(15)
, @CardName nvarchar(100)
, @NumAtCard nvarchar(50)
, @Comments nvarchar(50)
,@PaymentGroupCode smallint
,@TollWayId smallint

,@ErrMsg As Varchar(200) = '''' Output
,@ErrNum As Int = 0 Output
,@ReturnType As Int = 0 Output

)
AS
BEGIN
DECLARE @DocNum int = NULL;
DECLARE @RunNo int = NULL;

	select @DocNum = count(AR_Head.DocNum)+1
	FROM [dbo].[AR_Head]
	WHERE ExportExcel = 0
		--And AR_Head.DocDate = @DocDate;

	select @RunNo = count(AR_Head.DocNum)+1
	FROM [dbo].[AR_Head]

	BEGIN TRY
	SET @ErrMsg = ''''
	SET @ErrNum = 0	

	--IF (select count(DocNum) 	
	--	FROM [dbo].[AR_Head]
	--	WHERE AR_Head.DocDate = @DocDate
	--	And AR_Head.CardCode = @CardCode
	--	And ExportExcel = 0) = 0

	--BEGIN
	--SET @ReturnType = 1

	--UPDATE [dbo].[AR_Head]
	--SET  DocDueDate = isnull(@DocDueDate ,[DocDueDate])
	--	, NumAtCard = isnull(@NumAtCard ,[NumAtCard])
	--	, Comments = isnull(@Comments ,[Comments])
	--WHERE AR_Head.DocDate = @DocDate
	--And AR_Head.CardCode = @CardCode
	--And AR_Head.ExportExcel = 0

	--End
	--ELSE
	BEGIN
	SET @ReturnType = 1
	INSERT INTO [dbo].[AR_Head]
           (RunNo,DocNum , DocType , DocDate , DocDueDate , CardCode , CardName , NumAtCard , Comments ,PaymentGroupCode, TollWayId , ExportExcel , InsertDate , ExportDate )
    VALUES (@RunNo,@DocNum , 'dDocument_Items' , @DocDate , @DocDueDate , @CardCode , @CardName , @NumAtCard , @Comments,@PaymentGroupCode , @TollWayId, 0 ,GETDATE() , null)
	END
		
	RETURN
	END TRY
	BEGIN CATCH
		IF @@Error > 0 OR @@RowCount < 1 
		BEGIN
			SET @ErrMsg = ERROR_MESSAGE()
			SET @ErrNum = ERROR_NUMBER()
			SET @ReturnType = 0
			Return	
		END
	END CATCH

	COMMIT;
END;
GO