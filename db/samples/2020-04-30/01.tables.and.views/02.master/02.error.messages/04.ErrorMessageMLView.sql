SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: ErrorMessageMLView.
-- Description:	The Error Message ML View.
-- [== History ==]
-- <2018-05-18> :
--	- View Created.
-- <2019-08-19> :
--	- View changes.
--    - Remove ErrMsgNative column.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[ErrorMessageMLView]
AS
	SELECT EMV.LangId
		 , EMV.ErrCode
		 , CASE 
			WHEN EMML.ErrMsg IS NULL THEN 
				EMV.ErrMsg 
			ELSE 
				EMML.ErrMsg 
		   END AS ErrMsg
		 , EMV.Enabled
		 , EMV.SortOrder
		FROM dbo.ErrorMessageML AS EMML RIGHT OUTER JOIN ErrorMessageView AS EMV
		  ON (EMML.LangId = EMV.LangId AND EMML.ErrCode = EMV.ErrCode)

GO
