# Customer Behavior Analysis for AdventureWorks | SQL

<img width="1000" height="500" alt="Cover project github" src="https://github.com/user-attachments/assets/3cd605b4-4298-4a31-8c63-2322021b1967" />

**Author:** Vu Bich Loan <br>
**Date:** September 2025 <br>
**Tool Used:** SQL <br>

## Table of Contents
[📌Background & Overview](#background--overview) <br>
[📂Dataset Description & Data Structure](#dataset-description--data-structure) <br>
[⚙️Main Process](#main-process) <br>
[✔️Final Conclusion & Recommendations](#final-conclusion--recommendations) <br>
 
## 📌Background & Overview
**📖 What is this project about?** <br>
This project analyzes a dataset using SQL to extract insights about customer behaviors and deliver data-driven recommendations to enhance customer loyalty and optimize sales strategies.

**👤Who is this project for?**
- Data Analysts & Business Analysts
- Digital Marketing Teams
- Sale Manager, Sale Team

**❓Business Questions:** <br>
- What are the monthly trends in customer purchasing behavior? <br>
- What time periods see our highest sales volume? <br>
- Which products are our best-sellers? <br>
- What other products are frequently purchased? <br>

## 📂Dataset Description & Data Structure
### Data Description
- **Data Source:** Kaggle
- The AW_Sales2016 contains 23,935 records 
- **Format:** CSV
### Table Used & Relationships <br>
**1. Table Used** <br>
The dataset consists of **5 main tables** used to analyze: <br>
**👥AW_Customers**
<details>
<summary><strong>Table 1: AW_Customers</strong></summary>
  
|**Column Name**  | **Description**    |
|-----------------|--------------------|
| `CustomerKey`    | ID of customer    |
| `Prefix`, `FirstName`, `LastName`, `BirthDate`, `MaritalStatus`, `Gender`, `EmailAddress`, <br> `AnnualIncome`, `TotalChildren`, `EducationLevel`, `Occupation`, `Home Owner` | Customer Info |

</details> 

**📦AW_Product_Categories**
<details>
<summary><strong>Table 2: AW_Product_Categories</strong></summary>
  
|**Column Name**       | **Description**            |
|----------------------|----------------------------|
| `ProductCategoryKey` | Unique Category identifier |
| `CategoryName`       | Name of Category           |

</details>

**🗂️AW_Product_Subcategories**
<details>
<summary><strong>Table 3: AW_Product_Subcategories</strong></summary>
  
|**Column Name**          | **Description**               |
|-------------------------|-------------------------------|
| `ProductSubcategoryKey` | Unique Subcategory identifier |
| `SubcategoryName`       | Name of Subcategory           |
| `ProductCategoryKey`    | Category reference            |

</details>

**🛒AW_Products**
<details>
<summary><strong>Table 4: AW_Products</strong></summary>
  
|**Column Name**          | **Description**           |
|-------------------------|---------------------------|
| `ProductKey`            | Unique Product identifier |
| `ProductSubcategoryKey` | Subcategory reference     |
| `ProductSKU`, `ProductName`, `ModelName`, `ProductDescription`, <br> `ProductColor`, `ProductSize`, `ProductStyle`| Product Characteristics |
| `ProductCost`           | Product Cost              |
| `ProductPrice`          | Product Price             |

</details> 

**📈AW_Sales2016**
<details>
<summary><strong>Table 5: AW_Sales2016</strong></summary>
  
|**Column Name**          | **Description**            |
|-------------------------|----------------------------|
| `OrderDate`             | Order creation Date        |
| `StockDate`             | Date Added to Stock        |
| `OrderNumber`           | Sale Order Number          |
| `ProductKey`            | Product reference          |
| `CustomerKey`           | Customer reference         |
| `OrderLineItem`         | Each row represents a single item in the order |
| `OrderQuantity`         | Quantity ordered           |

</details>

**2. Table Relationships**

| **From Table**                 | **To Table**                     | **Join Key**                | **Relationship Type**                                      |
|--------------------------------|----------------------------------|-----------------------------|------------------------------------------------------------|
| `AW_Customer`                  | `AW_Sales2016`                   | `CustomerKey`               | One-to-Many (one customer made many orders)                |
| `AW_Products`                  | `AW_Product_Subcategories`       | `ProductSubcategoryKey`     | One-to-Many (each product belongs to one subcategory)      |
| `AW_Product_Subcategories`     | `AW_Product_Categories`          | `ProductCategoryKey`        | One-to-Many (each subcategory belongs to one category      |
| `AW_Products`                  | `AW_Sales2016`                   | `ProductKey`                | One-to-Many (one product in many orders)                   |

## ⚙️Main Process
### 1. Product Performance Analysis
#### 1.1 🔍Calculate total purchase value by Product Subcategory
The goal of this analysis is to identify the top product subcategories with the highest purchase value. <br>

- **▶️Query** <br>
```sql
SELECT cate.CategoryName,
		subcate.SubcategoryName,
		pro.ProductName,
		SUM(sale.OrderQuantity) AS OrderQuantity,
		pro.ProductPrice,
		SUM(sale.OrderQuantity)*pro.ProductPrice AS PurchaseValue
FROM AW_Products pro
JOIN AW_Product_Subcategories subcate ON pro.ProductSubcategoryKey = subcate.ProductSubcategoryKey
JOIN AW_Product_Categories cate ON subcate.ProductCategoryKey = cate.ProductCategoryKey
JOIN AW_Sales2016 sale ON sale.ProductKey = pro.ProductKey
GROUP BY cate.CategoryName,
		subcate.SubcategoryName,
		pro.ProductName, 
		pro.ProductPrice
ORDER BY PurchaseValue DESC;
```
- **💡Query result** <br>

<img width="470" height="186" alt="image" src="https://github.com/user-attachments/assets/3caa9382-9b48-4c17-99d9-bd3995825294" /> <br>

- **🧠Insights** <br>
Mountain Bikes is the product subcategory with the highest total purchase value. <br>

#### 1.2 🔍Other products purchased by customers who purchased product subcategory “Mountain Bikes"
Identify the other product subcategories purchased by customers who bought the "Mountain Bikes". The output should list the product subcategory name and the quantity ordered, providing insights into cross-selling opportunities and customer preferences. <br>

- **▶️Query** <br>
```sql
WITH cross_selling AS
(SELECT sale.OrderNumber,
		cate.CategoryName,
		subcate.SubcategoryName,
		pro.ProductName
FROM AW_Sales2016 sale
JOIN AW_Products pro ON sale.ProductKey = pro.ProductKey
JOIN AW_Product_Subcategories subcate ON pro.ProductSubcategoryKey = subcate.ProductSubcategoryKey
JOIN AW_Product_Categories cate ON subcate.ProductCategoryKey = cate.ProductCategoryKey
WHERE sale.OrderNumber IN (
		SELECT sale.OrderNumber
		FROM AW_Sales2016 sale
		JOIN AW_Products pro ON sale.ProductKey = pro.ProductKey
		JOIN AW_Product_Subcategories subcate ON pro.ProductSubcategoryKey = subcate.ProductSubcategoryKey
		JOIN AW_Product_Categories cate ON subcate.ProductCategoryKey = cate.ProductCategoryKey
		WHERE subcate.SubcategoryName = 'Mountain Bikes')
		)
SELECT SubcategoryName, 
		COUNT(*) AS Quanity
FROM cross_selling
GROUP BY SubcategoryName
ORDER BY Quanity DESC;
```
- **💡Query result** <br>

<img width="449" height="188" alt="image" src="https://github.com/user-attachments/assets/ade87069-08ff-4c65-8557-4c7aba1029c2" /> <br>

- **🧠Insights** <br>
Customers who bought the "Mountain Bikes" showed interest in related products like "Bottles and Cages" and "Tires and Tubes", which presents an opportunity for cross-selling. <br>

#### 1.3 🔍(Price Effect) Does the cheapest one sell more? 
This analysis is to identify whether the pricing strategy is effective. <br>
- **▶️Query** <br>
```sql
SELECT pro.ProductPrice,
	SUM(sale.OrderQuantity) AS TotalQuantity
FROM AW_Products pro 
JOIN AW_Sales2016 sale ON pro.ProductKey = sale.ProductKey
GROUP BY pro.ProductPrice
ORDER BY pro.ProductPrice;
```
- **💡Query result** <br>

<img width="447" height="186" alt="image" src="https://github.com/user-attachments/assets/bf3d60d6-9729-4864-a9a9-17ffe1d88b94" /> <br>

- **🧠Insights** <br>
The analysis shows that there is no strong correlation between a product's price and its sales volume. The cheapest items are not necessarily the best-sellers, which suggests that other factors, such as product quality or brand reputation, may be more important to customers. <br>

### 2. Customer Purchase Trends
#### 2.1 🔍Customer Lifetime Value (CLV)
Calculate the total profit that a customer brings to the company over the entire duration of their relationship. This analysis will identify and segment the most valuable customers of the company. The company can then tailor marketing campaigns, loyalty programs, and special offers to your high-value customers to ensure they stay engaged and loyal. <br>
- **▶️Query** <br>
```sql
SELECT cus.CustomerKey AS CustomerKey,
		cus.FirstName + ' ' + cus.LastName AS FullName,
		SUM(pro.ProductPrice * sale.OrderQuantity) AS PurchaseValue
FROM AW_Sales2016 AS sale
JOIN AW_Customers cus ON sale.CustomerKey = cus.CustomerKey
JOIN AW_Products pro ON sale.ProductKey = pro.ProductKey
GROUP BY cus.CustomerKey, 
		cus.FirstName + ' ' + cus.LastName
ORDER BY PurchaseValue DESC
```
- **💡Query result** <br>

<img width="401" height="186" alt="image" src="https://github.com/user-attachments/assets/a1ae88ba-cb03-49b7-82a0-c29e1ef86882" /> <br>

#### 2.2 🔍Segment customers by spending size (VIP, Medium, Low Value)
The main purpose of segmenting customers by spending size (VIP, Medium, Low Value) is to optimize your business and marketing strategy. By understanding each group, the company can focus resources on high-value customers to increase profitability and personalize marketing efforts to better engage each segment. <br>
**▶️Query** <br>
```sql
WITH segment AS (
SELECT  cus.CustomerKey AS CustomerKey,
		cus.FirstName + ' ' + cus.LastName AS FullName,
		SUM(pro.ProductPrice * sale.OrderQuantity) AS PurchaseValue
FROM AW_Sales2016 AS sale
JOIN AW_Customers cus ON sale.CustomerKey = cus.CustomerKey
JOIN AW_Products pro ON sale.ProductKey = pro.ProductKey
GROUP BY cus.CustomerKey, 
		cus.FirstName + ' ' + cus.LastName
)
SELECT DISTINCT CustomerKey,
				FullName,
				CASE WHEN PurchaseValue < 500 THEN 'Low Value'
					WHEN PurchaseValue > = 500 AND PurchaseValue < 1000 THEN 'Medium'
				ELSE 'VIP'
				END AS Segment
FROM segment
```
- **💡Query result** <br>

<img width="437" height="188" alt="image" src="https://github.com/user-attachments/assets/29993ac0-ba02-4639-ab37-e938a8c0a9f0" /> <br>

#### 2.3 🔍Calculate total purchase value by month
Calculate the total purchase value by month to understand how customer behavior differs within months, providing insights into customer engagement and purchase behavior. <br>
- **▶️Query** <br>
```sql
SELECT MONTH(OrderDate) AS Month,
		SUM(OrderQuantity) AS Total_purchase
FROM AW_Sales2016
GROUP BY MONTH(OrderDate)
ORDER BY MONTH(OrderDate)
```
- **💡Query result** <br>

<img width="449" height="176" alt="image" src="https://github.com/user-attachments/assets/61a31f2f-e7d6-4c2c-8448-d0a46d450876" /> <br>
- **🧠Insights** <br>
Total purchase value significantly increases in the latter half of 2016. It indicates an upward trend in purchase value during the latter half of 2016. <br>

#### 2.4 🔍(Repeat Customers) Calculate the percentage of customers who purchased more than once
The main purpose of calculating the percentage of repeat customers is to measure customer loyalty and the effectiveness of your retention strategies. <br>
- **▶️Query** <br>
```sql
WITH purchase_count AS (
	SELECT CustomerKey,
		COUNT(DISTINCT OrderNumber) AS PurchaseCount
FROM AW_Sales2016
GROUP BY CustomerKey
)
SELECT (COUNT(CASE WHEN PurchaseCount > 1 THEN CustomerKey END) * 100) / COUNT(CustomerKey) AS Repeat_Customer_Rate
FROM purchase_count
```
- **💡Query result** <br>

<img width="452" height="70" alt="image" src="https://github.com/user-attachments/assets/35d9ca73-7375-453d-8815-d0d96560adbf" /> <br>

- **🧠Insights** <br>
The repeat customer rate is 13%. This is a concerningly low figure, which indicates that a very small percentage of our existing customers are returning to make a purchase. This could be a sign that the customer retention strategies are not very effective, or that the product/service isn't providing a strong enough incentive for customers to return. <br>

#### 2.5 🔍Calculate average number of orders per customer by month
The purpose of calculating the average number of orders per customer by month is to measure the purchase frequency of repeat buyers and understand how often our loyal customers are buying from us. <br>
- **▶️Query** <br>
```sql
SELECT MONTH(OrderDate) AS Month,
		SUM(sale.OrderQuantity)/COUNT(DISTINCT sale.CustomerKey) AS Avg_Purchases
FROM AW_Sales2016 AS sale
JOIN AW_Customers cus ON sale.CustomerKey = cus.CustomerKey
GROUP BY MONTH(OrderDate)
ORDER BY Month;
```
- **💡Query result** <br>

<img width="449" height="183" alt="image" src="https://github.com/user-attachments/assets/6929d7e7-693c-4aab-892a-1a2c9d582144" /> <br>

- **🧠Insights** <br>
From January to June, the average customer made only one purchase per month. In the latter half of 2016, this number increased significantly, with the average customer making 3 to 4 purchases per month. This indicates that the latter half of the year is when customers make the most purchases. <br>

#### 2.6 🔍Calculate the average amount of money per order by month
This analysis calculates the average amount of money per order by month to understand customer spending trends over time. <br>
- **▶️Query** <br>
```sql
SELECT MONTH(OrderDate) AS Month,
		SUM(sale.OrderQuantity*pro.ProductPrice)/COUNT(DISTINCT sale.OrderNumber) AS Avg_Amount
FROM AW_Sales2016 AS sale
JOIN AW_Customers cus ON sale.CustomerKey = cus.CustomerKey
JOIN AW_Products pro ON pro.ProductKey = sale.ProductKey
GROUP BY MONTH(OrderDate)
ORDER BY Month;
```
- **💡Query result** <br>

<img width="448" height="184" alt="image" src="https://github.com/user-attachments/assets/e09577d9-7de7-455d-9684-fc80c23ca9cb" /> <br>

- **🧠Insights** <br>
	- In the first half (January to June), the Average Order Value (AOV) is high, suggesting customers are making large, one-time purchases, likely for high-ticket items. This is coupled with a low repeat purchase rate. <br>
	- Conversely, in the second half of the year (July to December), the AOV drops significantly, while the purchase frequency increases dramatically. This indicates that customers are returning to buy smaller, less expensive items more often. <br>

## ✔️Final Conclusion & Recommendations
### 📌Conclusion
| **Aspect**        | **Insight** |
|-------------------|-------------|
|Purchasing behavior| Customers who bought the "Mountain Bikes" showed interest in related products like "Bottles and Cages" and "Tires and Tubes", which presents an opportunity for cross-selling.|
|Purchasing trends  | In the latter half of 2016, customers purchased more frequently and repeatedly, driving up total purchase value, though the average spend per order was lower.|
### 📌Recommendations
- **Bundle Products:** Create and promote product bundles that combine mountain bikes with relevant accessories like bottles, cages, and tires.
- **Optimize Website Layout:** Display "frequently bought together" or "customers also purchased" sections on the mountain bike product pages, featuring the identified related products.
- **Loyalty programs:** Leverage loyalty programs and repeat-purchase incentives to sustain higher shopping frequency.
- **Optimize Customer Retention:** Strengthen customer retention strategies by offering loyalty rewards, exclusive discounts, or personalized product recommendations to encourage repeat business throughout the year, not just in the second half.
- **Selling strategies:** Apply up-selling and cross-selling strategies (e.g., bundles, free shipping thresholds) to increase average order value.















