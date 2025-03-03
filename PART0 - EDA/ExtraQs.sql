use MedicareAnalysis;

/******* Section A. Payment Coverage & Cost Analysis ****************/

-- Q1a: Overall Average Medicare Coverage Percentage (Inpatient vs. Outpatient)
SELECT 
    'Inpatient' AS Category, 
    AVG((Average_Medicare_Payments * 100.0) / NULLIF(Average_Covered_Charges, 0)) AS Avg_Medicare_Coverage_Percentage
FROM Medicare_Charge_Inpatient_DRG
UNION ALL
SELECT 
    'Outpatient' AS Category, 
    AVG((Average_Total_Payments * 100.0) / NULLIF(Average_Estimated_Submitted_Charges, 0)) AS Avg_Payment_Coverage_Percentage
FROM Medicare_Charge_Outpatient_APC;


-- Q1b: Medicare Coverage Percentage Per Procedure (Grouped by DRG for Inpatient & APC for Outpatient)

--INpatient
SELECT 
    DRG_Definition AS [Procedure_Name],  -- Renamed alias to avoid conflict
    AVG((Average_Medicare_Payments * 100.0) / NULLIF(Average_Covered_Charges, 0)) AS Avg_Medicare_Coverage_Percentage
FROM Medicare_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Avg_Medicare_Coverage_Percentage DESC;

--OUT
SELECT 
    APC AS [Procedure_Name],  -- Using a different alias name
    AVG((Average_Total_Payments * 100.0) / NULLIF(Average_Estimated_Submitted_Charges, 0)) AS Avg_Payment_Coverage_Percentage
FROM Medicare_Charge_Outpatient_APC
GROUP BY APC
ORDER BY Avg_Payment_Coverage_Percentage DESC;



-- Q2a: Cost Discrepancy (Difference Between Provider Charge & Medicare Payment) Per Procedure
SELECT 
    DRG_Definition AS [Procedure], 
    AVG(Average_Covered_Charges - Average_Medicare_Payments) AS Avg_Cost_Difference,
    AVG((Average_Covered_Charges - Average_Medicare_Payments) * 100.0 / NULLIF(Average_Covered_Charges, 0)) AS Cost_Difference_Percentage
FROM Medicare_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Cost_Difference_Percentage DESC;

SELECT 
    APC AS [Procedure], 
    AVG(Average_Estimated_Submitted_Charges - Average_Total_Payments) AS Avg_Cost_Difference,
    AVG((Average_Estimated_Submitted_Charges - Average_Total_Payments) * 100.0 / NULLIF(Average_Estimated_Submitted_Charges, 0)) AS Cost_Difference_Percentage
FROM Medicare_Charge_Outpatient_APC
GROUP BY APC
ORDER BY Cost_Difference_Percentage DESC;



-- Q2b: Breakdown of Remaining Payment Percentage (Covered by Other Payers or Patient Out-of-Pocket)
SELECT 
    DRG_Definition AS [Procedure], 
    AVG((Average_Total_Payments - Average_Medicare_Payments) * 100.0 / NULLIF(Average_Total_Payments, 0)) AS Out_of_Pocket_Percentage
FROM Medicare_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Out_of_Pocket_Percentage DESC;

SELECT 
    APC AS [Procedure], 
    AVG((Average_Estimated_Submitted_Charges - Average_Total_Payments) * 100.0 / NULLIF(Average_Estimated_Submitted_Charges, 0)) AS Out_of_Pocket_Percentage
FROM Medicare_Charge_Outpatient_APC
GROUP BY APC
ORDER BY Out_of_Pocket_Percentage DESC;

--OVERALL AVG
SELECT 
    'Inpatient' AS Category, 
    AVG(((Average_Total_Payments - Average_Medicare_Payments) * 100.0) / NULLIF(Average_Covered_Charges, 0)) AS Out_of_Pocket_Percentage
FROM Medicare_Charge_Inpatient_DRG
UNION ALL
SELECT 
    'Outpatient' AS Category, 
    AVG(((Average_Estimated_Submitted_Charges - Average_Total_Payments) * 100.0) / NULLIF(Average_Estimated_Submitted_Charges, 0)) AS Out_of_Pocket_Percentage
