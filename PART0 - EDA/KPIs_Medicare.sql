use MedicareAnalysis;

/*****************Financial KPIs*********************/

-- Average Cost per Procedure	Mean cost Medicare pays per procedure

-- Average cost per inpatient procedure (from Medicare_Charge_Inpatient_DRG)
SELECT 
    DRG_Definition, 
    AVG(Average_Covered_Charges) AS Avg_Cost_Per_Procedure
FROM 
    Medicare_Charge_Inpatient_DRG
GROUP BY 
    DRG_Definition;

-- Average cost per outpatient procedure (from Medicare_Charge_Outpatient_APC)
SELECT 
    APC, 
    AVG(Average_Estimated_Submitted_Charges) AS Avg_Cost_Per_Procedure
FROM 
    Medicare_Charge_Outpatient_APC
GROUP BY 
    APC;


-- Mean cost Medicare pays per inpatient procedure
SELECT 
    DRG_Definition, 
    AVG(Average_Medicare_Payments) AS Mean_Medicare_Payment_Per_Procedure
FROM 
    Medicare_Charge_Inpatient_DRG
GROUP BY 
    DRG_Definition;

-- Mean cost Medicare pays per outpatient procedure
SELECT 
    APC, 
    AVG(Average_Medicare_Payments) AS Mean_Medicare_Payment_Per_Procedure
FROM 
    Medicare_Charge_Outpatient_APC
GROUP BY 
    APC;

-- Top 10 Most Expensive Procedures	Most costly inpatient & outpatient procedures

-- Top most expensive inpatient procedures
SELECT TOP 5
    DRG_Definition, 
    ROUND(AVG(Average_Covered_Charges),2) AS Avg_Cost_Per_Procedure
FROM 
    Medicare_Charge_Inpatient_DRG
GROUP BY 
    DRG_Definition
ORDER BY 
    Avg_Cost_Per_Procedure DESC;

-- Top most expensive outpatient procedures
SELECT TOP 5
    APC, 
    ROUND(AVG(Average_Estimated_Submitted_Charges),2) AS Avg_Cost_Per_Procedure
FROM 
    Medicare_Charge_Outpatient_APC
GROUP BY 
    APC
ORDER BY 
    Avg_Cost_Per_Procedure DESC;


--- TOP Procedures covered by medicare
SELECT TOP 5 
    DRG_Definition,  
    ROUND(AVG(Average_Medicare_Payments * 100.0 / NULLIF(Average_Covered_Charges, 0)), 2) AS Medicare_Coverage_Percentage  
FROM Provider_Charge_Inpatient_DRG  
GROUP BY DRG_Definition  
ORDER BY Medicare_Coverage_Percentage DESC;

SELECT TOP 5 
    APC,  
    ROUND(AVG(Average_Total_Payments * 100.0 / NULLIF(Average_Estimated_Submitted_Charges, 0)), 2) AS Medicare_Coverage_Percentage  
FROM Provider_Charge_Outpatient_APC  
GROUP BY APC  
ORDER BY Medicare_Coverage_Percentage DESC;


-- Top 10 High-Billing Providers	Providers with highest charges

--IN
SELECT TOP 5
    Provider_Name,
    Provider_City,
    Provider_State,
    SUM(Average_Covered_Charges * Total_Discharges) AS Total_Billed_Amount
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_Name, Provider_City, Provider_State
ORDER BY Total_Billed_Amount DESC;


--OUT
SELECT TOP 5
    Provider_Name,
    Provider_City,
    Provider_State,
    SUM(Average_Estimated_Submitted_Charges * Outpatient_Services) AS Total_Billed_Amount
FROM Provider_Charge_Outpatient_APC
GROUP BY Provider_Name, Provider_City, Provider_State
ORDER BY Total_Billed_Amount DESC;


-- Average Reimbursement Rate	Percentage of billed charges Medicare reimburses

