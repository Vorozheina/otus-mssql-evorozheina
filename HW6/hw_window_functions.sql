USE WideWorldImporters
GO

/*
1. Сделать расчет суммы продаж нарастающим итогом по месяцам с 2015 года
(в рамках одного месяца он будет одинаковый, нарастать будет в течение времени выборки).
Нарастающий итог должен быть без оконной функции.
*/
DROP TABLE IF EXISTS
	#basis_table;
CREATE TABLE  #basis_table (
	Month2015 INT NULL,
	SalesSum FLOAT NULL
	);
INSERT INTO #basis_table
(
    Month2015,
    SalesSum
)
SELECT MONTH(I.InvoiceDate) AS Month2015, SUM(IL.ExtendedPrice) AS SalesSum 
FROM Sales.Invoices I
	INNER JOIN Sales.InvoiceLines IL ON IL.InvoiceID = I.InvoiceID
WHERE YEAR(I.InvoiceDate) =2015
GROUP BY MONTH(I.InvoiceDate);
--
SET STATISTICS TIME, IO ON;
--
--1--
/*через декартово произведение*/
SELECT bt.Month2015, COALESCE(SUM(bt2.SalesSum), 0) AS CumlativeTotalSum
FROM #basis_table bt, #basis_table bt2
WHERE bt2.Month2015 <= bt.Month2015
GROUP BY bt.Month2015
ORDER BY bt.Month2015;

