USE AdventureWorks2019

/*Q1. AdventureWorks works with customers, employees and business partners all over the globe. The accounting department needs to be sure they are up-to-date on Country and State tax rates.

a. Pull a list of every country and state in the database.

b. Includes tax rates.

c. There are 181 rows when looking at countries and states, but once you add tax rates the number of rows increases to 184. Why is this?

d. Which location has the highest tax rate?*/

SELECT * FROM Person.StateProvince

Solution: 

--a. 
Select 
cr.Name as 'Country'
,sp.Name as 'State'
From Person.StateProvince sp
Inner Join Person.CountryRegion cr on cr.CountryRegionCode = sp.CountryRegionCode
 
--b. 
Select 
cr.Name as 'Country'
,sp.Name as 'State'
,tr.TaxRate
From Person.StateProvince sp
Inner Join Person.CountryRegion cr on cr.CountryRegionCode = sp.CountryRegionCode
Left Join Sales.SalesTaxRate tr on tr.StateProvinceID = sp.StateProvinceID
 
--c. 
Select * from Sales.SalesTaxRate	
Where StateProvinceID in (
Select 
sp.StateProvinceID
From Person.StateProvince sp
Inner Join Person.CountryRegion cr on cr.CountryRegionCode = sp.CountryRegionCode
Left Join Sales.SalesTaxRate tr on tr.StateProvinceID = sp.StateProvinceID
Group by sp.StateProvinceID
Having count(*) > 1)
 
--d. 
Select 
cr.Name as 'Country'
,sp.Name as 'State'
,tr.TaxRate
From Person.StateProvince sp
Inner Join Person.CountryRegion cr on cr.CountryRegionCode = sp.CountryRegionCode
Left Join Sales.SalesTaxRate tr on tr.StateProvinceID = sp.StateProvinceID
Order by 3 desc

/*Q2. Due to an increase in shipping cost you've been asked to pull a few figures related to the freight column in

Sales.SalesOrderHeader

a. How much has AdventureWorks spent on freight in totality?

b. Show how much has been spent on freight by year (ShipDate)

c. Add the average freight per SalesOrderID

d. Add a Cumulative/Running Total sum */

--SOLUTION:
SELECT * FROM Sales.SalesOrderHeader
--a. 
/*Below 'C0' referred to as a “precision specifier”, probably because it allows you to specify the precision with which the result is displayed.*/
SELECT FORMAT(SUM(FREIGHT), 'C0') as TotalFreight 
FROM Sales.SalesOrderHeader
 
 --b. 
Select 
Year(ShipDate) as ShipYear
,Format(Sum(Freight),'C0') as TotalFreight
From Sales.SalesOrderHeader
Group by Year(ShipDate)
Order by 1 asc
 
--c. 
Select 
Year(ShipDate) as ShipYear
,Format(Sum(Freight),'C0') as TotalFreight
,Format(Avg(Freight),'C0') as AvgFreight 
From Sales.SalesOrderHeader
Group by Year(ShipDate)
Order by 1 asc
 
--d.
 
Select 
ShipYear
,Format(TotalFreight,'C0') as TotalFreight
,Format(AvgFreight,'C0') as AvgFreight
,Format(Sum(TotalFreight) Over (Order by ShipYear),'C0') as RunningTotal
From(
Select 
Year(ShipDate) as ShipYear
,Sum(Freight) as TotalFreight
,Avg(Freight) as AvgFreight 
From Sales.SalesOrderHeader
Group by 
Year(ShipDate))a

/*Q3.  Ken Sánchez, the CEO of AdventureWorks, has recently changed his email address.

a. What is Ken's current email address?

b. Update his email address to 'Ken.Sánchez@adventure-works.com'*/

--Solution: 

--a. 
Select *
From Person.Person p
Where p.FirstName ='Ken'
and p.LastName = 'Sánchez'
 
Select 
ea.EmailAddress --'ken0@adventure-works.com
From Person.Person p 
Inner Join HumanResources.Employee e on e.BusinessEntityID = p.BusinessEntityID
Inner Join Person.EmailAddress ea on ea.BusinessEntityID = p.BusinessEntityID
Where p.FirstName ='Ken'
and p.LastName = 'Sánchez'
 
--b. 

Update Person.EmailAddress
Set EmailAddress = 'Ken.Sánchez@adventure-works.com'
Where BusinessEntityID = 1

/*4.  a. Calculate the age for every current employee. What is the age of the oldest employee?

b. What is the average age by Organization level? Show answer with a single decimal

c. Use the ceiling function to round up

d. Use the floor function to round down*/

Solution: 

Select 
BusinessEntityID
,DATEDIFF(Year,BirthDate,'2014-08-15') as Age
From HumanResources.Employee
Order by 2 desc
 
--b. 
Select 
OrganizationLevel
,Format(Avg(cast(DATEDIFF(Year,BirthDate,'2014-08-15') as decimal)),'N1') as Age
From HumanResources.Employee
Group by OrganizationLevel
Order by 2 desc
 
--c. 
Select 
OrganizationLevel
,Format(Avg(cast(DATEDIFF(Year,BirthDate,'2014-08-15') as decimal)),'N1') as Age
,Ceiling(Avg(cast(DATEDIFF(Year,BirthDate,'2014-08-15') as decimal))) as Age
From HumanResources.Employee
Group by OrganizationLevel
Order by 2 desc
 
