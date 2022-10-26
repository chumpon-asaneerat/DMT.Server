SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetCheckAR]

AS
BEGIN
    Select AR_Head.RunNo, TollWayId,DocDate,DocDueDate from AR_Head
		Inner Join (Select RunNo From AR_Line Where [ExportExcel] = 0) AS Line On AR_Head.RunNo = Line.RunNo
		Inner Join (Select RunNo From AR_Serial Where [ExportExcel] = 0) AS Serial On AR_Head.RunNo = Serial.RunNo
		Where AR_Head.[ExportExcel] = 0
		Group By AR_Head.RunNo, TollWayId,DocDate,DocDueDate
		Order By DocDate asc

END

GO