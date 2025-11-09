# 🧹 SQL Data Cleaning and Analysis Project

## 📖 Overview
This project demonstrates my SQL skills through a complete data cleaning and exploratory analysis workflow.  
The dataset focuses on company layoffs and simulates real-world messy data scenarios — including duplicates, missing values, inconsistent formatting, and invalid entries.  

The goal was to transform raw data into a reliable, analysis-ready format and uncover insights into layoff patterns across industries, countries, and company stages.  
This project reflects how SQL can be used for both **data engineering** and **data analysis** tasks.

---

## 🗂️ Project Structure
```plaintext
sql-project/
├── schema.sql        # Table creation and schema definition
├── inserts.sql       # Sample data population script
├── cleaning.sql      # Data cleaning and transformation queries
├── analysis.sql      # Analytical and exploratory SQL queries
└── README.md         # Project documentation

---

## 🧠 Skills & Concepts Used

### 🧹 Data Cleaning
- Removed duplicate records using `ROW_NUMBER()` and CTEs  
- Handled `NULL` and blank values with conditional updates  
- Standardized inconsistent data entries (e.g., trimming spaces, fixing date formats, cleaning country and industry names)  
- Removed irrelevant records for cleaner analysis  

### 🔍 Filtering & Selection
- Used `WHERE`, `LIKE`, `BETWEEN`, and `IN` for conditional filtering  
- Extracted meaningful subsets of data based on company size, industry, or region  

### 📊 Aggregations & Grouping
- Summarized data using `COUNT`, `SUM`, `AVG`, `MIN`, and `MAX`  
- Grouped results with `GROUP BY` and refined analysis using `HAVING`  

### 🔗 Joins & Relationships
- Connected related tables using `INNER JOIN` and `LEFT JOIN`  
- Validated data integrity across sources  

### 🧩 Subqueries & CTEs
- Created nested queries for complex filtering  
- Improved readability and maintainability with `WITH` clauses  

### 🪜 Window Functions
- Used `ROW_NUMBER()` for identifying duplicates  
- Applied ranking functions for advanced insights (e.g., top companies or countries by layoffs)

---

## 📈 Key Outcomes
- Cleaned and standardized over **10,000+ records** for consistent analysis  
- Identified **trends in layoffs** across industries and countries  
- Enhanced data reliability by removing duplicate and incomplete records  
- Created **reusable SQL scripts** for data cleaning and analytics workflows  

---

## 🚀 How to Use
1. **Clone the repository**  
   ```bash
   git clone https://github.com/<your-username>/sql-data-cleaning-project.git
   cd sql-data-cleaning-project

2. Import SQL files into your MySQL or PostgreSQL environment.

3. Run scripts in order:
schema.sql,
inserts.sql,
cleaning.sql,
analysis.sql,

4. Explore and modify queries to perform your own analysis or connect results to visualization tools like Power BI or Tableau.
