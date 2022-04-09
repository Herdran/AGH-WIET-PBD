
--Tabele
CREATE TABLE Invoices (
    InvoiceID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    CustomerID int  NOT NULL,
    Date date  NOT NULL,
    Address varchar(50)  NOT NULL,
    City varchar(50)  NOT NULL,
    PostalCode varchar(50)  NOT NULL,
    Country varchar(50)  NOT NULL,
    NIP varchar(10)  NOT NULL
);
CREATE TABLE Categories (
    CategoryID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    CategoryName varchar(50)  NOT NULL UNIQUE,
    Description varchar(50)  NOT NULL
);
CREATE TABLE Tables (
    TableID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    ChairCount int  NOT NULL,
    Active bit  NOT NULL DEFAULT 1,
    CHECK(ChairCount > 0)
);
CREATE TABLE Customers (
    CustomerID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    Email varchar(50)  NOT NULL,
    NIP varchar(10)  NULL,
    Address varchar(50)  NOT NULL,
    City varchar(50)  NOT NULL,
    PostalCode varchar(6)  NOT NULL,
    Country varchar(50)  NOT NULL,
    isCompany bit  NOT NULL,
);
CREATE TABLE Dishes (
    DishID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    DishName varchar(50)  NOT NULL,
    CategoryID int  NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID),
    Description varchar(50)  NOT NULL,
    MinStockValue int  NOT NULL,
    UnitsInStock int  NOT NULL,
    Active bit NOT NULL DEFAULT 1,
    CHECK(MinStockValue > 0),
    CHECK(UnitsInStock >= 0)
);


CREATE TABLE Employees (
    EmployeeID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL,
    Phone varchar(9)  NOT NULL,
    Position varchar(50) NOT NULL
);
CREATE TABLE Orders (
    OrderID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    CustomerID int  NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    InvoiceID int  FOREIGN KEY REFERENCES Invoices(InvoiceID),
    EmployeeID int  NOT NULL,
    OrderDate date  NOT NULL,
    ReceiveDate date,
    PaymentReceived bit  NOT NULL,
    Discount float(2)  NULL,
    Status bit NOT NULL DEFAULT 1,
    CHECK(OrderDate <= ReceiveDate)
);
CREATE TABLE Reservations (
    ReservationID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    OrderID int Unique NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
    ReservationDate date  NOT NULL,
    CustomerID int  NOT NULL,
    PeopleCount int  NOT NULL,
    FromTime time  NOT NULL,
    ToTime time  NOT NULL,
    ReceiveDate date  NOT NULL,
    Status bit NOT NULL DEFAULT 1,
	Confirmation bit NOT NULL DEFAULT 0,
);
CREATE TABLE CompanyEmployees (
    CompanyEmployeeID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    ReservationID int  NOT NULL FOREIGN KEY REFERENCES Reservations(ReservationID),
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL
);

CREATE TABLE EmployeesDetails (
    EmployeeID int  NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeID),
    OrderID int  NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
	CONSTRAINT PK_EmployeesDetails PRIMARY KEY(EmployeeID, OrderID)
);

CREATE TABLE IndividualCustomers (
    CustomerID int  NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Customers(CustomerID),
    FirstName varchar(50)  NOT NULL,
    LastName varchar(50)  NOT NULL
);

CREATE TABLE Menu (
    MenuID int  NOT NULL PRIMARY KEY IDENTITY(1, 1),
    InDate date  NOT NULL,
    OutDate date  NOT NULL,
    Active bit NOT NULL
);

CREATE TABLE MenuDetails (
    MenuID int  NOT NULL,
    DishID int  NOT NULL,
    UnitPrice money  NOT NULL
    PRIMARY KEY CLUSTERED ( MenuID, DishID ),
    FOREIGN KEY ( MenuID ) REFERENCES [Menu] ( MenuID ) ON UPDATE  NO ACTION  ON DELETE  CASCADE,
    FOREIGN KEY ( DishID ) REFERENCES [Dishes] ( DishID ) ON UPDATE  NO ACTION  ON DELETE  CASCADE,
    CHECK(UnitPrice > 0)
);

CREATE TABLE OrderDetails (
    OrderID int  NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
    DishID int  NOT NULL,
    MenuID int NOT NULL,
    Quantity int  NOT NULL,
    UnitPrice money  NOT NULL,
    CHECK(Quantity > 0),
    CHECK(UnitPrice > 0),
    PRIMARY KEY CLUSTERED ( OrderID, DishID ),
    FOREIGN KEY ( MenuID, DishID ) REFERENCES [MenuDetails] ( MenuID, DishID) ON UPDATE  NO ACTION  ON DELETE  CASCADE,
);

CREATE TABLE PermanentDiscount (
    CustomerID int  NOT NULL FOREIGN KEY REFERENCES IndividualCustomers(CustomerID),
    Value int  NOT NULL,
    IssueDate date  NOT NULL,
    CHECK(IssueDate <= getdate()),
    CHECK(Value > 0)
);


CREATE TABLE ReservationDetails (
    ReservationID int  NOT NULL FOREIGN KEY REFERENCES Reservations(ReservationID),
    TableID int  NOT NULL FOREIGN KEY REFERENCES Tables(TableID),
    CONSTRAINT PK_ReservationDetail PRIMARY KEY(ReservationID, TableID)
);