FROM Medicare_Charge_Outpatient_APC;


/******* Section B. Demographic & Income Group Analysis ************/

-- Total number Inpatients vs Outpatients


-- Q3a: Average Percentage of Medicare Coverage for Each Income Group (Overall)
SELECT 
    p.Income, 
    ROUND(AVG((i.Average_Medicare_Payments * 100.0) / NULLIF(i.Average_Covered_Charges, 0)), 2) AS Avg_Medicare_Coverage_Percentage
FROM Patient_History p
JOIN Transaction_ t ON p.ID = t.ID
JOIN Provider_Charge_Inpatient_DRG i 
    ON TRY_CAST(LEFT(i.DRG_Definition, CHARINDEX(' -', i.DRG_Definition) - 1) AS INT) = t.Global_Proc_ID
GROUP BY p.Income
ORDER BY Avg_Medicare_Coverage_Percentage DESC;

SELECT 
    p.Age, 
    ROUND(AVG((i.Average_Medicare_Payments * 100.0) / NULLIF(i.Average_Covered_Charges, 0)), 2) AS Avg_Medicare_Coverage_Percentage
FROM Patient_History p
JOIN Transaction_ t ON p.ID = t.ID
JOIN Provider_Charge_Inpatient_DRG i 
    ON TRY_CAST(LEFT(i.DRG_Definition, CHARINDEX(' -', i.DRG_Definition) - 1) AS INT) = t.Global_Proc_ID
GROUP BY p.Age
ORDER BY Avg_Medicare_Coverage_Percentage DESC;

SELECT 
    p.gender, 
    ROUND(AVG((i.Average_Medicare_Payments * 100.0) / NULLIF(i.Average_Covered_Charges, 0)), 2) AS Avg_Medicare_Coverage_Percentage
FROM Patient_History p
JOIN Transaction_ t ON p.ID = t.ID
JOIN Provider_Charge_Inpatient_DRG i 
    ON TRY_CAST(LEFT(i.DRG_Definition, CHARINDEX(' -', i.DRG_Definition) - 1) AS INT) = t.Global_Proc_ID
GROUP BY p.gender
ORDER BY Avg_Medicare_Coverage_Percentage DESC;

-- Q3b: Medicare Coverage Percentage by Procedure Type (DRG/APC) and Income Group
SELECT 
    p.Income, 
    i.DRG_Definition, 
    ROUND(AVG((i.Average_Medicare_Payments * 100.0) / NULLIF(i.Average_Covered_Charges, 0)), 2) AS Avg_Medicare_Coverage_Percentage
FROM Patient_History p
JOIN Transaction_ t ON p.ID = t.ID
JOIN Provider_Charge_Inpatient_DRG i 
    ON TRY_CAST(LEFT(i.DRG_Definition, CHARINDEX(' -', i.DRG_Definition) - 1) AS INT) = t.Global_Proc_ID
GROUP BY p.Income, i.DRG_Definition
ORDER BY p.Income, Avg_Medicare_Coverage_Percentage DESC;

SELECT 
    p.Income, 
    i.DRG_Definition, 
    ROUND(AVG((i.Average_Medicare_Payments * 100.0) / NULLIF(i.Average_Covered_Charges, 0)), 2) AS Avg_Medicare_Coverage_Percentage
FROM Patient_History p
JOIN Transaction_ t ON p.ID = t.ID
JOIN Provider_Charge_Inpatient_DRG i 
    ON TRY_CAST(LEFT(i.DRG_Definition, CHARINDEX(' -', i.DRG_Definition) - 1) AS INT) = t.Global_Proc_ID
GROUP BY p.Income, i.DRG_Definition
ORDER BY p.Income, Avg_Medicare_Coverage_Percentage DESC;



