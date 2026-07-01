# Olist Automated Business Intelligence Reporting System

## Overview

This project is an end-to-end Business Intelligence and Reporting Automation solution built using the Olist Brazilian E-Commerce dataset. It automates the complete reporting process by extracting data from a PostgreSQL database, executing advanced SQL queries through Python, generating CSV reports, and visualizing business insights in Power BI.

The project demonstrates how organizations can automate daily reporting workflows and reduce manual effort while providing interactive dashboards for business decision-making.

---

# Project Architecture

```
Olist Dataset
      │
      ▼
PostgreSQL Database
      │
      ▼
Advanced SQL Queries
      │
      ▼
Python Automation
      │
      ▼
CSV Report Generation
      │
      ▼
Windows Task Scheduler
      │
      ▼
Power BI Dashboard
```

---

# Features

- Automated SQL report execution
- Advanced SQL analytics using CTEs and Window Functions
- Automatic CSV report generation
- Windows Task Scheduler integration
- Interactive Power BI dashboards
- Error handling and logging
- Organized report generation by business domain

---

# Technologies Used

| Technology | Purpose |
|------------|---------|
| PostgreSQL | Database Management |
| SQL | Business Analytics |
| Python | Automation |
| pandas | Data Processing |
| psycopg2 | PostgreSQL Connection |
| os | File & Folder Management |
| re | SQL Parsing |
| logging | Automation Logging |
| Windows Task Scheduler | Report Scheduling |
| Power BI | Dashboard & Visualization |
| DAX | KPI Measures |

---

# Project Structure

```
OlistAutomation
│
├── sql/
│   ├── customer_analysis.sql
│   ├── seller_analysis.sql
│   ├── product_analysis.sql
│   ├── order_analysis.sql
│   └── executive_dashboard.sql
│
├── dashboard/
│   └── Olist Dashboard.pbix
│
├── report.py
├── run_report.bat
├── config_example.py
├── requirements.txt
├── README.md
└── .gitignore
```

---

# Business Reports

The automation generates reports for:

### Executive Dashboard
- Total Revenue
- Total Orders
- Total Customers
- Total Sellers
- Revenue Contribution
- Monthly Performance

### Customer Analysis
- Customer Revenue
- Customer Lifetime Value
- Top Customers
- Customer States
- Average Order Value

### Seller Analysis
- Seller Revenue
- Seller Ranking
- Monthly Seller Performance
- Average Review Score
- Freight Analysis

### Product Analysis
- Product Categories
- Best Selling Products
- Revenue by Category
- Product Performance

### Order Analysis
- Order Status
- Delivery Performance
- Payment Analysis
- Freight Analysis

---

# Automation Workflow

1. Connect to PostgreSQL database.
2. Read SQL files automatically.
3. Split multiple SQL queries using section headers.
4. Execute each query.
5. Export query results as CSV files.
6. Save reports into organized folders.
7. Record execution logs.
8. Schedule daily execution using Windows Task Scheduler.
9. Refresh Power BI dashboards using updated CSV reports.

---

# SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- INNER JOIN
- LEFT JOIN
- Common Table Expressions (CTEs)
- Window Functions
  - LAG()
  - DENSE_RANK()
  - PERCENT_RANK()
  - ROW_NUMBER()
  - SUM() OVER()
- Aggregate Functions
- Date Functions

---

# Python Concepts Used

- Database Connectivity
- File Handling
- Regular Expressions
- Logging
- Error Handling
- Automation
- CSV Export
- Folder Management

---

# Power BI

The Power BI dashboard includes:

- KPI Cards
- Bar Charts
- Column Charts
- Line Charts
- Treemaps
- Donut Charts
- Business Performance Visualizations

---

# Skills Demonstrated

- SQL Development
- PostgreSQL
- Business Intelligence
- Data Analysis
- Python Automation
- Report Automation
- Data Visualization
- Power BI Dashboard Development
- DAX
- Task Scheduling
- End-to-End Reporting Pipeline

---

# Future Enhancements

- Direct Power BI PostgreSQL connection
- Power BI Service deployment
- Scheduled cloud refresh
- Email report automation
- PDF report generation
- Azure integration

---

# Author

**Uroosa Khan**

Data Analyst | Business Intelligence | SQL | Python | Power BI

GitHub: https://github.com/yourusername

LinkedIn: https://linkedin.com/in/yourprofile
