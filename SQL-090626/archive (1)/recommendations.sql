-- 1. High risk employees still at company
-- These are the ones to focus retention efforts on
WITH Risk_Score AS (
    SELECT 
        EmployeeNumber,
        JobRole,
        Department,
        MonthlyIncome,
        YearsAtCompany,
        JobSatisfaction,
        OverTime,
        Attrition,
        CASE WHEN OverTime = 1 THEN 2 ELSE 0 END +
        CASE WHEN MonthlyIncome < 3000 THEN 2 
             WHEN MonthlyIncome < 6000 THEN 1 ELSE 0 END +
        CASE WHEN JobSatisfaction <= 2 THEN 2 
             WHEN JobSatisfaction = 3 THEN 1 ELSE 0 END +
        CASE WHEN YearsAtCompany <= 1 THEN 2 
             WHEN YearsAtCompany <= 3 THEN 1 ELSE 0 END +
        CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 2 
             WHEN BusinessTravel = 'Travel_Rarely' THEN 1 ELSE 0 END +
        CASE WHEN WorkLifeBalance <= 2 THEN 2 ELSE 0 END AS Risk_Score
    FROM employees
)
SELECT 
    EmployeeNumber,
    JobRole,
    Department,
    MonthlyIncome,
    YearsAtCompany,
    Risk_Score,
    CASE 
        WHEN Risk_Score >= 8 THEN 'Critical'
        WHEN Risk_Score >= 5 THEN 'High'
        ELSE 'Medium'
    END AS Risk_Level
FROM Risk_Score
WHERE Attrition = 0
  AND Risk_Score >= 8
ORDER BY Risk_Score DESC, MonthlyIncome ASC;

-- 2. Department summary dashboard
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Total_Attrited,
    ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 2) AS Avg_Salary,
    ROUND(AVG(CAST(YearsAtCompany AS FLOAT)), 1) AS Avg_Tenure,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS Avg_Job_Satisfaction,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS Avg_WLB_Score,
    SUM(CASE WHEN OverTime = 1 THEN 1 ELSE 0 END) AS Overtime_Employees,
    ROUND(SUM(CASE WHEN OverTime = 1 THEN 1 ELSE 0 END) * 100.0 
          / COUNT(*), 2) AS Overtime_Rate_Pct
FROM employees
GROUP BY Department
ORDER BY Attrition_Rate_Pct DESC;

-- 3. Identify quick wins for retention
-- Employees: High Risk + Currently at company + Low salary
-- Easy fix: salary adjustment
SELECT 
    EmployeeNumber,
    JobRole,
    Department,
    MonthlyIncome,
    PercentSalaryHike,
    YearsAtCompany,
    PerformanceRating,
    JobSatisfaction,
    OverTime
FROM employees
WHERE Attrition = 0
  AND MonthlyIncome < 3000
  AND OverTime = 1
  AND JobSatisfaction <= 2
ORDER BY MonthlyIncome ASC;

-- 4. PIVOT — Attrition by Department and Gender
SELECT 
    Department,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Total_Male,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Total_Female,
    SUM(CASE WHEN Gender = 'Male' 
             AND Attrition = 1 THEN 1 ELSE 0 END) AS Attrited_Male,
    SUM(CASE WHEN Gender = 'Female' 
             AND Attrition = 1 THEN 1 ELSE 0 END) AS Attrited_Female,
    ROUND(SUM(CASE WHEN Gender = 'Male' 
                   AND Attrition = 1 THEN 1 ELSE 0 END) * 100.0 
          / NULLIF(SUM(CASE WHEN Gender = 'Male' 
                            THEN 1 ELSE 0 END), 0), 2) AS Male_Attrition_Rate,
    ROUND(SUM(CASE WHEN Gender = 'Female' 
                   AND Attrition = 1 THEN 1 ELSE 0 END) * 100.0 
          / NULLIF(SUM(CASE WHEN Gender = 'Female' 
                            THEN 1 ELSE 0 END), 0), 2) AS Female_Attrition_Rate
FROM employees
GROUP BY Department
ORDER BY Department;

-- 5. Final executive summary
SELECT 
    'Total Employees' AS Metric, 
    CAST(COUNT(*) AS VARCHAR) AS Value 
FROM employees
UNION ALL
SELECT 
    'Overall Attrition Rate', 
    CAST(ROUND(SUM(CAST(Attrition AS INT)) * 100.0 
         / COUNT(*), 2) AS VARCHAR) + '%'
FROM employees
UNION ALL
SELECT 
    'Highest Risk Department', 
    Department
FROM (
    SELECT TOP 1 Department,
        SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*) AS Rate
    FROM employees
    GROUP BY Department
    ORDER BY Rate DESC
) AS T
UNION ALL
SELECT 
    'Most At-Risk Job Role',
    JobRole
FROM (
    SELECT TOP 1 JobRole,
        SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*) AS Rate
    FROM employees
    GROUP BY JobRole
    ORDER BY Rate DESC
) AS T
UNION ALL
SELECT 
    'Critical Risk Employees Still Active',
    CAST(COUNT(*) AS VARCHAR)
FROM (
    SELECT EmployeeNumber,
        CASE WHEN OverTime = 1 THEN 2 ELSE 0 END +
        CASE WHEN MonthlyIncome < 3000 THEN 2 
             WHEN MonthlyIncome < 6000 THEN 1 ELSE 0 END +
        CASE WHEN JobSatisfaction <= 2 THEN 2 
             WHEN JobSatisfaction = 3 THEN 1 ELSE 0 END +
        CASE WHEN YearsAtCompany <= 1 THEN 2 
             WHEN YearsAtCompany <= 3 THEN 1 ELSE 0 END +
        CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 2 
             WHEN BusinessTravel = 'Travel_Rarely' THEN 1 ELSE 0 END +
        CASE WHEN WorkLifeBalance <= 2 THEN 2 ELSE 0 END AS Risk_Score
    FROM employees
    WHERE Attrition = 0
) AS R
WHERE Risk_Score >= 8;