# ☕ Dirty Cafe Sales Dataset

## 📌 Overview
The **Dirty Cafe Sales Dataset** contains **10,000 rows** of synthetic transactional data from a cafe.  
This dataset is intentionally "dirty," including **missing values, inconsistencies, and errors** to simulate real-world data challenges.

It is ideal for practicing:
- Data cleaning
---
## 📂 File Information
- **File Name:** `dirty_cafe_sales.csv`  
- **Number of Rows:** 10,000  
- **Number of Columns:** 8  
---
## 📊 Columns Description
| Column Name        | Description                                                                 | Example Values        |
|------------------|-----------------------------------------------------------------------------|----------------------|
| Transaction ID   | Unique identifier for each transaction (always present and unique)          | TXN_1234567          |
| Item             | Name of the purchased item (may contain missing/invalid values)             | Coffee, Sandwich     |
| Quantity         | Quantity purchased (may contain invalid values like "UNKNOWN")              | 1, 3, UNKNOWN        |
| Price Per Unit   | Price of a single unit (may contain missing/incorrect values)               | 2.00, 4.00           |
| Total Spent      | Total transaction amount (Quantity × Price Per Unit)                        | 8.00, 12.00          |
| Payment Method   | Payment type (may include missing or "UNKNOWN")                             | Cash, Credit Card    |
| Location         | Transaction location (may contain missing values)                           | In-store, Takeaway   |
| Transaction Date | Date of transaction (may contain missing or inconsistent formats)           | 2023-01-01           |
---
## ⚠️ Data Characteristics
### Missing Values
- Present in columns like **Item, Payment Method, Location**
- Represented as `None`, empty cells, or blanks
### Invalid Values
- Includes entries such as:
  - `NULL`
  - `"ERROR"`
  - `"UNKNOWN"`
### Price Consistency
- Prices follow a fixed structure but may include:
  - Missing values
  - Incorrect entries
---
## 🍽️ Menu Items & Pricing
| Item      | Price ($) |
|----------|----------|
| Coffee   | 2.00     |
| Tea      | 1.50     |
| Sandwich | 4.00     |
| Salad    | 5.00     |
| Cake     | 3.00     |
| Cookie   | 1.00     |
| Smoothie | 4.00     |
| Juice    | 3.00     |
---
## 🎯 Use Cases
This dataset is suitable for:
- 🧹 Practicing **data cleaning techniques**
- 🤖 Preparing data for **machine learning models**
---
## 🛠️ Suggested Data Cleaning Steps

### 1. Handle Missing Values
- Fill categorical columns with: `"Unknown"`
---
### 2. Handle Invalid Values
- Replace `"ERROR"` and `"UNKNOWN"` with `Unknown`
- Standardize inconsistent entries
---
### 3. Change data type: 
- Varchar to Date, float following the value of each fields
-------
### 4. Validate Calculations
- Recalculate:
  - `Total Spent = Quantity × Price Per Unit`
  - `Quantity = Total Spent / Price Per Unit`
  - `Price Per Unit = Total Spent / Quantity`
- Correct inconsistencies
---
## 🧠 Skills Demonstrated
- Data cleaning & preprocessing  
- Handling missing & inconsistent data  
- Data transformation  
- Feature engineering  