CREATE TABLE TemporaryDiscount (
    CustomerID int  NOT NULL FOREIGN KEY REFERENCES IndividualCustomers(CustomerID),
    Value int  NOT NULL,
    IssueDate date  NOT NULL,
    DueDate date  NOT NULL,
	Status BIT NOT NULL DEFAULT 1,
    CHECK(IssueDate <= getdate()),
    CHECK(DueDate >= getdate()),
    CHECK(Value >= 0),
	CHECK(Value <= 100)
);


CREATE TABLE CompanyCustomers (
    CustomerID int  NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    CompanyName varchar(50)  NOT NULL UNIQUE
);

CREATE TABLE Parameters ( 
WZ money NOT NULL, 
WK int NOT NULL, 
Z1 int NOT NULL, 
K1 money NOT NULL, 
R1 int NOT NULL, 
D1 int NOT NULL, 
K2 money NOT NULL, 
R2 int NOT NULL );

GO
-- Procedury

-- 1) Dodawanie nowego klienta indywidualnego:
CREATE PROCEDURE AddNewIndividualCustomer
@FirstName VARCHAR(50),
@LastName VARCHAR(50),
@NIP VARCHAR(10) = NULL,
@Email VARCHAR(50),
@Address VARCHAR(50),
@City VARCHAR(50),
@PostalCode VARCHAR(6),
@Country VARCHAR(50),
@isCompany BIT = 0
AS
BEGIN
INSERT INTO Customers (Email, Address, City, NIP, PostalCode, Country, isCompany) Values(@Email, @Address, @City, @NIP, @PostalCode, @Country, @isCompany);
INSERT INTO IndividualCustomers(CustomerID, FirstName, LastName) Values( @@IDENTITY, @FirstName, @LastName);
END

GO

-- 2) Dodawanie nowego klienta firmowego:
CREATE PROCEDURE AddNewCompanyCustomer
@CompanyName VARCHAR(50),
@NIP VARCHAR(10) = NULL,
@Email VARCHAR(50),
@Address VARCHAR(50),
@City VARCHAR(50),
@PostalCode VARCHAR(6),
@Country VARCHAR(50),
@isCompany BIT = 1
AS
BEGIN
INSERT INTO Customers (Email, Address, City, NIP, PostalCode, Country, isCompany) Values(@Email, @Address, @City, @NIP, @PostalCode, @Country, @isCompany);
INSERT INTO CompanyCustomers(CustomerID, CompanyName) Values( @@IDENTITY, @CompanyName);
END

GO

-- 3) Dodawanie nowego pracownika:
CREATE PROCEDURE AddNewEmployee
@FirstName VARCHAR(50),
@LastName VARCHAR(50),
@Phone VARCHAR(9),
@Position VARCHAR(50)
AS
BEGIN
INSERT INTO Employees(FirstName, LastName, Phone, Position) Values (@FirstName, @LastName, @Phone, @Position);
END

GO

-- 4)Dodanie nowego dania:
CREATE PROCEDURE AddDish
@DishName Varchar(50),
@CategoryID INT,
@Description Varchar(50),
@MinStockValue INT,
@UnitsInStock INT,
@Active BIT = 1
AS
BEGIN
IF NOT EXISTS (SELECT CategoryID FROM Categories WHERE CategoryID = @CategoryID)
	THROW 50001, 'No such categoryID.', 1
INSERT INTO Dishes(DishName, CategoryID, Description, MinStockValue, UnitsInStock) Values (@DishName, @CategoryID, @Description, @MinStockValue, @UnitsInStock)
END

GO

-- 5) Dodanie nowej kategorii dañ:
CREATE PROCEDURE AddCategory
@CategoryName Varchar(50),
@Description Varchar(50)
AS
BEGIN
INSERT INTO Categories(CategoryName, Description) Values (@CategoryName, @Description)
END

GO

-- 6) Dodanie nowego menu:
CREATE PROCEDURE AddMenu
@InDate Date,
@OutDate Date
AS
BEGIN
INSERT INTO Menu(InDate, OutDate, Active) Values (@InDate, @OutDate, 0)

END

GO

-- 7) Dodanie dania do menu
CREATE PROCEDURE AddDishToMenu
@MenuID INT,
@DishID INT,
@UnitPrice Money
AS
BEGIN
IF NOT EXISTS (SELECT MenuID FROM Menu WHERE MenuID = @MenuID)
	THROW 50001, 'No such MenuID', 1
IF NOT EXISTS (SELECT DishID FROM Dishes WHERE DishID = @DishID)
	THROW 50001, 'No such DishID', 1
INSERT INTO MenuDetails(MenuID, DishID, UnitPrice) Values (@MenuID, @DishID, @UnitPrice)
END

GO

--8) Dodanie nowego zamówienia:
CREATE PROCEDURE AddNewOrder
@CustomerID INT,
@EmployeeID INT,
@PaymentReceived BIT,
@OrderDate DATE,
@ReceiveDate DATE = NULL,
@Discount FLOAT(2) = NULL,
@InvoiceID INT = NULL
AS
BEGIN
INSERT INTO Orders(CustomerID, EmployeeID, OrderDate, ReceiveDate, PaymentReceived, Discount, InvoiceID) Values (@CustomerID, @EmployeeID, @OrderDate, @ReceiveDate, @PaymentReceived, @Discount, @InvoiceID)
END

