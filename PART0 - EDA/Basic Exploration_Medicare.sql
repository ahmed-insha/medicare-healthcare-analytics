create database MedicareAnalysis;
use MedicareAnalysis;

SELECT * FROM Medicare_Charge_Inpatient_DRG;
SELECT * FROM Medicare_Charge_Outpatient_APC;
SELECT * FROM Provider_Charge_Inpatient_DRG;
SELECT * FROM Provider_Charge_Outpatient_APC;

SELECT * FROM Patient_history;
SELECT * FROM Review_patient_history;
SELECT * FROM Transaction_;
SELECT * FROM Review_transaction;

/*******************EDA***********************/

-- Step 1: Understand the Data Structure
-- Check the number of records in each table:

SELECT 'Medicare_Charge_Inpatient_DRG' AS TableName, COUNT(*) AS RecordCount FROM Medicare_Charge_Inpatient_DRG
UNION ALL
SELECT 'Medicare_Charge_Outpatient_APC', COUNT(*) FROM Medicare_Charge_Outpatient_APC
UNION ALL
SELECT 'Provider_Charge_Inpatient_DRG', COUNT(*) FROM Provider_Charge_Inpatient_DRG
UNION ALL
SELECT 'Provider_Charge_Outpatient_APC', COUNT(*) FROM Provider_Charge_Outpatient_APC
UNION ALL
SELECT 'Patient_history', COUNT(*) FROM Patient_history
UNION ALL
SELECT 'Review_patient_history', COUNT(*) FROM Review_patient_history
UNION ALL
SELECT 'Transaction_', COUNT(*) FROM Transaction_
UNION ALL
SELECT 'Review_transaction', COUNT(*) FROM Review_transaction;

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'YourTableName';



/**Step 2: Data Completeness & Missing Values**/
-- Checking for NULL values

-- For Inpatient Charge Data
SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN DRG_Definition IS NULL THEN 1 ELSE 0 END) AS Null_DRG,
    SUM(CASE WHEN Total_Discharges IS NULL THEN 1 ELSE 0 END) AS Null_Discharges,
    SUM(CASE WHEN Average_Covered_Charges IS NULL THEN 1 ELSE 0 END) AS Null_Covered_Charges,
    SUM(CASE WHEN Average_Total_Payments IS NULL THEN 1 ELSE 0 END) AS Null_Total_Payments,
    SUM(CASE WHEN Average_Medicare_Payments IS NULL THEN 1 ELSE 0 END) AS Null_Medicare_Payments
FROM Medicare_Charge_Inpatient_DRG;

-- For Outpatient Charge Data
SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN APC IS NULL THEN 1 ELSE 0 END) AS Null_APC,
    SUM(CASE WHEN Outpatient_Services IS NULL THEN 1 ELSE 0 END) AS Null_Services,
    SUM(CASE WHEN Average_Estimated_Submitted_Charges IS NULL THEN 1 ELSE 0 END) AS Null_Submitted_Charges,
    SUM(CASE WHEN Average_Total_Payments IS NULL THEN 1 ELSE 0 END) AS Null_Total_Payments
FROM Medicare_Charge_Outpatient_APC;

-- For Inpatient Provider Charge Data
SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN DRG_Definition IS NULL THEN 1 ELSE 0 END) AS Null_DRG,
    SUM(CASE WHEN Provider_ID IS NULL THEN 1 ELSE 0 END) AS Null_Provider_ID,
    SUM(CASE WHEN Provider_Name IS NULL THEN 1 ELSE 0 END) AS Null_Provider_Name,
    SUM(CASE WHEN Provider_State IS NULL THEN 1 ELSE 0 END) AS Null_Provider_State,
    SUM(CASE WHEN Average_Covered_Charges IS NULL THEN 1 ELSE 0 END) AS Null_Covered_Charges,
    SUM(CASE WHEN Average_Total_Payments IS NULL THEN 1 ELSE 0 END) AS Null_Total_Payments