--IN
SELECT 
    DRG_Definition AS Procedure_Type,
    ROUND(
        (SUM(Average_Medicare_Payments) / NULLIF(SUM(Average_Covered_Charges), 0)) * 100, 
        2
    ) AS Average_Reimbursement_Rate_Percentage
FROM Provider_Charge_Inpatient_DRG
GROUP BY DRG_Definition
ORDER BY Average_Reimbursement_Rate_Percentage DESC;

--OUT
SELECT 
    APC AS Procedure_Type,
    ROUND(
        (SUM(Average_Total_Payments) / NULLIF(SUM(Average_Estimated_Submitted_Charges), 0)) * 100, 
        2
    ) AS Average_Reimbursement_Rate_Percentage
FROM Provider_Charge_Outpatient_APC
GROUP BY APC
ORDER BY Average_Reimbursement_Rate_Percentage DESC;



/******************Provider KPIs********************/

-- 	Number of Claims per Provider:	Total claims submitted per provider

-- IN
SELECT 
    Provider_Id,
    Provider_Name,
    COUNT(*) AS Total_Claims_Submitted
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_Id, Provider_Name
ORDER BY Total_Claims_Submitted DESC;

-- OUT
SELECT 
    Provider_Id,
    Provider_Name,
    COUNT(*) AS Total_Claims_Submitted
FROM Provider_Charge_Outpatient_APC
GROUP BY Provider_Id, Provider_Name
ORDER BY Total_Claims_Submitted DESC;


-- 	Top Hospitals by Discharges	

-- IN
SELECT 
    TOP 10 Provider_Id,
    Provider_Name,
    SUM(Total_Discharges) AS Total_Discharges
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_Id, Provider_Name
ORDER BY Total_Discharges DESC;



-- 	Average Payment per Provider:	Mean Medicare payment per provider

-- IN
SELECT 
    Provider_Id,
    Provider_Name,
    ROUND(AVG(Average_Medicare_Payments), 2) AS Avg_Medicare_Payment_Per_Provider
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_Id, Provider_Name
ORDER BY Avg_Medicare_Payment_Per_Provider DESC;

-- OUT
SELECT 
    Provider_Id,
    Provider_Name,
    ROUND(AVG(Average_Total_Payments), 2) AS Avg_Medicare_Payment_Per_Provider
FROM Provider_Charge_Outpatient_APC
GROUP BY Provider_Id, Provider_Name
ORDER BY Avg_Medicare_Payment_Per_Provider DESC;


/******************Regional KPIs********************/

-- 	State-wise Cost Variations	Differences in Medicare costs by state

-- IN
SELECT 
    Provider_State,
    ROUND(AVG(Average_Covered_Charges), 2) AS Avg_Covered_Charge,
    ROUND(AVG(Average_Total_Payments), 2) AS Avg_Total_Payment,
    ROUND(AVG(Average_Medicare_Payments), 2) AS Avg_Medicare_Payment,
    CONCAT(
        ROUND((AVG(Average_Medicare_Payments) / NULLIF(AVG(Average_Covered_Charges), 0)) * 100, 2), '%'
    ) AS Medicare_Reimbursement_Rate
FROM Provider_Charge_Inpatient_DRG
GROUP BY Provider_State
ORDER BY Avg_Covered_Charge DESC;


-- OUT
SELECT 
    Provider_State,
    ROUND(AVG(Average_Estimated_Submitted_Charges), 2) AS Avg_Submitted_Charge,
    ROUND(AVG(Average_Total_Payments), 2) AS Avg_Total_Payment,
    CONCAT(
        ROUND((AVG(Average_Total_Payments) / NULLIF(AVG(Average_Estimated_Submitted_Charges), 0)) * 100, 2), '%'
    ) AS Reimbursement_Rate
FROM Provider_Charge_Outpatient_APC
GROUP BY Provider_State
ORDER BY Avg_Submitted_Charge DESC;


-- 	Regions with Highest Reimbursements	States where Medicare reimburses the most