GO

-- 9) Dodanie szczegó³ów zamówienia:
CREATE PROCEDURE AddNewOrderDetails
@OrderID INT,
@DishID INT,
@MenuID INT,
@Quantity INT,
@UnitPrice Money
AS
BEGIN
INSERT INTO OrderDetails(OrderID, DishID, MenuID, Quantity, UnitPrice) Values (@OrderID, @DishID, @MenuID, @Quantity, @UnitPrice)
END

GO


-- 10) Dodanie nowego stolika:
CREATE PROCEDURE AddNewTable
@ChairCount INT,
@Active BIT
AS
BEGIN
INSERT INTO Tables (ChairCount, Active) Values(@ChairCount, @Active);
END

GO

-- 11) Dodanie rezerwacji:
CREATE PROCEDURE AddNewReservation
@OrderID INT, 
@ReservationDate Date, 
@CustomerID INT, 
@PeopleCount INT, 
@FromTime Time, 
@ToTime Time, 
@ReceiveDate Date
AS
BEGIN
IF NOT EXISTS (SELECT CustomerID FROM Customers WHERE CustomerID = @CustomerID)
    THROW 50001, 'No such customer.', 1
INSERT INTO Reservations(OrderID, ReservationDate, CustomerID, PeopleCount, FromTime, ToTime, ReceiveDate)
VALUES (@OrderID, @ReservationDate, @CustomerID, @PeopleCount, @FromTime, @ToTime, @ReceiveDate)
END

GO

-- 12) Dodanie stolika do rezerwacji:
CREATE PROCEDURE AddTableToReservation
@ReservationID INT,
@TableID INT
AS
BEGIN
INSERT INTO ReservationDetails(ReservationID, TableID)
VALUES (@ReservationID, @TableID)
END

GO



-- 15) Dodanie sta³ej zni¿ki:

CREATE PROCEDURE AddPermanentDiscount
@CustomerID INT,
@Value INT,
@IssueDate Date
AS
BEGIN
IF EXISTS (SELECT CustomerID FROM PermanentDiscount WHERE CustomerID = @CustomerID)
	BEGIN
	IF @Value IS NOT NULL
	    UPDATE PermanentDiscount
	    SET Value = @Value
	    WHERE CustomerID = @CustomerID
	IF @IssueDate IS NOT NULL
	    UPDATE PermanentDiscount
	    SET IssueDate = @IssueDate
	    WHERE CustomerID = @CustomerID
	END
ELSE 
	INSERT INTO PermanentDiscount(CustomerID, Value, IssueDate) Values(@CustomerID, @Value, @IssueDate)
END

GO


-- 16) Dodanie tymczasowej zni¿ki:
CREATE PROCEDURE AddTemporaryDiscount
@CustomerID INT,
@Value INT,
@IssueDate Date,
@DueDate Date
AS
BEGIN
IF EXISTS (SELECT CustomerID FROM PermanentDiscount WHERE CustomerID = @CustomerID)
	BEGIN
	IF @Value IS NOT NULL
	    UPDATE TemporaryDiscount
	    SET Value = @Value
	    WHERE CustomerID = @CustomerID
	IF @IssueDate IS NOT NULL
	    UPDATE TemporaryDiscount
	    SET IssueDate = @IssueDate
	    WHERE CustomerID = @CustomerID
	END
ELSE 
	INSERT INTO TemporaryDiscount(CustomerID, Value, IssueDate, DueDate) Values(@CustomerID, @Value, @IssueDate, @DueDate)
END

GO



-- 17) Dodanie nowej faktury
CREATE PROCEDURE AddNewInvoice
@CustomerID int,
@Date date,
@Address VARCHAR(50),
@City VARCHAR(50),
@PostalCode VARCHAR(6),
@Country VARCHAR(50),
@NIP VARCHAR(50)
AS
BEGIN
INSERT INTO Invoices(CustomerID, Date, Address, City, PostalCode, Country, NIP) Values(@CustomerID, @Date,@Address,@City,@PostalCode,@Country, @NIP)
END

GO

CREATE PROCEDURE AddMonthlyInvoice
@CustomerID INT,
@Month INT
AS
BEGIN
	BEGIN TRANSACTION
	IF @Month not BETWEEN 1 AND 12
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50001, 'Incorrect month', 1;
	END
	DECLARE @OrderID INT, @InvoiceID INT, @Today DATE = GETDATE(), 
	@Address VARCHAR(50) = (SELECT Address FROM Customers WHERE CustomerID = @CustomerID), 
	@City VARCHAR(50) = (SELECT City FROM Customers WHERE CustomerID = @CustomerID), 
	@PostalCode VARCHAR(50) = (SELECT PostalCode FROM Customers WHERE CustomerID = @CustomerID),
	@Country VARCHAR(50) = (SELECT Country FROM Customers WHERE CustomerID = @CustomerID), 
	@NIP VARCHAR(50) = (SELECT NIP FROM Customers WHERE CustomerID = @CustomerID);

	EXEC AddNewInvoice @CustomerID, @Today, @Address, @City, @PostalCode, @Country, @NIP;
	UPDATE Orders
	SET InvoiceID = @@IDENTITY
	WHERE OrderID in (select O.OrderID
					  from Orders as O
					  where Status = 1 and PaymentReceived = 1 and month(ReceiveDate) = @Month and CustomerID = @CustomerID);
	COMMIT TRANSACTION
