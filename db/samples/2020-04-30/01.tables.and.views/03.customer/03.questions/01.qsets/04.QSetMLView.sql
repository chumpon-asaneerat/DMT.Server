SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: Chumpon Asaneerat
-- Name: QSetMLView.
-- Description:	The QSet ML View.
-- [== History ==]
-- <2018-05-15> :
--	- View Created.
-- <2019-08-19> :
--	- View Changes.
--    - Remove QSetDescriptionNative column.
--    - Rename QSetDescriptionEn column to QSetDescription.
--
-- [== Example ==]
--
-- =============================================
CREATE VIEW [dbo].[QSetMLView]
AS
	SELECT QSetV.LangId
		 , QSetV.QSetId
		 , QSetV.CustomerId
		 , QSetV.BeginDate
		 , QSetV.EndDate
		 , CASE 
			WHEN (QSetML.Description IS NULL OR LTRIM(RTRIM(QSetML.Description)) = '') THEN 
				QSetV.Description
			ELSE 
				QSetML.Description 
		   END AS QSetDescription
		 , QSetV.DisplayMode
		 , QSetV.HasRemark
		 , QSetV.IsDefault
		 , QSetV.QSetStatus
		 , QSetV.Enabled
		 , QSetV.SortOrder
		FROM dbo.QSetML AS QSetML RIGHT OUTER JOIN QSetView AS QSetV
		  ON (QSetML.LangId = QSetV.LangId 
		  AND QSetML.QSetId = QSetV.QSetId
		  AND QSetML.CustomerId = QSetV.CustomerId)

GO
