-- 1. Salary percentile by Department
SELECT 
    EmployeeNumber,
    Department,
    JobRole,
    MonthlyIncome,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP 
        (ORDER BY MonthlyIncome) 
        OVER (PARTITION BY Department), 2) AS Q1_Salary,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP 
        (ORDER BY MonthlyIncome) 
        OVER (PARTITION BY Department), 2) AS Median_Salary,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP 
        (ORDER BY MonthlyIncome) 
        OVER (PARTITION BY Department), 2) AS Q3_Salary,
    NTILE(4) OVER (PARTITION BY Department 
        ORDER BY MonthlyIncome) AS Salary_Quartile
FROM employees
ORDER BY Department, MonthlyIncome DESC;

-- 2. Attrition risk score per employee
-- Higher score = higher risk
WITH Risk_Factors AS (
    SELECT 
        EmployeeNumber,
        JobRole,
        Department,
        MonthlyIncome,
        Attrition,
        CASE WHEN OverTime = 1 THEN 2 ELSE 0 END AS Overtime_Risk,
        CASE WHEN MonthlyIncome < 3000 THEN 2 
             WHEN MonthlyIncome < 6000 THEN 1 
             ELSE 0 END AS Salary_Risk,
        CASE WHEN JobSatisfaction <= 2 THEN 2 
             WHEN JobSatisfaction = 3 THEN 1 
             ELSE 0 END AS Satisfaction_Risk,
        CASE WHEN YearsAtCompany <= 1 THEN 2 
             WHEN YearsAtCompany <= 3 THEN 1 
             ELSE 0 END AS Tenure_Risk,
        CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 2 
             WHEN BusinessTravel = 'Travel_Rarely' THEN 1 
             ELSE 0 END AS Travel_Risk,
        CASE WHEN WorkLifeBalance <= 2 THEN 2 
             ELSE 0 END AS WLB_Risk
    FROM employees
)
SELECT 
    EmployeeNumber,
    JobRole,
    Department,
    MonthlyIncome,
    Attrition,
    Overtime_Risk + Salary_Risk + Satisfaction_Risk + 
    Tenure_Risk + Travel_Risk + WLB_Risk AS Risk_Score,
    CASE 
        WHEN Overtime_Risk + Salary_Risk + Satisfaction_Risk + 
             Tenure_Risk + Travel_Risk + WLB_Risk >= 8 THEN 'Critical'
        WHEN Overtime_Risk + Salary_Risk + Satisfaction_Risk + 
             Tenure_Risk + Travel_Risk + WLB_Risk >= 5 THEN 'High'
        WHEN Overtime_Risk + Salary_Risk + Satisfaction_Risk + 
             Tenure_Risk + Travel_Risk + WLB_Risk >= 3 THEN 'Medium'
        ELSE 'Low'
    END AS Risk_Level
FROM Risk_Factors
ORDER BY Risk_Score DESC;

-- 3. Verify risk score accuracy
-- Do high risk employees actually have higher attrition?
WITH Risk_Factors AS (
    SELECT 
        EmployeeNumber,
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
),
Risk_Levels AS (
    SELECT *,
        CASE 
            WHEN Risk_Score >= 8 THEN 'Critical'
            WHEN Risk_Score >= 5 THEN 'High'
            WHEN Risk_Score >= 3 THEN 'Medium'
            ELSE 'Low'
        END AS Risk_Level
    FROM Risk_Factors
)
SELECT 
    Risk_Level,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Attrited,
    ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM Risk_Levels
GROUP BY Risk_Level
ORDER BY 
    CASE Risk_Level 
        WHEN 'Critical' THEN 1 
        WHEN 'High' THEN 2 
        WHEN 'Medium' THEN 3 
        ELSE 4 
    END;

-- 4. Department cohort analysis
-- Average tenure and salary by department and job level
SELECT 
    Department,
    JobLevel,
    COUNT(*) AS Total_Employees,
    ROUND(AVG(CAST(YearsAtCompany AS FLOAT)), 1) AS Avg_Tenure,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 2) AS Avg_Salary,
    ROUND(AVG(CAST(YearsSinceLastPromotion AS FLOAT)), 1) AS Avg_Years_Since_Promotion,
    SUM(CAST(Attrition AS INT)) AS Attrited,
    ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM employees
GROUP BY Department, JobLevel
ORDER BY Department, JobLevel;

-- 5. Employees with promotion overdue
-- High performer but not promoted in 3+ years
SELECT 
    EmployeeNumber,
    JobRole,
    Department,
    MonthlyIncome,
    PerformanceRating,
    YearsSinceLastPromotion,
    YearsAtCompany,
    Attrition,
    CASE 
        WHEN YearsSinceLastPromotion >= 3 
             AND PerformanceRating >= 3 THEN 'Promotion Overdue'
        ELSE 'Normal'
    END AS Promotion_Status
FROM employees
WHERE YearsSinceLastPromotion >= 3 
  AND PerformanceRating >= 3
ORDER BY YearsSinceLastPromotion DESC, MonthlyIncome DESC;