END

GO

CREATE FUNCTION CalculateDiscount(@CustomerID int)
RETURNS INT AS
BEGIN
DECLARE @DISCOUNT INT  = 0;
 
SET @Discount = 0;

IF @CustomerID in (SELECT CustomerID FROM PermanentDiscount)
	SET @Discount += (SELECT Value FROM PermanentDiscount WHERE CustomerID = @CustomerID)

IF @CustomerID in (SELECT CustomerID FROM TemporaryDiscount WHERE DueDate >= getdate())
	SET @Discount += (SELECT Value FROM TemporaryDiscount WHERE CustomerID = @CustomerID and DueDate >= getdate() and Status = 1)

RETURN @Discount;
END

GO

CREATE FUNCTION TablesAvaliable (@ReservationDate DATE, @FromTime TIME, @ToTime TIME)
RETURNS TABLE AS
RETURN (SELECT TableID FROM Tables 
        WHERE Active=1 AND TableID NOT IN (SELECT RD.TableID FROM ReservationDetails RD
                              INNER JOIN Reservations R ON R.ReservationID = RD.ReservationID
                              WHERE (R.FromTime>=@FromTime AND R.FromTime<=@ToTime) 
                                    OR (R.ToTime>=@FromTime AND R.ToTime<=@ToTime) 
                                    OR ((R.FromTime<=@FromTime AND R.ToTime>=@ToTime))))
GO

CREATE PROCEDURE AddTablesToReservation
@ReservationID INT
AS
DECLARE @ReservationDate DATE = (SELECT ReceiveDate FROM Reservations WHERE ReservationID = @ReservationID)
DECLARE @FromTime TIME = (SELECT FromTime FROM Reservations WHERE ReservationID = @ReservationID)
DECLARE @ToTime TIME = (SELECT ToTime FROM Reservations WHERE ReservationID = @ReservationID)
DECLARE @PeopleCount INT = (SELECT PeopleCount FROM Reservations WHERE ReservationID = @ReservationID)
BEGIN
	DECLARE @ActualTable INT
	SET @ActualTable = (SELECT TOP 1 TableID FROM TABLES 
						WHERE  ChairCount >= @PeopleCount AND TableID IN (SELECT * FROM dbo.TablesAvaliable(@ReservationDate, @FromTime, @ToTime))
						ORDER BY ChairCount)

	IF(@ActualTable!=NULL)
		INSERT INTO ReservationDetails(ReservationID, TableID) VALUES (@ReservationID, @ActualTable)
	ELSE
	BEGIN
		DECLARE @Counter INT = 0
		WHILE (@Counter < @PeopleCount)
		BEGIN
			SET @ActualTable = (SELECT TOP 1 TableID FROM TABLES 
							WHERE TableID IN (SELECT * FROM dbo.TablesAvaliable(@ReservationDate, @FromTime, @ToTime))
							ORDER BY ChairCount DESC)
			INSERT INTO ReservationDetails(ReservationID, TableID)VALUES (@ReservationID, @ActualTable)
			SET @Counter = @Counter + (SELECT ChairCount FROM Tables WHERE TableID = @ActualTable)
		END
	END
END

GO

CREATE PROCEDURE ActivateMenu
@MenuID INT
AS
BEGIN
	BEGIN TRANSACTION;
	IF (SELECT Active FROM MENU WHERE MenuID = @MenuID) = 1
	BEGIN
		ROLLBACK TRANSACTION;
		RETURN;
	END
	IF not EXISTS(SELECT * FROM Menu WHERE Active = 1)
	BEGIN
		UPDATE Menu
		SET Active = 1
		WHERE MenuID = @MenuID;
		COMMIT TRANSACTION;
		RETURN;
	END
	
	DECLARE @Current INT, @Previous INT,
			@MenuInDate DATE = (SELECT InDate From Menu Where MenuID = @MenuID),
			@LastActiveOutDate DATE = (SELECT TOP 1 OutDate FROM Menu WHERE Active = 1 ORDER BY OutDate DESC);
	IF DATEADD(DAY, -1, @MenuInDate) > @LastActiveOutDate
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50001, 'Missing menu.', 1;
	END
	IF DATEADD(DAY, -1, @MenuInDate) < @LastActiveOutDate
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50001, 'There is already an active menu.', 1;
	END
	SET @Current = @MenuID;
	DECLARE PreviousMenu CURSOR FOR
		SELECT MenuID
		FROM Menu
		WHERE Active = 1 and OutDate > DATEADD(DAY, -14, @MenuInDate)
		ORDER BY InDate DESC
	OPEN PreviousMenu
	FETCH NEXT FROM PreviousMenu INTO @Previous;
	WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE @OldNOfDishes INT = (SELECT COUNT(*) FROM MenuDetails WHERE MenuID = @Previous),
				@NewNOfDishes INT = (SELECT COUNT(*) FROM MenuDetails WHERE MenuID = @Current),
				@Removed INT = 
				(SELECT COUNT(*)
				 FROM (SELECT DishID
					   FROM MenuDetails
					   WHERE MenuID = @Previous
					   EXCEPT
					   SELECT DishID
					   FROM MenuDetails
					   WHERE MenuID = @Current) AS diff),
				@Added INT = 
				(SELECT COUNT(*)
				 FROM (SELECT DishID
					   FROM MenuDetails
					   WHERE MenuID = @Current
					   EXCEPT
					   SELECT DishID
					   FROM MenuDetails
					   WHERE MenuID = @Previous) AS diff);

		SELECT @Removed removed, @OldNOfDishes / 2 old, @Added added;
		IF (@Removed >= @OldNOfDishes / 2) and (@Added >= @OldNOfDishes / 2)
		BEGIN
			UPDATE Menu
			SET Active = 1
			WHERE MenuID = @MenuID;
			CLOSE PreviousMenu;
			DEALLOCATE PreviousMenu;
			COMMIT TRANSACTION;
			RETURN;
		END
		SET @Current = @Previous;
		FETCH NEXT FROM PreviousMenu INTO @Previous;
	END
	CLOSE PreviousMenu;
	DEALLOCATE PreviousMenu;
	PRINT 'Menu has not been activated';
	COMMIT TRANSACTION;