-- Q4: Medicare Coverage Percentage by Age, Income, and Gender
SELECT 
    p.Age, 
    p.Income, 
    p.Gender, 
    ROUND(AVG((i.Average_Medicare_Payments * 100.0) / NULLIF(i.Average_Covered_Charges, 0)), 2) AS Avg_Medicare_Coverage_Percentage
FROM Patient_History p
JOIN Transaction_ t ON p.ID = t.ID
JOIN Provider_Charge_Inpatient_DRG i 
    ON TRY_CAST(LEFT(i.DRG_Definition, CHARINDEX(' -', i.DRG_Definition) - 1) AS INT) = t.Global_Proc_ID
GROUP BY p.Age, p.Income, p.Gender
ORDER BY p.Age, p.Income, p.Gender;

SELECT 
    p.Age, 
    p.Income, 
    p.Gender, 
    ROUND(AVG((o.Average_Total_Payments * 100.0) / NULLIF(o.Average_Estimated_Submitted_Charges, 0)), 2) AS Avg_Medicare_Coverage_Percentage
FROM Patient_History p
JOIN Transaction_ t ON p.ID = t.ID
JOIN Provider_Charge_Outpatient_APC o 
    ON TRY_CAST(LEFT(o.APC, CHARINDEX(' -', o.APC) - 1) AS INT) = t.Global_Proc_ID
GROUP BY p.Age, p.Income, p.Gender
ORDER BY p.Age, p.Income, p.Gender;


/******* Section C. Demand & Utilization Analysis *********/

-- Q5a: Total Number of Patients for Each Procedure (Overall Demand)
SELECT 
    i.DRG_Definition AS [Procedure], 
    COUNT(DISTINCT t.ID) AS Total_Patients
FROM Transaction_ t
JOIN Provider_Charge_Inpatient_DRG i ON t.Global_Proc_ID = TRY_CAST(LEFT(i.DRG_Definition, CHARINDEX(' -', i.DRG_Definition) - 1) AS INT)
GROUP BY i.DRG_Definition
ORDER BY Total_Patients DESC;

SELECT 
    o.APC AS [Procedure], 
    COUNT(DISTINCT t.ID) AS Total_Patients
FROM Transaction_ t
JOIN Provider_Charge_Outpatient_APC o ON t.Global_Proc_ID = TRY_CAST(LEFT(o.APC, CHARINDEX(' -', o.APC) - 1) AS INT)
GROUP BY o.APC
ORDER BY Total_Patients DESC;

-- Q5b: How Does the Patient Count for Each Procedure Vary by Age Group and Gender?
SELECT 
    p.Age, 
    p.Gender, 
    i.DRG_Definition AS [Procedure], 
    COUNT(DISTINCT t.ID) AS Total_Patients
FROM Transaction_ t
JOIN Patient_History p ON t.ID = p.ID
JOIN Provider_Charge_Inpatient_DRG i ON t.Global_Proc_ID = TRY_CAST(LEFT(i.DRG_Definition, CHARINDEX(' -', i.DRG_Definition) - 1) AS INT)
GROUP BY p.Age, p.Gender, i.DRG_Definition
ORDER BY p.Age, p.Gender, Total_Patients DESC;

SELECT 
    p.Age, 
    p.Gender, 
    o.APC AS [Procedure], 
    COUNT(DISTINCT t.ID) AS Total_Patients
FROM Transaction_ t
JOIN Patient_History p ON t.ID = p.ID
JOIN Provider_Charge_Outpatient_APC o ON t.Global_Proc_ID = TRY_CAST(LEFT(o.APC, CHARINDEX(' -', o.APC) - 1) AS INT)
GROUP BY p.Age, p.Gender, o.APC
ORDER BY p.Age, p.Gender, Total_Patients DESC;



/******* Section D. Provider Distribution & Analysis *********/

-- 6. Geographical Distribution of Providers

-- Q6a: Total number of unique providers per city
SELECT 
    Provider_City, 
    COUNT(DISTINCT Provider_Id) AS Total_Unique_Providers
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_City
ORDER BY Total_Unique_Providers DESC;