-- IN
WITH Total_Reimbursements AS (
    SELECT 
        SUM(Average_Medicare_Payments) AS National_Total_Reimbursements
    FROM Provider_Charge_Inpatient_DRG
)
SELECT 
    Provider_State,
    ROUND(SUM(Average_Medicare_Payments), 2) AS Total_Medicare_Reimbursements,
    CONCAT(
        ROUND((SUM(Average_Medicare_Payments) / t.National_Total_Reimbursements) * 100, 2), '%'
    ) AS Percentage_Contribution
FROM Provider_Charge_Inpatient_DRG, Total_Reimbursements t
GROUP BY Provider_State, t.National_Total_Reimbursements
ORDER BY Total_Medicare_Reimbursements DESC;

-- OUT
WITH Total_Reimbursements AS (
    SELECT 
        SUM(Average_Total_Payments) AS National_Total_Reimbursements
    FROM Provider_Charge_Outpatient_APC
)
SELECT 
    Provider_State,
    ROUND(SUM(Average_Total_Payments), 2) AS Total_Medicare_Reimbursements,
    CONCAT(
        ROUND((SUM(Average_Total_Payments) / t.National_Total_Reimbursements) * 100, 2), '%'
    ) AS Percentage_Contribution
FROM Provider_Charge_Outpatient_APC, Total_Reimbursements t
GROUP BY Provider_State, t.National_Total_Reimbursements
ORDER BY Total_Medicare_Reimbursements DESC;


-- 	Top 10 States by Outpatient Claims	Identifying high-cost states for outpatient procedures

-- IN
WITH Total_Claims AS (
    SELECT SUM(Total_Discharges) AS National_Total_Claims
    FROM Provider_Charge_Inpatient_DRG
)
SELECT 
    TOP 10 Provider_State,
    SUM(Total_Discharges) AS Total_Inpatient_Claims,
    CONCAT(
        ROUND((SUM(Total_Discharges) * 100.0 / t.National_Total_Claims), 2), '%'
    ) AS Percentage_of_Total_Claims
FROM Provider_Charge_Inpatient_DRG, Total_Claims t
GROUP BY Provider_State, t.National_Total_Claims
ORDER BY Total_Inpatient_Claims DESC;

-- OUT
WITH Total_Claims AS (
    SELECT SUM(Outpatient_Services) AS National_Total_Claims
    FROM Provider_Charge_Outpatient_APC
)
SELECT 
    TOP 10 Provider_State,
    SUM(Outpatient_Services) AS Total_Outpatient_Claims,
    CONCAT(
        ROUND((SUM(Outpatient_Services) * 100.0 / t.National_Total_Claims), 2), '%'
    ) AS Percentage_of_Total_Claims
FROM Provider_Charge_Outpatient_APC, Total_Claims t
GROUP BY Provider_State, t.National_Total_Claims
ORDER BY Total_Outpatient_Claims DESC;



/******************Patient KPIs********************/

SELECT DISTINCT Age
FROM Patient_history
ORDER BY Age;

SELECT DISTINCT Income
FROM Patient_history
ORDER BY Income;

-- Inpatients vs Outpatients
SELECT 
    ProcedureClassification,
    COUNT(DISTINCT Classified_Transactions.ID) AS Patient_Count
FROM (
    SELECT 
        t.ID,
        t.Global_Proc_ID,
        CASE 
            WHEN t.Global_Proc_ID IN (
                SELECT DISTINCT TRY_CAST(LEFT(DRG_Definition, CHARINDEX(' -', DRG_Definition) - 1) AS INT) 
                FROM Provider_Charge_Inpatient_DRG
            ) THEN 'Inpatient'
            WHEN t.Global_Proc_ID IN (
                SELECT DISTINCT TRY_CAST(LEFT(APC, CHARINDEX(' -', APC) - 1) AS INT) 
                FROM Provider_Charge_Outpatient_APC
            ) THEN 'Outpatient'
            ELSE 'Unknown'
        END AS ProcedureClassification
    FROM Transaction_ t
) AS Classified_Transactions
WHERE ProcedureClassification IN ('Inpatient', 'Outpatient')
GROUP BY ProcedureClassification;






