EXEC AddNewIndividualCustomer 'Krystian', 'Tomczyk', 
'9320587610', 'krystiantomczyk@gmail.pl', 'ul.Miodowa 1', 'D¹browa Górnicza', '58-647', 'Poland' 

EXEC AddNewIndividualCustomer 'Tetiana', 'Pawlik', 
'2791976772', 'tatianapaw@gmail.pl', 'ul. Szkolna 1', '¯ory', '70-185', 'Poland' 

EXEC AddNewCompanyCustomer 'META', 
'4778920347', 'meta@gmail.pl', 'ul. Narcyzowa 10', 'Tarnobrzeg', '27-953', 'Poland' 

EXEC AddNewIndividualCustomer 'Marcin', 'Stasiak', 
'9167802182', 'marcinstasiak@gmail.pl', 'ul. Chabrowa 10', 'Gdañsk', '56-168', 'Poland' 

EXEC AddNewCompanyCustomer 'Avi', 
'9269893515', 'avi@avi.pl', 'ul. Parkowa 5A', 'Chorzów', '48-402', 'Poland' 

EXEC AddNewCompanyCustomer 'Hyper', 
'7756041500', 'hyper@hyper.pl', 'ul. Tulipanowa 7', 'Zamoœæ', '27-953', 'Poland' 

INSERT INTO Categories(CategoryName, Description) Values('Wegetariañskie', 'Dania bez miêsa')
INSERT INTO Categories(CategoryName, Description) Values('Owoce morza', 'frutti di mare')
INSERT INTO Categories(CategoryName, Description) Values('Bezglutenowe', 'Bez glutenu')
INSERT INTO Categories(CategoryName, Description) Values('Sa³atki', 'Zielonee')
INSERT INTO Categories(CategoryName, Description) Values('Desery', 'Na s³odko')
INSERT INTO Categories(CategoryName, Description) Values('Miêsa', 'Pyszne')
INSERT INTO Categories(CategoryName, Description) Values('Naleœniki', 'Ró¿ne rodzaje')

EXEC AddDish 'Pierogi', 1, 'ruskie', 50, 100
EXEC AddDish 'Panierowane kalmary', 2, 'panierowane kalmary z sosem', 10, 10
EXEC AddDish 'Pieczony filet z sandacza' , 2, 'na grillowanej cukinii z kurkami podawany z plastrami ziemniaka z pieca', 10, 15
EXEC AddDish 'Sa³atka caesar', 4, 'z kurczakiem', 40, 40
EXEC AddDish 'Sa³atka grecka', 4, 'z serem feta', 20, 30
EXEC AddDish 'Szarlotka', 5, 'z bit¹ œmietan¹ oraz lodami', 20, 30
EXEC AddDish 'Filet z kurczaka', 6, 'z zestawem surówek oraz frytkami', 20, 30
EXEC AddDish 'Naleœniki z serem', 7, 'na s³odko', 20, 30
EXEC AddDish 'Barszcz czerwony', 1, 'wigilijny', 20, 30
UPDATE dishes SET Active=0 WHERE DishName='Barszcz czerwony'

Insert into Parameters(WZ, WK, Z1, K1, R1, D1, K2, R2) Values (50, 5, 10, 30, 3, 7, 1000, 5)

EXEC AddMenu '2022-01-02', '2022-01-04'
EXEC AddMenu '2022-01-5', '2022-01-18'
EXEC AddMenu '2022-01-19', '2022-01-30'
EXEC AddMenu '2022-01-19', '2022-01-30'
EXEC AddMenu '2022-01-17', '2022-01-30'


EXEC AddDishToMenu 1, 1, 20
EXEC AddDishToMenu 1, 2, 50

EXEC AddDishToMenu 2, 1, 18
EXEC AddDishToMenu 2, 4, 15
EXEC AddDishToMenu 2, 6, 15
EXEC AddDishToMenu 2, 7, 32
EXEC AddDishToMenu 2, 8, 20


EXEC AddDishToMenu 3, 1, 20
EXEC AddDishToMenu 3, 2, 15
EXEC AddDishToMenu 3, 7, 15
EXEC AddDishToMenu 3, 8, 10


EXEC AddDishToMenu 4, 2, 20
EXEC AddDishToMenu 4, 3, 15
EXEC AddDishToMenu 4, 4, 10
EXEC AddDishToMenu 4, 5 , 15

EXEC AddDishToMenu 5, 2, 20
EXEC AddDishToMenu 5, 3, 15
EXEC AddDishToMenu 5, 4, 10
EXEC AddDishToMenu 5, 5 , 15

EXEC ActivateMenu 1
EXEC ActivateMenu 2
EXEC ActivateMenu 4

insert into employees(FirstName, LastName, Phone, Position) Values ('Czes³aw', 'Sobczak', 785123432, 'Kucharz')
insert into employees(FirstName, LastName, Phone, Position) Values ('Miko³aj', 'Wójcik', 712322134, 'Kelner')
insert into employees(FirstName, LastName, Phone, Position) Values ('Aneta', 'Majchrzak', 678696921, 'Kelner')

exec AddPermanentDiscount 2, 3, '2022-01-15'

insert into tables(ChairCount, Active) Values(6, 1)
insert into tables(ChairCount, Active) Values(6, 1)
insert into tables(ChairCount, Active) Values(5, 1)
insert into tables(ChairCount, Active) Values(10, 1)
insert into tables(ChairCount, Active) Values(2, 1)
insert into tables(ChairCount, Active) Values(2, 1)
insert into tables(ChairCount, Active) Values(2, 1)
insert into tables(ChairCount, Active) Values(2, 1)
insert into tables(ChairCount, Active) Values(4, 1)
insert into tables(ChairCount, Active) Values(4, 1)