--  Q6b: Distribution of providers per state
SELECT TOP 5
    Provider_State, 
    COUNT(DISTINCT Provider_Id) AS Total_Unique_Providers
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_State
ORDER BY Total_Unique_Providers DESC;


SELECT TOP 5
    Provider_State, 
    COUNT(DISTINCT Provider_Id) AS Total_Unique_Providers
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_State
ORDER BY Total_Unique_Providers ASC;

-- 7. Provider Availability by Diagnosis/Treatment
-- Insight: Focus on diagnoses with few providers—check if their charges are significantly higher.

-- Q7a: Inpatient - Providers per Diagnosis (DRG) & Charge Analysis
SELECT 
    DRG_Definition,
    COUNT(DISTINCT Provider_Id) AS Total_Providers_Offering,
    ROUND(AVG(Average_Covered_Charges), 2) AS Avg_Covered_Charge,
    ROUND(MAX(Average_Covered_Charges), 2) AS Max_Covered_Charge,
    ROUND(MIN(Average_Covered_Charges), 2) AS Min_Covered_Charge,
    ROUND(MAX(Average_Covered_Charges) - MIN(Average_Covered_Charges), 2) AS Charge_Difference
FROM Provider_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Total_Providers_Offering ASC;


-- Q7b: Outpatient - Providers per Procedure (APC) & Charge Analysis
SELECT 
    APC,
    COUNT(DISTINCT Provider_Id) AS Total_Providers_Offering,
    ROUND(AVG(Average_Estimated_Submitted_Charges), 2) AS Avg_Submitted_Charge,
    ROUND(MAX(Average_Estimated_Submitted_Charges), 2) AS Max_Submitted_Charge,
    ROUND(MIN(Average_Estimated_Submitted_Charges), 2) AS Min_Submitted_Charge,
    ROUND(MAX(Average_Estimated_Submitted_Charges) - MIN(Average_Estimated_Submitted_Charges), 2) AS Charge_Difference
FROM Provider_Charge_Outpatient_APC
GROUP BY APC
ORDER BY Total_Providers_Offering ASC;


-- 8. Provider Price Variability for the Same Procedure

--  Q8a: Inpatient (DRG) - Price Variability & Demand Analysis
SELECT 
    DRG_Definition AS Procedure_Type,
    COUNT(DISTINCT Provider_Id) AS Total_Providers_Offering,
    SUM(Total_Discharges) AS Total_Demand,
    CONCAT('$', FORMAT(ROUND(AVG(Average_Covered_Charges), 2), 'N2')) AS Avg_Covered_Charge,
    CONCAT('$', FORMAT(ROUND(STDEV(Average_Covered_Charges), 2), 'N2')) AS Std_Dev_Charge,
    CONCAT(
        FORMAT(
            ROUND(
                (STDEV(Average_Covered_Charges) / NULLIF(AVG(Average_Covered_Charges), 0)) * 100, 
            2), 'N2'), '%'
    ) AS Percentage_Variability,
    CASE
        WHEN (STDEV(Average_Covered_Charges) / NULLIF(AVG(Average_Covered_Charges), 0)) * 100 >= 60
        THEN 'Severe Variability (≥60%)'
        WHEN (STDEV(Average_Covered_Charges) / NULLIF(AVG(Average_Covered_Charges), 0)) * 100 >= 50
        THEN 'Significant Variability (50%-60%)'
        ELSE 'Low Variability (<50%)'
    END AS Variability_Flag
FROM Provider_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Percentage_Variability DESC;

