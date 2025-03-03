use MedicareAnalysis;

/*****************************Medicare_Charge_Inpatient_DRG*********************************/
-- 1. Top 10 Most Expensive Inpatient Procedures
-- Sorting by Average Medicare Payments to find the most expensive inpatient procedures.
SELECT TOP 10 
    DRG_Definition, 
    AVG(Average_Medicare_Payments) AS Avg_Medicare_Payment
FROM Medicare_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Avg_Medicare_Payment DESC;


-- 2. Average Medicare Payment Per Procedure
-- Finding the average Medicare payment per procedure type.
SELECT 
    DRG_Definition, 
    COUNT(*) AS Procedure_Count, 
    AVG(Average_Medicare_Payments) AS Avg_Medicare_Payment
FROM Medicare_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Avg_Medicare_Payment DESC;


-- 3.  Highest Inpatient Charges by Procedure
-- Sorting by Average Covered Charges to find the procedures with the highest billing rates.
SELECT TOP 10 
    DRG_Definition, 
    AVG(Average_Covered_Charges) AS Avg_Covered_Charge
FROM Medicare_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Avg_Covered_Charge DESC;

-- 4. Discharge Trends by Procedure
-- Finding total discharges per procedure type.
SELECT 
    DRG_Definition, 
    SUM(Total_Discharges) AS Total_Discharges
FROM Medicare_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Total_Discharges DESC;

/*****************************Medicare_Charge_Outpatient_APC*********************************/

--1. Most Expensive Outpatient Procedures
-- Sorting APC (procedure type) by highest average estimated submitted charges (what providers bill Medicare).
SELECT TOP 10 
    APC, 
    AVG(Average_Estimated_Submitted_Charges) AS Avg_Submitted_Charge
FROM Medicare_Charge_Outpatient_APC
GROUP BY APC
ORDER BY Avg_Submitted_Charge DESC;

--2. Difference Between Estimated Charge & Payment
--Checking the gap between what providers bill (submitted charge) vs. what is actually paid (total payment).
SELECT 
    APC, 
    AVG(Average_Estimated_Submitted_Charges) AS Avg_Submitted_Charge, 
    AVG(Average_Total_Payments) AS Avg_Total_Payment, 
    AVG(Average_Estimated_Submitted_Charges - Average_Total_Payments) AS Avg_Difference
FROM Medicare_Charge_Outpatient_APC
GROUP BY APC
ORDER BY Avg_Difference DESC;

-- 3. Most Common Outpatient Procedures
--Finding procedures that appear most frequently in the dataset.
SELECT TOP 10 
    APC, 
    SUM(Outpatient_Services) AS Total_Services
FROM Medicare_Charge_Outpatient_APC
GROUP BY APC
ORDER BY Total_Services DESC;


/*****************************Provider_Charge_Inpatient_DRG*********************************/

-- 1. Regional Variations in Inpatient Costs
--Comparing the average covered charges (what hospitals bill) and average total payments 
--(what Medicare + others actually pay) across different Hospital Referral Regions (HRR).
SELECT 
    Hospital_Referral_Region,
    AVG(Average_Covered_Charges) AS Avg_Covered_Charge,
    AVG(Average_Total_Payments) AS Avg_Total_Payment,
    AVG(Average_Medicare_Payments) AS Avg_Medicare_Payment
FROM Provider_Charge_Inpatient_DRG
GROUP BY Hospital_Referral_Region
ORDER BY Avg_Covered_Charge DESC;

--2. Providers Billing Significantly Higher Than Others
--Finding hospitals that charge far above the average for inpatient procedures.
SELECT TOP 10 
    Provider_ID, 
    Provider_Name, 
    Provider_State, 
    AVG(Average_Covered_Charges) AS Avg_Covered_Charge
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_ID, Provider_Name, Provider_State
ORDER BY Avg_Covered_Charge DESC;

-- 3. Hospitals with Highest Patient Volume
--Sorting hospitals by total discharges (i.e., highest inpatient case volume).
SELECT TOP 10 
    Provider_ID, 
    Provider_Name, 
    Provider_State, 
    SUM(Total_Discharges) AS Total_Patient_Volume
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_ID, Provider_Name, Provider_State
ORDER BY Total_Patient_Volume DESC;


/****************************Provider_Charge_Outpatient_APC**********************************/

--1. Most expensive outpatient providers
SELECT TOP 10 
    Provider_ID, 
    Provider_Name, 
    Provider_State, 
    AVG(Average_Estimated_Submitted_Charges) AS Avg_Submitted_Charge
