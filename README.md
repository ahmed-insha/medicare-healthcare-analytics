# medicare-healthcare-analytics

# Case Study – Healthcare Data Analysis

## Business Context
In the U.S., Medicare reimburses private providers for medical procedures performed for covered individuals. To ensure that procedures and costs are consistent and reasonable, Medicare must verify claims and detect possible errors or fraudulent activities. This project aims to analyze Medicare data and uncover anomalies in patients, procedures, providers, and regions.

## Objective
The goal of this project is to:
- Identify anomalous entities in Medicare claims.
- Detect providers, areas, or patients with unusual procedures or claim patterns.
- Create a database in SQL Server for efficient data management.
- Develop interactive dashboards using Power BI.
- Perform detailed exploratory data analysis (EDA) in SQL and Python.
- Connect Python to SQL Server for advanced analytics.
- Deploy a predictive model using Streamlit for anomaly detection.

## Problem Summary
The project is divided into multiple phases:

### Part 0: SQL Server Database & Power BI Dashboard
- Create a database in SQL Server.
- Perform detailed exploratory data analysis (EDA) using SQL.
- Connect Power BI to SQL Server for dynamic dashboard creation.
- Define Key Performance Indicators (KPIs), Key Risk Indicators (KRIs), and dashboard layout.

### Part 1: Provider and Regional Cost Analysis
- **Part 1A:** Identify highest cost variation in procedures.
- **Part 1B:** Detect providers with the highest-cost claims.
- **Part 1C:** Analyze regions with the highest-cost claims.
- **Part 1D:** Examine the number of procedures and differences between claims and reimbursements.

### Part 2: Identifying Anomalous Providers and Regions
- **Part 2A:** Identify three providers that differ significantly from others.
- **Part 2B:** Find three regions that are least similar to others.

### Part 3: Anomalous Patient Detection
- Detect 10,000 Medicare patients involved in anomalous activities using advanced anomaly detection techniques.

### Part 4: Predictive Modeling
- Formulate a predictive analytics problem.
- Develop and deploy a machine learning model using Streamlit.

### Part 5: Reporting & Presentation
- Prepare a comprehensive report including:
  - Data understanding
  - Analysis
  - Observations and insights
  - Recommendations

 #### Dashboard Link: https://app.powerbi.com/view?r=eyJrIjoiMjkxMDI1NWMtMjU2Yi00MmQxLTk5OTEtN2EyZDQwOTMzNzY3IiwidCI6ImYzMjA5Nzg5LTg5MDEtNGIxNC04OGQyLWMxNDUxY2YwNmNhNSJ9

 #### Anomaly Detection App: 
 - Streamlit App Link: https://medicare-anomaly-detection-nlgw.onrender.com
 - Username: admin
 - Password: 123

## Data Sources
This project utilizes multiple datasets, including:
- **Review_Patient:** Contains patient demographic information.
- **Transaction:** Records details of medical procedures performed.
- **Patient_History:** Includes past medical records and income information.
- **Provider Data:** Contains information on healthcare providers and their claims.
- **Medicare Data:** Contains information on procedure-wise costs and claims.

## Technologies Used
- **SQL Server** for database management.
- **Python** for data analysis and anomaly detection.
- **Power BI** for interactive dashboard development.
- **Machine Learning** for predictive analytics.
- **Streamlit** for model deployment.


## Conclusion
This project provides insights into fraudulent and erroneous claims within Medicare, enabling better detection and prevention mechanisms. The integration of SQL, Python, Power BI, and ML techniques ensures a comprehensive approach to healthcare data analysis.