END

GO

CREATE PROCEDURE PlaceOrder
@CustomerID INT,
@dishes VARCHAR(250), -- 'IDdanie1,iloœæ_dañ1,IDdanie2,iloœæ_dañ2,... '
@ReceiveDate DATE,
@PaymentReceived BIT,
@EmployeeID INT,
@PeopleCount INT = NULL,
@FromTime TIME = NULL,
@ToTime TIME = NULL,
@CompanyEmployees VARCHAR(250) = NULL
AS
BEGIN
	BEGIN TRANSACTION
	DECLARE @OrderID int, @Discount INT, @Today date = getdate(), @TotalPrice INT = 0;

	IF NOT EXISTS (SELECT CustomerID FROM Customers WHERE CustomerID = @CustomerID)
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50001, 'No such customer.', 1;
	END

	

	DECLARE @MenuID INT = (SELECT MenuID 
						   FROM Menu 
						   WHERE InDate <= @ReceiveDate and OutDate >= @ReceiveDate and Active = 1),
			@isCompany BIT = (SELECT isCompany FROM Customers WHERE CustomerID = @CustomerID);
	
	IF @MenuID is NULL
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50001, 'No such menu.', 1;
	END		

	SET @Discount = dbo.CalculateDiscount(@CustomerID);

	SET DATEFIRST 1;

	DECLARE @Quantity int, @DishID int, @UnitPrice money, @FromCursor VARCHAR(250);

	DECLARE DishesOrdered CURSOR FOR SELECT * FROM STRING_SPLIT(@dishes, ',');
	OPEN DishesOrdered;
	FETCH NEXT FROM DishesOrdered INTO @FromCursor
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @DishID = CAST(@FromCursor AS INT);
			IF @DishID NOT IN (SELECT DishID FROM MenuDetails WHERE MenuID = @MenuID)
			BEGIN
				ROLLBACK TRANSACTION;
				THROW 50001, 'Dish not in menu.', 1;
			END
				
		
			IF @DishID in (SELECT DishID
							FROM Categories 
							JOIN Dishes ON Categories.CategoryID = Dishes.DishID
							WHERE CategoryName = 'Owoce morza') 
			BEGIN
				IF not DATEPART(weekday, @Today) BETWEEN 4 and 6
				BEGIN
					ROLLBACK TRANSACTION;
					THROW 50001, 'Seafood cannot be ordered today.', 1
				END

				IF DATEPART(week, @ReceiveDate) = DATEPART(week, @Today) and @ReceiveDate <= DATEADD(DAY, 8 - DATEPART(weekday, @TODAY), @Today) 
				BEGIN
					ROLLBACK TRANSACTION;
					THROW 50001, 'Seafood cannot be ordered for this day.', 1
				END		
			END
			FETCH NEXT FROM DishesOrdered INTO @FromCursor;
			IF @@FETCH_STATUS <> 0
			BEGIN
				ROLLBACK TRANSACTION;
				THROW 50001, 'Quantity has not been specified.', 1;
			END
				
			SET @Quantity = CAST(@FromCursor AS INT);
			SET @UnitPrice = (SELECT UnitPrice FROM MenuDetails WHERE DishID = @DishID and MenuID = @MenuID);
			SET @TotalPrice += @UnitPrice * @Quantity * (CONVERT(DECIMAL, 100 - @Discount)/100)
			FETCH NEXT FROM DishesOrdered INTO @FromCursor
		END
	CLOSE DishesOrdered;
	DEALLOCATE DishesOrdered;

	IF (@TotalPrice < (SELECT WZ FROM Parameters) or (SELECT COUNT(*) FROM Orders WHERE CustomerID = @CustomerID) < (SELECT WK FROM Parameters)) and @PaymentReceived = 0
	BEGIN
		ROLLBACK TRANSACTION;
		THROW 50001, 'Cannot pay later.', 1;
	END	

	EXEC AddNewOrder @CustomerID, @EmployeeID,  @PaymentReceived,  @Today,  @ReceiveDate,  @Discount
	SET @OrderID = @@IDENTITY;

	UPDATE TemporaryDiscount
	SET Status = 0
	WHERE CustomerID = @CustomerID and Status = 1;

	DECLARE DishesOrdered CURSOR FOR SELECT * FROM STRING_SPLIT(@dishes, ',');
	OPEN DishesOrdered;
	FETCH NEXT FROM DishesOrdered INTO @FromCursor
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @DishID = CAST(@FromCursor AS INT);
			FETCH NEXT FROM DishesOrdered INTO @FromCursor;
			SET @Quantity = CAST(@FromCursor AS INT);
			SET @UnitPrice = (SELECT UnitPrice FROM MenuDetails WHERE DishID = @DishID and MenuID = @MenuID);
			EXEC AddNewOrderDetails @OrderID,  @DishID, @MenuID, @Quantity, @UnitPrice
			FETCH NEXT FROM DishesOrdered INTO @FromCursor
		END
	CLOSE DishesOrdered;
	DEALLOCATE DishesOrdered;

	DECLARE @ReservationID INT;
	IF @PeopleCount is not NULL and @FromTime is not NULL and @ToTime is not NULL
	BEGIN
		IF (SELECT SUM(ChairCount) FROM Tables 
			WHERE TableID IN (SELECT * FROM dbo.TablesAvaliable(@ReceiveDate, @FromTime, @ToTime))) < @PeopleCount
		BEGIN
			ROLLBACK TRANSACTION;
			THROW 50001, 'No such tables.', 1;
		END
		EXEC AddNewReservation @OrderID, @Today, @CustomerID, @PeopleCount, @FromTime, @ToTime, @ReceiveDate
		SET @ReservationID = @@Identity
		EXEC AddTablesToReservation @ReservationID
	END

	IF @isCompany = 1
		BEGIN
			DECLARE @Name VARCHAR(50), @Surname VARCHAR(50);
			DECLARE CompanyEmployees CURSOR FOR SELECT * FROM string_split(@CompanyEmployees,',');
			OPEN CompanyEmployees;
			FETCH NEXT FROM CompanyEmployees INTO @Name
			WHILE @@FETCH_STATUS = 0
			BEGIN
				FETCH NEXT FROM CompanyEmployees INTO @Surname
				IF @@FETCH_STATUS <> 0
				BEGIN
					ROLLBACK TRANSACTION;
					THROW 50001, 'Surname has not been specified', 1;
				END
				INSERT INTO CompanyEmployees VALUES(@ReservationID, @Name, @Surname)
				FETCH NEXT FROM CompanyEmployees INTO @Name
			END
			CLOSE CompanyEmployees;
			DEALLOCATE CompanyEmployees;
		END
	ELSE
		BEGIN
			DECLARE @MinOrdersForPerm INT = (SELECT Z1 FROM Parameters),
					@MinValueForPerm MONEY = (SELECT K1 FROM Parameters),
					@MinValueForTemp MONEY = (SELECT K2 FROM Parameters),
					@Duration INT = (SELECT D1 FROM Parameters),
					@PermValue INT = (SELECT R1 FROM Parameters),
					@TempValue INT = (SELECT R2 FROM Parameters);

			DECLARE @CustomerOrders TABLE(CustomerID INT, Total MONEY);
			INSERT INTO @CustomerOrders 
				SELECT CustomerID, SUM(OD.Quantity*OD.UnitPrice*((convert(decimal, 100-O.Discount))/100))
				FROM Orders O
				INNER JOIN OrderDetails as OD on O.OrderID = OD.OrderID
				WHERE O.Status = 1 and CustomerID = @CustomerID
				GROUP BY O.OrderID, O.CustomerID
					
			IF @CustomerID not in (SELECT CustomerID FROM PermanentDiscount) and
			   @MinOrdersForPerm <= (SELECT COUNT(*)
									 FROM @CustomerOrders
									 WHERE Total > @MinValueForPerm
									 GROUP BY CustomerID)
				BEGIN
					INSERT INTO PermanentDiscount(CustomerID, Value, IssueDate) VALUES(@CustomerID, @PermValue, @Today)
				END

			IF @TotalPrice > @MinValueForTemp
				BEGIN
					DECLARE @Date DATE = DATEADD(DAY, 7, @Today)
					INSERT INTO TemporaryDiscount(CustomerID, Value, IssueDate, DueDate) VALUES(@CustomerID, @TempValue, @Today, @Date)
				END
		END
	COMMIT TRANSACTION