FROM Provider_Charge_Outpatient_APC
GROUP BY Provider_ID, Provider_Name, Provider_State
ORDER BY Avg_Submitted_Charge DESC;


--2. Difference between billed (submitted) vs. reimbursed (total payments) amounts
SELECT 
    Provider_ID, 
    Provider_Name, 
    Provider_State,
    AVG(Average_Estimated_Submitted_Charges) AS Avg_Billed,
    AVG(Average_Total_Payments) AS Avg_Reimbursed,
    AVG(Average_Estimated_Submitted_Charges) - AVG(Average_Total_Payments) AS Avg_Difference
FROM Provider_Charge_Outpatient_APC
GROUP BY Provider_ID, Provider_Name, Provider_State
ORDER BY Avg_Difference DESC;


--3.Top states with the highest outpatient costs
SELECT TOP 10 
    Provider_State, 
    AVG(Average_Estimated_Submitted_Charges) AS Avg_Submitted_Charge
FROM Provider_Charge_Outpatient_APC
GROUP BY Provider_State
ORDER BY Avg_Submitted_Charge DESC;


/*****************************Patient_history*********************************/

-- 1. Age & Gender Distribution of Medicare Patients
SELECT 
    Age, 
    Gender, 
    COUNT(ID) AS Patient_Count
FROM Patient_History
GROUP BY Age, Gender
ORDER BY Age, Gender;


-- 2.Income Distribution of Patients
SELECT 
    Income, 
    COUNT(ID) AS Patient_Count
FROM Patient_History
GROUP BY Income
ORDER BY Income;


-- 3.High-Risk Patient Groups
SELECT 
    Age, 
    Income, 
    COUNT(ID) AS Patient_Count
FROM Patient_History
WHERE Age IN ('75-84', '85+') OR Income IN ('Low', 'Very Low')
GROUP BY Age, Income
ORDER BY Age, Income;



/*****************************Review_patient_history*********************************/

-- 1. Compare Reviewed vs. Original Patient Data
-- Checking how many records changed at all (any difference in age, gender, or income).
SELECT 
    COUNT(PH.ID) AS Total_Changed_Records
FROM Patient_History PH
JOIN Review_Patient_History RPH ON PH.ID = RPH.ID
WHERE 
    PH.Age <> RPH.Age 
    OR PH.Gender <> RPH.Gender 
    OR PH.Income <> RPH.Income;


-- 2. Identify Discrepancies in Age, Gender, or Income



/****************************Transaction_**********************************/

-- 1. Patients with the highest number of transactions
SELECT 
    ID, 
    COUNT(*) AS Total_Transactions
FROM Transaction_
GROUP BY ID
ORDER BY Total_Transactions DESC;


-- 2. Most frequently billed procedures
SELECT 
    Global_Proc_ID, 
    SUM(Count) AS Total_Procedures
FROM Transaction_
GROUP BY Global_Proc_ID
ORDER BY Total_Procedures DESC;


-- 3. Average number of procedures per patient
SELECT 
    AVG(Total_Procedures) AS Avg_Procedures_Per_Patient
FROM (
    SELECT 
        ID, 
        SUM(Count) AS Total_Procedures
    FROM Transaction_
    GROUP BY ID
) AS Patient_Procedure_Count;


/*****************************Review_transaction*********************************/

-- Identify anomalies in reviewed transactions
/**To identify anomalies, we can check for discrepancies such as significant differences in transaction counts 
or unusual procedure frequencies after review. Here, we'll consider the change in the number of procedures 
before and after the review.**/
SELECT 
    t1.ID AS Transaction_ID,
    t1.Global_Proc_ID,
    t1.Count AS Original_Count,
    t2.Count AS Reviewed_Count,
    (t2.Count - t1.Count) AS Count_Difference,
    CASE 
        WHEN ABS(t2.Count - t1.Count) > 5 THEN 'Anomaly' 
        ELSE 'Normal' 
    END AS Anomaly_Flag
FROM 
    Transaction_ t1
JOIN 
    Review_transaction t2
    ON t1.ID = t2.ID
    AND t1.Global_Proc_ID = t2.Global_Proc_ID;


-- Compare transaction trends before and after review

-- Before Review
SELECT 
    Global_Proc_ID, 
    SUM(Count) AS Total_Transactions_Before_Review
FROM Transaction_
GROUP BY Global_Proc_ID
ORDER BY Total_Transactions_Before_Review DESC;

-- After Review
SELECT 
    Global_Proc_ID, 
    SUM(Count) AS Total_Transactions_After_Review
FROM Review_transaction
GROUP BY Global_Proc_ID
ORDER BY Total_Transactions_After_Review DESC;
