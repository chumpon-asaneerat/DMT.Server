ALTER TABLE TA_Coupon
ADD 
    PayTypeID int ,
    PaytypeName nvarchar(20),
	EdcDateTime Datetime,
	EdcTerminalId nvarchar(8),
	EdcCardNo nvarchar(8),
	EdcAmount decimal(6,2),
	EdcRef1 nvarchar(20),
	EdcRef2 nvarchar(20),
	EdcRef3 nvarchar(20);