--2--
/*через CTE*/
WITH MonthSales2015CTE(Month2015, SalesSum)
AS
(
	SELECT Month2015, SalesSum
	FROM #basis_table
	WHERE Month2015 = (SELECT MIN(Month2015) FROM #basis_table)
	UNION ALL
	SELECT bt.Month2015, MonthSales2015CTE.SalesSum + bt.SalesSum
	FROM MonthSales2015CTE
		INNER JOIN #basis_table bt ON bt.Month2015 = MonthSales2015CTE.Month2015 + 1
)
SELECT Month2015, SalesSum AS CumlativeTotalSum
FROM MonthSales2015CTE
ORDER BY MonthSales2015CTE.Month2015;

/*
2. Сделайте расчет суммы нарастающим итогом в предыдущем запросе с помощью оконной функции.
Сравните производительность запросов 1 и 2 с помощью set statistics time, io on
*/
SELECT bt.Month2015,
       COALESCE(SUM(bt.SalesSum) OVER (ORDER BY bt.Month2015 
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 
                0) AS CumlativeTotalSum
FROM #basis_table bt
ORDER BY bt.Month2015;
/*
Декартово произведение оказалось самым быстрым по выведенной статистике, по плану выполнения оконные функции самые выгодные, CTE - самый плохой результат.
*/

/*
3. Вывести список 2х самых популярных продуктов (по количеству проданных)
в каждом месяце за 2016 год (по 2 самых популярных продукта в каждом месяце).
*/
DROP TABLE IF EXISTS
	#Month2016ItemSalesQuantity;
CREATE TABLE  #Month2016ItemSalesQuantity (
	Month2016 INT NULL,
	StockItemName NVARCHAR(100) NULL,
	SalesQuantity BIGINT NULL
	);
INSERT INTO #Month2016ItemSalesQuantity
(
    Month2016,
    StockItemName,
	SalesQuantity
)
SELECT MONTH(Sales.Invoices.InvoiceDate) AS Month2016, StockItemName, SUM(Sales.InvoiceLines.Quantity) AS SalesQuantity
FROM Sales.Invoices
	INNER JOIN Sales.InvoiceLines  ON InvoiceLines.InvoiceID = Invoices.InvoiceID
	INNER JOIN Warehouse.StockItems ON StockItems.StockItemID = InvoiceLines.StockItemID
WHERE YEAR(Sales.Invoices.InvoiceDate) = 2016
GROUP BY MONTH(Sales.Invoices.InvoiceDate), StockItemName;
---------------
--1--
/*без оконных функций*/
SELECT #Month2016ItemSalesQuantity.Month2016, #Month2016ItemSalesQuantity.StockItemName
FROM #Month2016ItemSalesQuantity
	INNER JOIN (SELECT Month2016, MAX(SalesQuantity) MaxSalesQuantity
				FROM #Month2016ItemSalesQuantity 
				GROUP BY Month2016) MaxSales ON MaxSales.Month2016 = #Month2016ItemSalesQuantity.Month2016 
												AND MaxSales.MaxSalesQuantity = #Month2016ItemSalesQuantity.SalesQuantity
UNION
SELECT #Month2016ItemSalesQuantity.Month2016, #Month2016ItemSalesQuantity.StockItemName
FROM #Month2016ItemSalesQuantity
	INNER JOIN (SELECT Month2016, MAX(SalesQuantity) MaxSalesQuantity
				FROM (SELECT #Month2016ItemSalesQuantity.Month2016, #Month2016ItemSalesQuantity.SalesQuantity
					  FROM #Month2016ItemSalesQuantity
					  EXCEPT (SELECT Month2016, MAX(SalesQuantity) MaxSalesQuantity
							  FROM #Month2016ItemSalesQuantity 
							  GROUP BY Month2016)) CloserToMaxSales
			    GROUP BY Month2016) ForSecondPopularItem ON ForSecondPopularItem.Month2016 = #Month2016ItemSalesQuantity.Month2016 
												AND ForSecondPopularItem.MaxSalesQuantity = #Month2016ItemSalesQuantity.SalesQuantity
ORDER BY #Month2016ItemSalesQuantity.Month2016;
--2--
/*с оконными функциями*/
SELECT Month2016, StockItemName
FROM 
	(SELECT	Month2016,
			StockItemName,
			RankSalesQuantity = RANK() OVER (PARTITION BY Month2016 ORDER BY SalesQuantity DESC) 
	 FROM #Month2016ItemSalesQuantity) AS Month2016ItemSalesQuantityWithRank
WHERE Month2016ItemSalesQuantityWithRank.RankSalesQuantity IN (1, 2)
ORDER BY Month2016ItemSalesQuantityWithRank.Month2016, Month2016ItemSalesQuantityWithRank.RankSalesQuantity;


/*
4. Функции одним запросом
Посчитайте по таблице товаров (в вывод также должен попасть ид товара, название, брэнд и цена):
а) пронумеруйте записи по названию товара, так чтобы при изменении буквы алфавита нумерация начиналась заново
б) посчитайте общее количество товаров и выведете полем в этом же запросе
в) посчитайте общее количество товаров в зависимости от первой буквы названия товара
г) отобразите следующий id товара исходя из того, что порядок отображения товаров по имени
д) предыдущий ид товара с тем же порядком отображения (по имени)
е) названия товара 2 строки назад, в случае если предыдущей строки нет нужно вывести "No items"
ж) сформируйте 30 групп товаров по полю вес товара на 1 шт
Для этой задачи НЕ нужно писать аналог без аналитических функций.
*/
/*
а) нужно уточнение: речь, наверное, идет о самом первом символе из названия и его изменении?
в) а если наименование товара начинается с цифры, кавычки? Нужно уточнение
*/
SELECT 
	StockItemID, 
	AnotherNumeration = ROW_NUMBER() OVER (PARTITION BY SUBSTRING(StockItemName, 1, 1) ORDER BY StockItemName),
	StockItemName,	
	Brand, 
	UnitPrice,
	AllQuantity = SUM(QuantityPerOuter) OVER (),
	QuantityByFirstSymbol = SUM(QuantityPerOuter) OVER (PARTITION BY SUBSTRING(StockItemName, 1, 1)),
	NextID = LEAD(StockItemID, 1) OVER (ORDER BY StockItemName ASC), -- второй вариант: NextID = LAG(StockItemID, 1) OVER (ORDER BY StockItemName DESC)
	PrevID = LAG(StockItemID, 1) OVER (ORDER BY StockItemName ASC),
	PrevStockItemName = LAG(StockItemName, 2, 'No items') OVER (ORDER BY StockItemName ASC),
	GetOwn30GroupsByOneUnitWeight = NTILE(30) OVER (ORDER BY TypicalWeightPerUnit)
FROM Warehouse.StockItems
ORDER BY TypicalWeightPerUnit, StockItemName;

/*
5. По каждому сотруднику выведите последнего клиента, которому сотрудник что-то продал.
В результатах должны быть ид и фамилия сотрудника, ид и название клиента, дата продажи, сумму сделки.
*/
--1--
;WITH LastInfo(PersonID, FullName, CustomerID, CustomerName, InvoiceDate, SalesOrder, TransactionAmount)
AS
(
	SELECT P.PersonID, 
		   P.FullName, 
		   C.CustomerID, 
		   C.CustomerName, 
		   I.InvoiceDate,
		   SalesOrder = RANK() OVER (PARTITION BY P.PersonID ORDER BY I.InvoiceDate DESC, I.InvoiceID DESC),
		   CT.TransactionAmount
	FROM Sales.Invoices I
		INNER JOIN Sales.Customers C ON C.CustomerID = I.CustomerID
		INNER JOIN Sales.CustomerTransactions CT ON I.InvoiceID = CT.InvoiceID
		INNER JOIN Application.People P ON P.PersonID = I.SalespersonPersonID
)
SELECT LI.PersonID, LI.FullName, LI.CustomerID, LI.CustomerName, LI.InvoiceDate AS LastInvoiceDate, LI.TransactionAmount
FROM LastInfo LI
WHERE LI.SalesOrder = 1
ORDER BY LI.PersonID;



--2--
SELECT LastInfo.SalespersonPersonID AS PersonID, P.FullName, C.CustomerID, 
		   C.CustomerName, LastInvoiceDate, CT.TransactionAmount
FROM
	(SELECT SalespersonPersonID, MAX(InvoiceDate) LastInvoiceDate, MAX(InvoiceID) LastInvoiceID
	 FROM Sales.Invoices
	 GROUP BY SalespersonPersonID) LastInfo
		 INNER JOIN Application.People P ON P.PersonID = LastInfo.SalespersonPersonID
		 INNER JOIN Sales.Invoices I ON I.InvoiceID = LastInfo.LastInvoiceID
		 INNER JOIN Sales.Customers C ON C.CustomerID = I.CustomerID
		 INNER JOIN Sales.CustomerTransactions CT ON CT.InvoiceID = I.InvoiceID
ORDER BY LastInfo.SalespersonPersonID;

/*6. Выберите по каждому клиенту два самых дорогих товара, которые он покупал.
В результатах должно быть ид клиета, его название, ид товара, цена, дата покупки.
Опционально можете для каждого запроса без оконных функций сделать вариант запросов с оконными функциями и сравнить их производительность.
*/

--1--
SELECT CustomerID, CustomerName, StockItemID, ExpPrice, InvoiceDate
FROM
(SELECT C.CustomerID, C.CustomerName, SI.StockItemID, SI.ExpPrice, SI.InvoiceDate, RN = ROW_NUMBER() OVER (PARTITION BY C.CustomerID ORDER BY SI.ExpPrice DESC)
FROM Sales.Customers C
INNER JOIN (SELECT I.CustomerID, IL.StockItemID, MAX(IL.UnitPrice) ExpPrice, MAX(I.InvoiceDate) AS InvoiceDate
                FROM Sales.Invoices I
					INNER JOIN Sales.InvoiceLines IL ON IL.InvoiceID = I.InvoiceID 
                GROUP BY I.CustomerID, IL.StockItemID
                ) AS SI ON SI.CustomerID = C.CustomerID) TwoExpensiveGoods
WHERE TwoExpensiveGoods.RN IN (1, 2)
ORDER BY CustomerName, ExpPrice DESC

--2--
SELECT Q.CustomerID, C.CustomerName, T.StockItemID, Q.UnitPrice, Q.InvoiceDate
FROM
(
	SELECT L.CustomerID, L.UnitPrice, MAX(L.MaxDate) InvoiceDate
	FROM (SELECT I.CustomerID, IL.StockItemID, IL.UnitPrice, MAX(I.InvoiceDate) AS MaxDate
		  FROM Sales.Invoices I
				INNER JOIN Sales.InvoiceLines IL ON IL.InvoiceID = I.InvoiceID
				INNER JOIN 
				(SELECT CustomerID, MAX(UnitPrice) MaxPrice
				FROM Sales.Invoices
					INNER JOIN Sales.InvoiceLines ON InvoiceLines.InvoiceID = Invoices.InvoiceID
				GROUP BY CustomerID) T ON T.CustomerID = I.CustomerID AND IL.UnitPrice = T.MaxPrice
		  GROUP BY I.CustomerID, IL.StockItemID, IL.UnitPrice
		  UNION
		  SELECT I.CustomerID, IL.StockItemID, IL.UnitPrice, MAX(I.InvoiceDate) AS MaxDate
		  FROM Sales.Invoices I
				INNER JOIN Sales.InvoiceLines IL ON IL.InvoiceID = I.InvoiceID
				INNER JOIN
			(SELECT I.CustomerID, MAX(UnitPrice) NotMaxPrice
			FROM Sales.Invoices I
				INNER JOIN Sales.InvoiceLines ON InvoiceLines.InvoiceID = I.InvoiceID
				INNER JOIN
					(SELECT CustomerID, MAX(UnitPrice) MaxPrice
					FROM Sales.Invoices
						INNER JOIN Sales.InvoiceLines ON InvoiceLines.InvoiceID = Invoices.InvoiceID
					GROUP BY CustomerID) MP ON MP.MaxPrice != UnitPrice AND MP.CustomerID = I.CustomerID
			GROUP BY I.CustomerID) T ON T.CustomerID = I.CustomerID AND IL.UnitPrice = T.NotMaxPrice
	GROUP BY I.CustomerID, IL.StockItemID, IL.UnitPrice) L
	GROUP BY L.CustomerID, L.UnitPrice) Q
	INNER JOIN Sales.Customers C ON C.CustomerID = Q.CustomerID
	INNER JOIN (SELECT I.CustomerID, I.InvoiceDate, IL.UnitPrice, MAX(IL.StockItemID) StockItemID
				FROM Sales.Invoices I 
					INNER JOIN Sales.InvoiceLines IL ON I.InvoiceID = IL.InvoiceID
	GROUP BY I.CustomerID, I.InvoiceDate, IL.UnitPrice) T ON Q.CustomerID = T.CustomerID AND T.InvoiceDate = Q.InvoiceDate AND T.UnitPrice = Q.UnitPrice
ORDER BY C.CustomerName, Q.UnitPrice DESC;