-- 	Patients with Most Claims	Patients with unusually high claims
SELECT TOP 10
    id AS Patient_ID,
    SUM(Count) AS Total_Claims
FROM Transaction_
GROUP BY ID
ORDER BY Total_Claims DESC; -- Top 10 patients

-- 	Average Age of Patients
SELECT 
    ROUND(
        AVG(CAST(
            CASE 
                WHEN Age = '<65' THEN 60
                WHEN Age = '65-74' THEN 69.5
                WHEN Age = '75-84' THEN 79.5
                WHEN Age = '85+' THEN 90
                ELSE NULL
            END AS FLOAT)
        ), 2) AS Average_Age
FROM Patient_history
WHERE Age IS NOT NULL;


-- Age distribution of Medicare recipients
SELECT 
    Age,
    COUNT(*) AS Patient_Count,
    CONCAT(ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()), 2), '%') AS Percentage_Distribution
FROM Patient_history
GROUP BY Age
ORDER BY Patient_Count DESC;


-- 	Income Distribution of Patients	Understanding income levels of Medicare patients
SELECT 
    Income,
    COUNT(*) AS Patient_Count,
    CONCAT(ROUND((COUNT(*) * 100.0 / SUM(COUNT(*)) OVER ()), 2), '%') AS Percentage_Distribution
FROM Patient_history
GROUP BY Income
ORDER BY Patient_Count DESC;

-- Avg INcome
SELECT 
    CONCAT('$', FORMAT(ROUND(
        AVG(CAST(
            CASE 
                WHEN Income = '<16000' THEN 12000
                WHEN Income = '16000-23999' THEN 20000
                WHEN Income = '24000-31999' THEN 28000
                WHEN Income = '32000-47999' THEN 40000
                WHEN Income = '48000+' THEN 55000
                ELSE 0
            END AS FLOAT)
        ), 2), 'N2')) AS Approx_Average_Income
FROM Patient_history
WHERE Income IS NOT NULL;



/******************Transaction KPIs********************/

-- 	Average Number of Procedures per Patient	Mean number of medical procedures per patient
SELECT 
    ROUND(AVG(Total_Procedures), 2) AS Avg_Procedures_Per_Patient
FROM (
    SELECT 
        ID, 
        SUM(Count) AS Total_Procedures
    FROM Transaction_
    GROUP BY ID
) AS Patient_Procedure_Count;

-- 	Top 10 Most Frequent Procedures	Most commonly performed procedures
SELECT 
    Global_Proc_ID AS Procedure_Code,
    SUM(Count) AS Total_Procedures_Performed
FROM Transaction_
GROUP BY Global_Proc_ID
ORDER BY Total_Procedures_Performed DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;



-- 	Patients with Unusual Billing Patterns	Patients with excessive medical transactions

-- Step A: Determine the 95th Percentile Threshold
WITH Patient_Transaction_Summary AS (
    SELECT 
        ID, 
        SUM(Count) AS Total_Procedures
    FROM Transaction_
    GROUP BY ID
)
SELECT 
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY Total_Procedures) 
    OVER () AS NinetyFifth_Percentile_Threshold
FROM Patient_Transaction_Summary;


--  Step B: Identify Patients Above the Threshold
WITH Patient_Transaction_Summary AS (
    SELECT 
        ID, 
        SUM(Count) AS Total_Procedures
    FROM Transaction_
    GROUP BY ID
)
SELECT 
    ID, 
    Total_Procedures
FROM Patient_Transaction_Summary
WHERE Total_Procedures > 6   -- Replace with actual 95th percentile value
ORDER BY Total_Procedures DESC;



/******************************************KRAs**********************************************/





/******************************************KRIs**********************************************/
