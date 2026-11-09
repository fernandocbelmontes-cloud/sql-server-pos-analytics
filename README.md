# Relational Database Engineering & Analytics (T-SQL / SQL Server)

## Project Overview
This repository showcases the database architecture, backend logic, and analytical pipelines designed for a **Point of Sale (POS) and Inventory/Library Management System** built natively in **Microsoft SQL Server**.

The project demonstrates advanced database engineering practices, shifting heavy data manipulation workloads from the application layer directly to the database engine for maximum performance and transactional integrity.

## Key Features & Database Capabilities Demonstrated:
*   **Advanced Analytical Querying:** Implementation of multi-table `INNER`, `LEFT`, `RIGHT`, and `FULL OUTER JOINS` to resolve complex business metrics.
*   **Hierarchical Data Structures:** Developed complex **Recursive Common Table Expressions (CTEs)** to navigate nested category levels and inventory hierarchies.
*   **Real-Time Inventory Automation:** Built native `AFTER INSERT` and `INSTEAD OF` database **Triggers** to automate live stock level reductions, validate negative stock limits, and enforce audit logs.
*   **Modular Architecture:** Created optimized **Stored Procedures** utilizing input/output (`OUTPUT`) parameters and explicit error handling (`TRY...CATCH`) to securely handle data manipulation (DML).
*   **Performance Optimization:** Strategic deployment of `CLUSTERED` and `NONCLUSTERED` database indexes to accelerate data retrieval speeds on transactional tables.
*   **Business Intelligence Reporting Views:** Created relational database `VIEWS` aggregating operational metrics like sales volumes per client to feed Business Intelligence (BI) dashboards.

## Repository Structure
*   `01-database-design/`: DDL schemas, primary/foreign keys definitions, and transactional mock data initialization.
*   `02-stored-procedures/`: Automated routines for customer management and automated metric extractions.
*   `03-triggers-and-views/`: Logic pipelines for automated auditing, safe deletion constraints, and pre-calculated reporting views.
*   `04-advanced-analytics/`: Mathematical, string, and date manipulation functions alongside recursive CTE pipelines.

## Tech Stack
*   **Database Engine:** Microsoft SQL Server (T-SQL)
*   **Tools:** SQL Server Management Studio (SSMS)