END


GO

-- Widoki

--Aktualne menu

Create view CurrentMenu as
select D.DishName, D.Description, MD.UnitPrice
from Menu as M
inner join MenuDetails as MD on MD.MenuID = M.MenuID
inner join Dishes as D on D.DishID = MD.DishID
where getdate() >= M.InDate and getdate() <= M.OutDate and M.Active = 1

GO

--Menu tydzieñ temu

Create view MenuWeekAgo as
select D.DishName, D.Description, MD.UnitPrice
from Menu as M
inner join MenuDetails as MD on MD.MenuID = M.MenuID
inner join Dishes as D on D.DishID = MD.DishID
where dateadd(day,-7, getdate()) >= M.InDate and dateadd(day,-7, getdate()) <= M.OutDate  and M.Active = 1

GO

--Menu rok temu

Create view MenuYearAgo as
select D.DishName, D.Description, MD.UnitPrice
from Menu as M
inner join MenuDetails as MD on MD.MenuID = M.MenuID
inner join Dishes as D on D.DishID = MD.DishID
where dateadd(year,-1, getdate()) >= M.InDate and dateadd(year,-1, getdate()) <= M.OutDate

GO

--Dania których jest za ma³o i trzeba domówiæ

Create view DishesToOrder as
select D.DishName, D.Description, MD.UnitPrice
from Menu as M
inner join MenuDetails as MD on MD.MenuID = M.MenuID
inner join Dishes as D on D.DishID = MD.DishID
where D.MinStockValue > D.UnitsInStock and M.InDate >= getdate() and M.OutDate <= getdate()

