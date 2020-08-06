SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[LogInView]
AS
SELECT UV.LangId
     , NULL AS CustomerId
     , UV.UserId AS MemberId, MemberType, IsEDLUser = Convert(bit, 1)
     , UV.Prefix, UV.FirstName, UV.LastName, UV.FullName
	 , UV.UserName, UV.Password, UV.ObjectStatus
	 , UV.Enabled, UV.SortOrder
  FROM UserInfoMLView UV
UNION
SELECT MV.LangId
     , MV.CustomerId
     , MV.MemberId, MemberType, IsEDLUser = Convert(bit, 0)
     , MV.Prefix, MV.FirstName, MV.LastName, MV.FullName
	 , MV.UserName, MV.Password, MV.ObjectStatus
	 , MV.Enabled, MV.SortOrder
  FROM MemberInfoMLView MV

GO
