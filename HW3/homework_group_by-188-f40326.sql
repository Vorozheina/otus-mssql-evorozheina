/*
Домашнее задание по курсу MS SQL Server Developer в OTUS.
Занятие "02 - Оператор SELECT и простые фильтры, GROUP BY, HAVING".

Задания выполняются с использованием базы данных WideWorldImporters.

Бэкап БД можно скачать отсюда:
https://github.com/Microsoft/sql-server-samples/releases/tag/wide-world-importers-v1.0
Нужен WideWorldImporters-Full.bak

Описание WideWorldImporters от Microsoft:
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-what-is
* https://docs.microsoft.com/ru-ru/sql/samples/wide-world-importers-oltp-database-catalog
*/

-- ---------------------------------------------------------------------------
-- Задание - написать выборки для получения указанных ниже данных.
-- ---------------------------------------------------------------------------

USE WideWorldImporters

/*
1. Посчитать среднюю цену товара, общую сумму продажи по месяцам.
Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Средняя цена за месяц по всем товарам
* Общая сумма продаж за месяц

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/
--1--
SELECT YEAR(InvoiceDate) AS [YearOfSales], MONTH(InvoiceDate) [MonthOfSales], 
	   AVG(UnitPrice) AS [AveragePrice], SUM(UnitPrice*Quantity+TaxAmount) AS [SumByMonth], SUM(ExtendedPrice)
FROM Sales.Invoices
	INNER JOIN Sales.InvoiceLines ON Sales.Invoices.InvoiceID = Sales.InvoiceLines.InvoiceID
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)

/*
2. Отобразить все месяцы, где общая сумма продаж превысила 4 600 000

Вывести:
* Год продажи (например, 2015)
* Месяц продажи (например, 4)
* Общая сумма продаж

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/
--2--
SELECT YEAR(InvoiceDate) AS [YearOfSales], MONTH(InvoiceDate) [MonthOfSales], 
	   SUM(ExtendedPrice) AS [SumByMonth]
FROM Sales.Invoices
	INNER JOIN Sales.InvoiceLines ON Sales.Invoices.InvoiceID = Sales.InvoiceLines.InvoiceID
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate)
HAVING SUM(ExtendedPrice) > 4600000



/*
3. Вывести сумму продаж, дату первой продажи
и количество проданного по месяцам, по товарам,
продажи которых менее 50 ед в месяц.
Группировка должна быть по году,  месяцу, товару.

Вывести:
* Год продажи
* Месяц продажи
* Наименование товара
* Сумма продаж
* Дата первой продажи
* Количество проданного

Продажи смотреть в таблице Sales.Invoices и связанных таблицах.
*/
--3--
SELECT YEAR(InvoiceDate) AS [YearOfSales], MONTH(InvoiceDate) [MonthOfSales], Sales.InvoiceLines.StockItemID,
	   SUM(ExtendedPrice) AS [SumByMonth], MIN(InvoiceDate) AS [StartSalesDate], SUM(Quantity) AS [QuantityByMonth]
FROM Sales.Invoices
	INNER JOIN Sales.InvoiceLines ON Sales.Invoices.InvoiceID = Sales.InvoiceLines.InvoiceID
GROUP BY YEAR(InvoiceDate), MONTH(InvoiceDate), Sales.InvoiceLines.StockItemID
HAVING SUM(Quantity) < 50
-- ---------------------------------------------------------------------------
-- Опционально
-- ---------------------------------------------------------------------------
/*
Написать запросы 2-3 так, чтобы если в каком-то месяце не было продаж,
то этот месяц также отображался бы в результатах, но там были нули.
*/
--Комментарий: из обоих запросов пришлось исключить HAVING. Если HAVING должен быть включен в запросы,
-- то требуется пояснение условий.
--2А--
SELECT SalesPeriods.month_number, SalesPeriods.SalesYear, SUM(ISNULL(SalesInvoices.ExtendedPrice, 0))
FROM (SELECT month_number, SalesYears.SalesYear
	  FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS month_of_year(month_number)
			CROSS JOIN (SELECT DISTINCT YEAR(Sales.Invoices.InvoiceDate) [SalesYear]
			FROM Sales.Invoices) SalesYears) SalesPeriods
	 LEFT JOIN 
	 (SELECT YEAR(InvoiceDate) AS [YearOfSales], MONTH(InvoiceDate) [MonthOfSales], ExtendedPrice
	 FROM Sales.Invoices INNER JOIN Sales.InvoiceLines ON InvoiceLines.InvoiceID = Invoices.InvoiceID) SalesInvoices
	 ON SalesPeriods.month_number = SalesInvoices.MonthOfSales AND SalesPeriods.SalesYear = SalesInvoices.YearOfSales
GROUP BY  SalesPeriods.month_number, SalesPeriods.SalesYear
ORDER BY SalesPeriods.SalesYear, SalesPeriods.month_number

--3А--
SELECT SalesPeriods.month_number, SalesPeriods.SalesYear, SalesInvoices.StockItemID,
	   SUM(ISNULL(ExtendedPrice, 0)) AS [SumByMonth], MIN(SalesInvoices.InvoiceDate) AS [StartSalesDate], SUM(ISNULL(Quantity, 0)) AS [QuantityByMonth]
FROM (SELECT month_number, SalesYears.SalesYear
	  FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS month_of_year(month_number)
			CROSS JOIN (SELECT DISTINCT YEAR(Sales.Invoices.InvoiceDate) [SalesYear]
			FROM Sales.Invoices) SalesYears) SalesPeriods
	 LEFT JOIN 
	 (SELECT YEAR(InvoiceDate) AS [YearOfSales], MONTH(InvoiceDate) [MonthOfSales], Sales.InvoiceLines.StockItemID,
	   ExtendedPrice, InvoiceDate, Quantity
		FROM Sales.Invoices
	INNER JOIN Sales.InvoiceLines ON Sales.Invoices.InvoiceID = Sales.InvoiceLines.InvoiceID) SalesInvoices
	 ON SalesPeriods.month_number = SalesInvoices.MonthOfSales AND SalesPeriods.SalesYear = SalesInvoices.YearOfSales
GROUP BY  SalesPeriods.month_number, SalesPeriods.SalesYear, SalesInvoices.StockItemID
ORDER BY SalesPeriods.SalesYear, SalesPeriods.month_number