FROM Provider_Charge_Inpatient_DRG;

-- For Outpatient Provider Charge Data
SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN APC IS NULL THEN 1 ELSE 0 END) AS Null_APC,
    SUM(CASE WHEN Provider_ID IS NULL THEN 1 ELSE 0 END) AS Null_Provider_ID,
    SUM(CASE WHEN Provider_Name IS NULL THEN 1 ELSE 0 END) AS Null_Provider_Name,
    SUM(CASE WHEN Provider_State IS NULL THEN 1 ELSE 0 END) AS Null_Provider_State,
    SUM(CASE WHEN Average_Estimated_Submitted_Charges IS NULL THEN 1 ELSE 0 END) AS Null_Submitted_Charges,
    SUM(CASE WHEN Average_Total_Payments IS NULL THEN 1 ELSE 0 END) AS Null_Total_Payments
FROM Provider_Charge_Outpatient_APC;

-- For Patient History Data
-- Age : 2530
-- Income : 2531
SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS Null_ID,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN Income IS NULL THEN 1 ELSE 0 END) AS Null_Income
FROM Patient_history;

-- For Reviewed Patient History Data
-- Age : 26
-- Income : 26
SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS Null_ID,
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Null_Age,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Null_Gender,
    SUM(CASE WHEN Income IS NULL THEN 1 ELSE 0 END) AS Null_Income
FROM Review_patient_history;

-- For Transaction Data
SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS Null_ID,
    SUM(CASE WHEN Global_Proc_ID IS NULL THEN 1 ELSE 0 END) AS Null_Proc_ID,
    SUM(CASE WHEN Count IS NULL THEN 1 ELSE 0 END) AS Null_Count
FROM Transaction_;

-- For Reviewed Transaction Data
SELECT 
    COUNT(*) AS TotalRecords,
    SUM(CASE WHEN ID IS NULL THEN 1 ELSE 0 END) AS Null_ID,
    SUM(CASE WHEN Global_Proc_ID IS NULL THEN 1 ELSE 0 END) AS Null_Proc_ID,
    SUM(CASE WHEN Count IS NULL THEN 1 ELSE 0 END) AS Null_Count
FROM Review_transaction;


/****************Duplicates*******************/
-- Find duplicate rows in Medicare_Charge_Inpatient_DRG
SELECT *, COUNT(*) AS duplicate_count
FROM Medicare_Charge_Inpatient_DRG
GROUP BY DRG_Definition, Total_Discharges, Average_Covered_Charges, Average_Total_Payments, Average_Medicare_Payments
HAVING COUNT(*) > 1;

-- Find duplicate rows in Medicare_Charge_Outpatient_APC
SELECT *, COUNT(*) AS duplicate_count
FROM Medicare_Charge_Outpatient_APC
GROUP BY APC, Outpatient_Services, Average_Estimated_Submitted_Charges, Average_Total_Payments
HAVING COUNT(*) > 1;

-- Find duplicate rows in Provider_Charge_Inpatient_DRG
SELECT *, COUNT(*) AS duplicate_count
FROM Provider_Charge_Inpatient_DRG
GROUP BY DRG_Definition, Provider_ID, Provider_Name, Provider_Street_Address, Provider_City, Provider_State, 
         Provider_Zip_Code, Hospital_Referral_Region, Total_Discharges, Average_Covered_Charges, 
         Average_Total_Payments, Average_Medicare_Payments
HAVING COUNT(*) > 1;

-- Find duplicate rows in Provider_Charge_Outpatient_APC
SELECT *, COUNT(*) AS duplicate_count
FROM Provider_Charge_Outpatient_APC
GROUP BY APC, Provider_ID, Provider_Name, Provider_Street_Address, Provider_City, Provider_State, 
         Provider_Zip_Code, Hospital_Referral_Region_HRR_Description, Outpatient_Services, 
         Average_Estimated_Submitted_Charges, Average_Total_Payments
