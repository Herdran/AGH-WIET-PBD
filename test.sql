DECLARE @Date DATE = dateadd(day, 7, GETDATE()), @MenuID INT = 1;
EXEC PlaceOrder  2, '3,100', @Date, 1, 1;