GO
 
--Wszystkie dania wraz z kategoriami

Create view DishesCategories as
select D.DishName, C.CategoryName, C.Description
from Dishes as D
inner join Categories as C on D.CategoryID = C.CategoryID

GO

--Wszystkie dania wraz z histori¹ ich cen i wystêpowania w menu na przestrzeni czasu

Create view DishesPricesHistory as
select D.DishName, MD.UnitPrice, M.InDate, M.OutDate
from Menu as M
inner join MenuDetails as MD on MD.MenuID = M.MenuID
inner join Dishes as D on D.DishID = MD.DishID

GO

--Wszystkie dania wraz z histori¹ ich cen i wystêpowania w menu na przestrzeni aktualnego roku

Create view DishesPricesHistoryThisYear as
select D.DishName, MD.UnitPrice, M.InDate, M.OutDate
from Menu as M
inner join MenuDetails as MD on MD.MenuID = M.MenuID
inner join Dishes as D on D.DishID = MD.DishID
where datediff(year , M.InDate, getdate()) = 0 and datediff(year , M.OutDate, getdate()) = 0

GO

--Wszystkie dania wraz z histori¹ ich cen i wystêpowania w menu na przestrzeni ostatniego roku

Create view DishesPricesHistoryLastYear as
select D.DishName, MD.UnitPrice, M.InDate, M.OutDate
from Menu as M
inner join MenuDetails as MD on MD.MenuID = M.MenuID
inner join Dishes as D on D.DishID = MD.DishID
where datediff(year , M.InDate, getdate()) = 1 and datediff(year , M.OutDate, getdate()) = 1

GO

--Zamówienia do wykonania

Create view OrdersToDo as
select O.OrderID, isnull(concat(IC.Firstname, ' ', IC.Lastname), CC.CompanyName) as 'Customer', O.OrderDate, O.ReceiveDate
from Orders as O
inner join Customers as C on O.CustomerID = C.CustomerID
inner join CompanyCustomers as CC on C.CustomerID = CC.CustomerID
inner join IndividualCustomers as IC on C.CustomerID = IC.CustomerID
where ReceiveDate>getdate() and status = 1

GO

--Przypisanie pracowników do zamówieñ i daty przypisañ

Create view EmployeeAssingments as
select concat(E.Firstname, ' ', E.Lastname) as 'Employee', O.OrderID, O.ReceiveDate
from Orders as O
inner join EmployeesDetails as ED on O.OrderID = ED.OrderID
inner join Employees as E on ED.EmployeeID = E.EmployeeID
where ReceiveDate>getdate() and status = 1

GO

--Przychód z zamówieñ z dzisiaj na ka¿dego klienta

Create view TodaysOrdersValue as
select O.OrderID, SUM(OD.UnitPrice*OD.Quantity) as 'Value', O.CustomerID
from Orders as O
inner join OrderDetails as OD on O.OrderID = OD.OrderID
where datediff(year , O.ReceiveDate, getdate()) = 0 and datediff(month , O.ReceiveDate, getdate()) = 0 and datediff(day , O.ReceiveDate, getdate()) = 0
group by O.OrderID, O.CustomerID

GO

--Popularnoœæ dañ oraz ich przychód na przestrzeni czasu

Create view DishesPopularity as
select D.DishID, D.DishName, isnull(SUM(OD.Quantity), 0) as 'Quantity' from OrderDetails as OD
inner join MenuDetails as MD on OD.DishID = MD.DishID
right join Dishes as D on D.DishID = MD.DishID
group by OD.DishID, D.DishID, D.DishName

GO

--Popularnoœæ dañ oraz ich przychód w tym roku

Create view DishesPopularityThisYear as
select D.DishID, D.DishName, isnull(SUM(OD.Quantity), 0) as 'Quantity', isnull(SUM(OD.Quantity*OD.UnitPrice),0) as 'Income'
from OrderDetails as OD
inner join MenuDetails as MD on OD.DishID = MD.DishID
right join Dishes as D on D.DishID = MD.DishID
inner join Orders as O on O.OrderID = OD.OrderID
where datediff(year , O.ReceiveDate, getdate()) = 0 and O.status = 1
group by OD.DishID, D.DishID, D.DishName

GO

--Popularnoœæ dañ oraz ich przychód w ostatnim roku

