DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS ReservationDetails;
DROP TABLE IF EXISTS EmployeesDetails;
DROP TABLE IF EXISTS MenuDetails;
DROP TABLE IF EXISTS Parameters;

DROP TABLE IF EXISTS Dishes;
DROP TABLE IF EXISTS Menu;
DROP TABLE IF EXISTS Categories;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Tables;
DROP TABLE IF EXISTS CompanyCustomers;
DROP TABLE IF EXISTS CompanyEmployees;

DROP TABLE IF EXISTS PermanentDiscount;
DROP TABLE IF EXISTS TemporaryDiscount;
DROP TABLE IF EXISTS IndividualCustomers;

DROP TABLE IF EXISTS Employees;

DROP TABLE IF EXISTS Reservations;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Invoices;


DROP PROCEDURE IF EXISTS AddNewIndividualCustomer;
DROP PROCEDURE IF EXISTS AddNewCompanyCustomer;
DROP PROCEDURE IF EXISTS AddNewEmployee;
DROP PROCEDURE IF EXISTS AddDish;
DROP PROCEDURE IF EXISTS AddCategory;
DROP PROCEDURE IF EXISTS AddMenu;
DROP PROCEDURE IF EXISTS AddDishToMenu;
DROP PROCEDURE IF EXISTS AddNewOrder;
DROP PROCEDURE IF EXISTS AddNewOrderDetails;
DROP PROCEDURE IF EXISTS AddNewTable;
DROP PROCEDURE IF EXISTS AddNewReservation;
DROP PROCEDURE IF EXISTS AddTableToReservation;
DROP PROCEDURE IF EXISTS ChangeIndividualCustomerData;
DROP PROCEDURE IF EXISTS ChangeCompanyCustomerData;
DROP PROCEDURE IF EXISTS AddPermanentDiscount;
DROP PROCEDURE IF EXISTS AddTemporaryDiscount;
DROP PROCEDURE IF EXISTS AddNewInvoice;
DROP FUNCTION IF EXISTS CalculateDiscount;
DROP PROCEDURE IF EXISTS PlaceOrder;
DROP PROCEDURE IF EXISTS AddTablesToReservation;
DROP FUNCTION IF EXISTS TablesAvaliable;
DROP PROCEDURE IF EXISTS ActivateMenu;
DROP PROCEDURE IF EXISTS AddMonthlyInvoice;

DROP View IF EXISTS CurrentMenu;
DROP View IF EXISTS MenuWeekAgo;
DROP View IF EXISTS MenuYearAgo;
DROP View IF EXISTS DishesToOrder;
DROP View IF EXISTS DishesCategories;
DROP View IF EXISTS DishesPricesHistory;
DROP View IF EXISTS DishesPricesHistoryThisYear;
DROP View IF EXISTS DishesPricesHistoryLastYear
DROP View IF EXISTS OrdersToDo;
DROP View IF EXISTS EmployeeAssingments;
DROP View IF EXISTS TodaysOrdersValue;
DROP View IF EXISTS DishesPopularity;
DROP View IF EXISTS DishesPopularityThisYear;
DROP View IF EXISTS DishesPopularityLastYear;
DROP View IF EXISTS ReservationsToday;
DROP View IF EXISTS ReservationsThisMonth;
DROP View IF EXISTS ReservedTables;
DROP View IF EXISTS ReservedTablesLastWeek;
DROP View IF EXISTS ReservedTablesLastMonth;
DROP View IF EXISTS Discounts;
DROP View IF EXISTS DiscountsLastWeek;
DROP View IF EXISTS DiscountsLastMonth;
DROP View IF EXISTS WhoOrderedWhat;
DROP View IF EXISTS WhoOrderedWhatLASTWEEK;
DROP View IF EXISTS WhoOrderedWhatLASTYEAR;
DROP View IF EXISTS MenuView;
DROP View IF EXISTS DishesThatCanBeActivated;