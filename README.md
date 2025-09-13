# Customer Behavior Analysis for AdventureWorks | SQL

<img width="1000" height="500" alt="Cover project github" src="https://github.com/user-attachments/assets/3cd605b4-4298-4a31-8c63-2322021b1967" />

**Author:** Vu Bich Loan <br>
**Date:** September 2025 <br>
**Tool Used:** SQL <br>

## Table of Contents
[📌Background & Overview](#background--overview) <br>
[📂Dataset Description & Data Structure](#dataset-description--data-structure)

## 📌Background & Overview
**📖 What is this project about?** <br>
This project analyzes a dataset using SQL to extract insights about customer behaviors and deliver data-driven recommendations to enhance customer loyalty and optimize sales strategies.

**👤Who is this project for?**

**❓Business Questions:** <br>

## 📂Dataset Description & Data Structure
### Data Description
- **Data Source:** Kaggle
- The AW_Sales2016 contains 23,935 records 
- **Format:** CSV
### Table Used & Relationships
**1. Table Used**
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