--d. 
Select 
OrganizationLevel
,Format(Avg(cast(DATEDIFF(Year,BirthDate,'2014-08-15') as decimal)),'N1') as Age
,Ceiling(Avg(cast(DATEDIFF(Year,BirthDate,'2014-08-15') as decimal))) as Age
,Floor(Avg(cast(DATEDIFF(Year,BirthDate,'2014-08-15') as decimal))) as Age
From HumanResources.Employee
Group by OrganizationLevel
Order by 2 desc

/*5 a. Show each credit rating by a count of vendors

b. Use a case statement to specify each rating by a count of vendors:

1 = Superior

2 = Excellent

3 = Above Average

4 = Average

5 = Below Average

c. Using the Choose Function accomplish the same results as part b (Don't use case statement).

1 = Superior

2 = Excellent

3 = Above Average

4 = Average

5 = Below Average

d. Using a case statement show the PreferredVendorStatus by a count of Vendors. (This might seem redundant, but This exercise will help you learn when to use a case statement and when to use the choose function).

0 = Not Preferred

1 = Preferred

e. Using the Choose Function accomplish the same results as part d (Don't use case statement).  Why doesn't the Choose Function give the same results as part d? Which is correct?

0 = Not Preferred

1 = Preferred*/

--Solution

SELECT * FROM Purchasing.Vendor

--a.
Select
CreditRating
,Count(name) as CNT
From Purchasing.Vendor
Group by CreditRating

--b.

Select
Case When CreditRating = 1 Then 'Superior'
When CreditRating = 2 Then 'Excellent'
When CreditRating = 3 Then 'Above Average'
When CreditRating = 4 Then 'Average'
When CreditRating = 5 Then 'Below Average'
Else Null End as CreditRating
,Count(name) as CNT
From Purchasing.Vendor
Group by CreditRating

--c.

Select
Choose(CreditRating
,'Superior'
,'Excellent'
,'Above Average'
,'Average'
,'Below Average') as CreditRating
,Count(name) as CNT
From Purchasing.Vendor
Group by CreditRating

--d.
Select
Case When PreferredVendorStatus = 0 Then 'Not Preferred'
When PreferredVendorStatus = 1 Then 'Preferred'
Else Null End as VendorStatus
,Count(name) as CNT
From Purchasing.Vendor
Group by PreferredVendorStatus

--e.
Select
Choose(PreferredVendorStatus
,'Not Preferred','Preferred') as VendorStatus
,Count(name) as CNT
From Purchasing.Vendor
Group by PreferredVendorStatus

/*6. a. How many Sales people are meeting their YTD Quota? Use an Inner query (subquery) to show a single value meeting this criteria

b. How many Sales People have YTD sales greater than the average Sales Person YTD sales. Also use an Inner Query to show a single value of those meeting this criteria.*/

--Solution: 

--a.
Select 
Count(*) as CNT
From(
Select * 
From Sales.SalesPerson
Where SalesYTD > SalesQuota) a
 
--b. 
Select 
Count(*) as CNT
From Sales.SalesPerson
Where SalesYTD >
(Select Avg(SalesYTD)
From Sales.SalesPerson)

/*7. Write a script that will show the following Columns

- BusinessEntityID

- Sales Person Name - Include Middle

- SalesTerritory Name

- SalesYTD from Sales.SalesPerson

Order by SalesYTD desc */

Solution: 

Select 
sp.BusinessEntityID
,Concat(FirstName,COALESCE (' ' + MiddleName, ''),' ',LastName) as FullName
,isnull(st.Name,'No Territory') as TerritoryName
,Format(sp.SalesYTD,'C0') as SalesYTD
From Sales.SalesPerson sp
Inner Join Person.Person p on p.BusinessEntityID = sp.BusinessEntityID
Left Join Sales.SalesTerritory st on st.TerritoryID = sp.TerritoryID
Order by sp.SalesYTD desc


/*8. Add three columns to this above script.

1. Rank each Sales Person's SalesYTD to all the sales persons. The highest

   SalesYTD will be rank number 1

2. Rank each Sales Person's SalesYTD to the sales persons in their territory.

   The highest SalesYTD in the territory will be rank number 1

3. Create a Percentile for each sales person compared to all the sales people.

   The highest SalesYTD will be in the 100th percentile*/

 --Solution: 

 Select 
sp.BusinessEntityID
,Concat(FirstName,COALESCE (' ' + MiddleName, ''),' ',LastName) as FullName
,isnull(st.Name,'No Territory') as TerritoryName
,Format(sp.SalesYTD,'C0') as SalesYTD
,RANK() Over(Order by sp.SalesYTD desc) as TotalRank
,RANK() Over(Partition by st.Name Order by sp.SalesYTD desc) as TerritoryRank
,Format(PERCENT_RANK() Over(Order by sp.SalesYTD asc),'P0') as TotalPercentRank
From Sales.SalesPerson sp
Inner Join Person.Person p on p.BusinessEntityID = sp.BusinessEntityID
Left Join Sales.SalesTerritory st on st.TerritoryID = sp.TerritoryID
Order by sp.SalesYTD desc