HAVING COUNT(*) > 1;

-- Find duplicate rows in Patient_history
SELECT *, COUNT(*) AS duplicate_count
FROM Patient_history
GROUP BY ID, Age, Gender, Income
HAVING COUNT(*) > 1;

-- Find duplicate rows in Review_patient_history
SELECT *, COUNT(*) AS duplicate_count
FROM Review_patient_history
GROUP BY ID, Age, Gender, Income
HAVING COUNT(*) > 1;

-- Find duplicate rows in Transaction_
SELECT *, COUNT(*) AS duplicate_count
FROM Transaction_
GROUP BY ID, Global_Proc_ID, Count
HAVING COUNT(*) > 1;

-- Find duplicate rows in Review_transaction
SELECT *, COUNT(*) AS duplicate_count
FROM Review_transaction
GROUP BY ID, Global_Proc_ID, Count
HAVING COUNT(*) > 1;

---- NO DUPLICATES

/****************Checking if All rows from review data is there in the parent data*******************/

SELECT id FROM Review_patient_history
EXCEPT
SELECT id FROM Patient_history;

SELECT COUNT(*) 
FROM Patient_history p
JOIN Review_patient_history r ON p.ID = r.ID;


SELECT id FROM Review_transaction
EXCEPT
SELECT id FROM Transaction_;





/****************Comparing the Procedure Codes in Transaction table with the medicare provider tables*******************/

SELECT COUNT(DISTINCT Global_Proc_ID) AS Unique_Procedure_Codes
FROM Transaction_;

SELECT DISTINCT Global_Proc_ID AS Unique_Procedure_Codes
FROM Transaction_;



WITH Extracted_DRG AS (
    SELECT 
        CAST(LEFT(DRG_Definition, CHARINDEX(' -', DRG_Definition) - 1) AS INT) AS DRG_Code
    FROM Medicare_Charge_Inpatient_DRG
    WHERE CHARINDEX(' -', DRG_Definition) > 0
),
Extracted_APC AS (
    SELECT 
        CAST(LEFT(APC, CHARINDEX(' -', APC) - 1) AS INT) AS APC_Code
    FROM Medicare_Charge_Outpatient_APC
    WHERE CHARINDEX(' -', APC) > 0
),
Combined_Standard_Codes AS (
    SELECT DRG_Code AS Standard_Code FROM Extracted_DRG
    UNION 
    SELECT APC_Code FROM Extracted_APC
)
SELECT COUNT(*) AS All_Procedure_Codes
FROM Combined_Standard_Codes



SELECT COUNT(*) AS Mismatched_Procedure_Codes
FROM Transaction_ t
LEFT JOIN Combined_Standard_Codes csc 
ON t.Global_Proc_ID = csc.Standard_Code
WHERE csc.Standard_Code IS NULL;





-- check for matching ID values between the Patient_history and Transaction

--  Check Matching IDs (Inner Join Approach)
SELECT DISTINCT 
    ph.ID AS Matching_ID
FROM Patient_history ph
INNER JOIN Transaction_ t
    ON ph.ID = t.ID;

-- Count of Matching IDs
SELECT 
    COUNT(DISTINCT ph.ID) AS Matching_ID_Count
FROM Patient_history ph
INNER JOIN Transaction_ t
    ON ph.ID = t.ID;


-- Detailed Match Analysis
-- (Shows how many transactions each matching patient has)
SELECT 
    ph.ID AS Matching_ID,
    COUNT(t.Global_Proc_ID) AS Total_Transactions
FROM Patient_history ph
INNER JOIN Transaction_ t
    ON ph.ID = t.ID
GROUP BY ph.ID
ORDER BY Total_Transactions DESC;


--- Unique values in Patient History columns
SELECT DISTINCT Age 
FROM Patient_history;

SELECT DISTINCT income 
FROM Patient_history;