Create view DishesPopularityLastYear as
select D.DishID, D.DishName, isnull(SUM(OD.Quantity), 0) as 'Quantity', isnull(SUM(OD.Quantity*OD.UnitPrice),0) as 'Income'
from OrderDetails as OD
inner join MenuDetails as MD on OD.DishID = MD.DishID
right join Dishes as D on D.DishID = MD.DishID
inner join Orders as O on O.OrderID = OD.OrderID
where datediff(year , O.ReceiveDate, getdate()) = 1 and O.status = 1
group by OD.DishID, D.DishID, D.DishName

GO

--Rezerwacje na dzisiaj

Create view ReservationsToday as
select *
from Reservations as R
where datediff(year , R.ReceiveDate, getdate()) = 0 and datediff(month , R.ReceiveDate, getdate()) = 0 and datediff(day , R.ReceiveDate, getdate()) = 0

GO

--Rezerwacje na miesi¹c do przodu

Create view ReservationsThisMonth as
select *
from Reservations as R
where dateadd(month, 1, getdate()) >= R.ReceiveDate and R.ReceiveDate >= getdate()

GO

Create view ReservedTables as
select T.TableID, T.ChairCount, R.ReceiveDate, R.FromTime, R.ToTime
from Tables as T
inner join ReservationDetails as RD on RD.TableID = T.TableID
inner join Reservations as R on R.ReservationID = RD.ReservationID
where getdate() <= R.ReceiveDate and Status = 1

GO

Create view ReservedTablesLastWeek as
select T.TableID, T.ChairCount, R.ReceiveDate, R.FromTime, R.ToTime
from Tables as T
inner join ReservationDetails as RD on RD.TableID = T.TableID
inner join Reservations as R on R.ReservationID = RD.ReservationID
where dateadd(day,-7, getdate()) >= R.ReceiveDate and Status = 1

GO

Create view ReservedTablesLastMonth as
select T.TableID, T.ChairCount, R.ReceiveDate, R.FromTime, R.ToTime
from Tables as T
inner join ReservationDetails as RD on RD.TableID = T.TableID
inner join Reservations as R on R.ReservationID = RD.ReservationID
where dateadd(month,-1, getdate()) >= R.ReceiveDate and Status = 1

GO

Create view Discounts as
select CustomerID, Value, IssueDate
from TemporaryDiscount
union 
select CustomerID, Value, IssueDate
from PermanentDiscount

GO

Create view DiscountsLastWeek as
select CustomerID, Value, IssueDate
from TemporaryDiscount
where dateadd(day,-7, getdate()) >= IssueDate
union 
select CustomerID, Value, IssueDate
from PermanentDiscount
where dateadd(day,-7, getdate()) >= IssueDate

GO

Create view DiscountsLastMonth as
select CustomerID, Value, IssueDate
from TemporaryDiscount
where dateadd(month,-1, getdate()) >= IssueDate
union 
select CustomerID, Value, IssueDate
from PermanentDiscount
where dateadd(month,-1, getdate()) >= IssueDate

GO

Create view WhoOrderedWhat as
select O.CustomerID, isnull(concat(IC.Firstname, ' ', IC.Lastname), CC.CompanyName) as 'Customer', OD.Quantity*((convert(decimal, 100-O.Discount))/100) as 'Price'
from Orders O
inner join OrderDetails as OD on O.OrderID = OD.OrderID
inner join Customers as C on O.CustomerID = C.CustomerID
inner join CompanyCustomers as CC on C.CustomerID = CC.CustomerID
inner join IndividualCustomers as IC on C.CustomerID = IC.CustomerID
where O.Status = 1

GO

Create view WhoOrderedWhatLASTWEEK as
select O.CustomerID, isnull(concat(IC.Firstname, ' ', IC.Lastname), CC.CompanyName) as 'Customer', OD.Quantity*OD.UnitPrice*((convert(decimal, 100-O.Discount))/100) as 'Price'
from Orders O
inner join OrderDetails as OD on O.OrderID = OD.OrderID
inner join Customers as C on O.CustomerID = C.CustomerID
inner join CompanyCustomers as CC on C.CustomerID = CC.CustomerID
inner join IndividualCustomers as IC on C.CustomerID = IC.CustomerID
where dateadd(day,-7, getdate()) >= O.OrderDate and O.Status = 1

GO

Create view WhoOrderedWhatLASTYEAR as
select O.CustomerID, isnull(concat(IC.Firstname, ' ', IC.Lastname), CC.CompanyName) as 'Customer', OD.Quantity*OD.UnitPrice*((convert(decimal, 100-O.Discount))/100) as 'Price'
from Orders O
inner join OrderDetails as OD on O.OrderID = OD.OrderID
inner join Customers as C on O.CustomerID = C.CustomerID
inner join CompanyCustomers as CC on C.CustomerID = CC.CustomerID
inner join IndividualCustomers as IC on C.CustomerID = IC.CustomerID
where dateadd(year,-1, getdate()) >= O.OrderDate and O.Status = 1

GO

Create view DishesThatCanBeActivated as 
select M.MenuID, M.InDate, D.DishName, D.Description, MD.UnitPrice
from Menu as M
inner join MenuDetails as MD on M.MenuID = MD.MenuID
inner join Dishes as D on D.DishID = MD.DishID
where M.Active = 0 and dateadd(day, -1, M.InDate) = (select top 1 M.OutDate 
                                from Menu as M
                                where Active = 1
                                order by M.OutDate desc)