-- Q8b: Outpatient (APC) - Price Variability & Demand Analysis
SELECT 
    APC AS Procedure_Type,
    COUNT(DISTINCT Provider_Id) AS Total_Providers_Offering,
    SUM(Outpatient_Services) AS Total_Demand,
    CONCAT('$', FORMAT(ROUND(AVG(Average_Estimated_Submitted_Charges), 2), 'N2')) AS Avg_Submitted_Charge,
    CONCAT('$', FORMAT(ROUND(STDEV(Average_Estimated_Submitted_Charges), 2), 'N2')) AS Std_Dev_Charge,
    CONCAT(
        FORMAT(
            ROUND(
                (STDEV(Average_Estimated_Submitted_Charges) / NULLIF(AVG(Average_Estimated_Submitted_Charges), 0)) * 100, 
            2), 'N2'), '%'
    ) AS Percentage_Variability,
    CASE
        WHEN (STDEV(Average_Estimated_Submitted_Charges) / NULLIF(AVG(Average_Estimated_Submitted_Charges), 0)) * 100 >= 60
        THEN 'Severe Variability (≥60%)'
        WHEN (STDEV(Average_Estimated_Submitted_Charges) / NULLIF(AVG(Average_Estimated_Submitted_Charges), 0)) * 100 >= 50
        THEN 'Significant Variability (50%-60%)'
        ELSE 'Low Variability (<50%)'
    END AS Variability_Flag
FROM Provider_Charge_Outpatient_APC
GROUP BY APC
ORDER BY Percentage_Variability DESC;


/******* Section E. Transaction Data Deep Dive *********/

-- 9.	Procedure Frequency in Transaction Data

--  Q9a: Most Frequently Performed Procedures
-- Most Frequent Procedures (Original)
SELECT 
    Global_Proc_ID AS Procedure_Code,
    SUM(Count) AS Total_Procedure_Count
FROM Transaction_
GROUP BY Global_Proc_ID
ORDER BY Total_Procedure_Count DESC;

-- Most Frequent Procedures (Reviewed)
SELECT 
    Global_Proc_ID AS Procedure_Code,
    SUM(Count) AS Total_Procedure_Count
FROM Review_transaction
GROUP BY Global_Proc_ID
ORDER BY Total_Procedure_Count DESC;

-- Q9b: Frequency Comparison with Average Charges & Payment Differences

--INpatient
SELECT 
    t.Global_Proc_ID AS Procedure_Code,
    SUM(t.Count) AS Total_Procedure_Count,
    CONCAT('$', FORMAT(ROUND(AVG(p.Average_Covered_Charges), 2), 'N2')) AS Avg_Covered_Charge,
    CONCAT('$', FORMAT(ROUND(AVG(p.Average_Total_Payments), 2), 'N2')) AS Avg_Total_Payment,
    CONCAT('$', FORMAT(ROUND(AVG(p.Average_Covered_Charges - p.Average_Total_Payments), 2), 'N2')) AS Avg_Payment_Difference
FROM Transaction_ t
JOIN Provider_Charge_Inpatient_DRG p
    ON t.Global_Proc_ID = p.DRG_Definition
GROUP BY t.Global_Proc_ID
ORDER BY Total_Procedure_Count DESC;


-- 10.	Correlation Between Volume & Payment Discrepancies
-- Is there a relationship between the number of transactions for a procedure and the discrepancy between the 
-- billed amount and the Medicare payment, potentially indicating systemic overcharging in high-volume procedures?
SELECT 
    p.DRG_Definition AS Procedure_Type,
    SUM(t.Count) AS Total_Transactions,
    ROUND(AVG(p.Average_Covered_Charges), 2) AS Avg_Billed_Amount,
    ROUND(AVG(p.Average_Medicare_Payments), 2) AS Avg_Medicare_Payment,
    ROUND(AVG(p.Average_Covered_Charges) - AVG(p.Average_Medicare_Payments), 2) AS Avg_Discrepancy,
    CONCAT(
        ROUND(
            ((AVG(p.Average_Covered_Charges) - AVG(p.Average_Medicare_Payments)) / NULLIF(AVG(p.Average_Covered_Charges), 0)) * 100, 
        2), '%') AS Percentage_Discrepancy
FROM Transaction_ t
JOIN Provider_Charge_Inpatient_DRG p
    ON t.Global_Proc_ID = CAST(LEFT(p.DRG_Definition, CHARINDEX(' ', p.DRG_Definition) - 1) AS INT)
GROUP BY p.DRG_Definition
ORDER BY Percentage_Discrepancy DESC;



-- 

-- 

-- 

-- 

-- 

-- 

-- 

-- 