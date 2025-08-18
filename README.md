# SQL Data Cleaning and Analysis Project  

## 📌 Overview  
This project demonstrates SQL skills through **data cleaning and exploratory analysis** on a structured dataset. The goal was to prepare messy raw data for analysis, remove inconsistencies, and generate insights using SQL queries.  

---

## 📂 Project Structure  
sql-project/
├── schema.sql # Table creation scripts
├── inserts.sql # Sample dataset inserts
├── cleaning.sql # Data cleaning queries
├── analysis.sql # Analytical queries and results
└── README.md # Project documentation

---

## 🛠️ Skills & Concepts Used  
- **Data Cleaning**
  - Removing duplicates  
  - Handling NULL and blank values  
  - Standardizing data formats  
- **Filtering & Selection**
  - `WHERE`, `LIKE`, `BETWEEN`, `IN`  
- **Aggregations**
  - `COUNT`, `SUM`, `AVG`, `MIN`, `MAX`  
  - `GROUP BY` and `HAVING`  
- **Joins**
  - `INNER JOIN`, `LEFT JOIN`  
- **Subqueries**
  - Filtering using nested queries  
- **CTEs (Common Table Expressions)**
  - Improving query readability  
- **Window Functions**
  - Ranking and running totals  

---

## 📊 Example Queries  

**1. Remove duplicate rows:**  
```sql
WITH CTE_Duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY company, location, industry
               ORDER BY company
           ) AS row_num
    FROM layoffs_staging2
**)
DELETE
FROM CTE_Duplicates
WHERE row_num > 1;

