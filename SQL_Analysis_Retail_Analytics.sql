-- Creating table for retail customer data (data imported into table from csv)
CREATE TABLE retail_customer_data(
'ID' INT PRIMARY KEY,
'Year_Birth' INT,
'Education' VARCHAR(50),
'Marital_Status' VARCHAR(50),
'Income' INT,
'Kidhome' INT,
'Teenhome' INT,
'Dt_Customer' DATE,
'Recency' INT,
'Age' INT ) ;


-- Creating table for products and purchases (data imported into table from csv)
CREATE TABLE products_purchase_data(
'ID' INT PRIMARY KEY,
'MntWines' INT,
'MntFruits' INT,
'MntMeatProducts' INT,
'MntFishProducts' INT,
'MntSweetProducts' INT,
'MntGoldProducts' INT,
'NumDealsPurchases' INT,
'NumWebPurchases' INT,
'NumCatalogPurchases' INT,
'NumStorePurchases' INT,
'NumWebVisitsMonth' INT,
FOREIGN KEY ('ID') REFERENCES retail_customer_data('ID') ) ;


-- Creating table for campaigns and responses (data imported into table from csv)
CREATE TABLE campaigns_response_data(
'ID' INT PRIMARY KEY,
'AcceptedCmp3' INT,
'AcceptedCmp4' INT,
'AcceptedCmp5' INT,
'AcceptedCmp1' INT,
'AcceptedCmp2' INT,
'Complain' INT,
'Response' INT,
FOREIGN KEY ('ID') REFERENCES retail_customer_data('ID'),
FOREIGN KEY ('ID') REFERENCES products_purchase_data('ID') ) ;



-- Calculating the total number of customer encounters
SELECT COUNT(ID) AS 'Total_Customer_Encounters'
FROM retail_customer_data rcd ;  -- 2,236 transactions


-- Calculating number of customers
SELECT COUNT(DISTINCT ID) AS 'Total_Customers'
FROM retail_customer_data rcd ;  -- 2,236 customers


-- Calculating total responses to all marketing campaigns
SELECT SUM(Response) AS 'Total_Campaign_Responses'
FROM campaigns_response_data crd ;  -- 332 campaign responses


-- Calculating number of customers by education level
SELECT Education , COUNT(ID) AS 'Number_of_Customers'
FROM retail_customer_data rcd
GROUP BY Education
ORDER BY COUNT (ID) DESC;


-- Calculating number of customers by marital status
SELECT Marital_Status , COUNT(ID) AS 'Number_of_Customers'
FROM retail_customer_data rcd
GROUP BY Marital_Status 
ORDER BY COUNT(ID) DESC ;


-- Calculating average income for customers who participated in a marketing campaign
SELECT ROUND(AVG(rcd.Income), 2) AS 'Average_Income'
FROM retail_customer_data rcd
INNER JOIN campaigns_response_data crd ON rcd.ID = crd.ID
WHERE crd.AcceptedCmp1 IS 1 OR crd.AcceptedCmp2 IS 1 OR crd.AcceptedCmp3 IS 1 OR crd.AcceptedCmp4 OR crd.AcceptedCmp5 IS 1;  -- $64,660.32


-- Identifying the distribution of customers responses to the last campaign
SELECT AcceptedCmp5 , COUNT(ID) AS 'Number_of_Customers'
FROM campaigns_response_data crd 
GROUP BY AcceptedCmp5 ;  -- 162 YES, 2074 NO


-- Calculating average number of children per household
SELECT ROUND(AVG(Kidhome), 2) AS 'Average_Num_Children_per_Home'
FROM retail_customer_data rcd ;


-- Calculating average number of teenagers per household
SELECT ROUND(AVG(Teenhome), 2) AS 'Average_Num_Teens_per_Home'
FROM retail_customer_data rcd ;


-- Creating view to add column for age groups
CREATE VIEW retail_customer_date_age_groups AS
	SELECT *,
	CASE
		WHEN Age BETWEEN 18 AND 25 THEN '18 - 25'
		WHEN Age BETWEEN 26 AND 35 THEN '26 - 35'
		WHEN Age BETWEEN 36 AND 45 THEN '36 - 45'
		WHEN Age BETWEEN 46 AND 55 THEN '46 - 55'
		ELSE '56+'
	END AS 'Age_Group'
	FROM retail_customer_data rcd ;


-- Calculating average number of web visits per month for each age group
SELECT rcdag.Age_Group , ROUND(AVG(ppd.NumWebVisitsMonth), 2) AS 'Avg_Web_Visits_per_Month'
FROM retail_customer_date_age_groups rcdag  
INNER JOIN products_purchase_data ppd ON rcdag.ID = ppd.ID
GROUP BY rcdag.Age_Group ;


-- Calculating total number of times each campaign was accepted
SELECT COUNT(ID) as 'Total_Accepted', 'Campaign 1' as Campaign
FROM campaigns_response_data crd
WHERE AcceptedCmp1 = 1
GROUP BY AcceptedCmp1 
UNION
SELECT COUNT(ID) as 'Total_Accepted', 'Campaign 2'
FROM campaigns_response_data crd
WHERE AcceptedCmp2 = 1
GROUP BY AcceptedCmp2 
UNION
SELECT COUNT(ID) as 'Total_Accepted', 'Campaign 3'
FROM campaigns_response_data crd
WHERE AcceptedCmp3 = 1
GROUP BY AcceptedCmp3 
UNION
SELECT COUNT(ID) as 'Total_Accepted', 'Campaign 4'
FROM campaigns_response_data crd
WHERE AcceptedCmp4 = 1
GROUP BY AcceptedCmp4 
UNION
SELECT COUNT(ID) as 'Total_Accepted', 'Campaign 5'
FROM campaigns_response_data crd
WHERE AcceptedCmp5 = 1
GROUP BY AcceptedCmp5 ;









