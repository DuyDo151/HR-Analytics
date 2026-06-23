-- 1. Attrition by Overtime
SELECT 
    OverTime,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Attrited,
    CAST(ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS DECIMAL(5,2)) AS Attrition_Rate_Pct
FROM employees
GROUP BY OverTime
ORDER BY Attrition_Rate_Pct DESC;

-- 2. Attrition by Business Travel
SELECT 
    BusinessTravel,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Attrited,
    CAST(ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS DECIMAL(5,2)) AS Attrition_Rate_Pct
FROM employees
GROUP BY BusinessTravel
ORDER BY Attrition_Rate_Pct DESC;

-- 3. Attrition by Marital Status
SELECT 
    MaritalStatus,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Attrited,
    CAST(ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS DECIMAL(5,2)) AS Attrition_Rate_Pct
FROM employees
GROUP BY MaritalStatus
ORDER BY Attrition_Rate_Pct DESC;

-- 4. Attrition by Years at Company
SELECT 
    CASE 
        WHEN YearsAtCompany = 0 THEN 'Less than 1 year'
        WHEN YearsAtCompany BETWEEN 1 AND 3 THEN '1-3 years'
        WHEN YearsAtCompany BETWEEN 4 AND 7 THEN '4-7 years'
        WHEN YearsAtCompany BETWEEN 8 AND 15 THEN '8-15 years'
        ELSE '15+ years'
    END AS Tenure_Group,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Attrited,
   CAST(ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS DECIMAL(5,2)) AS Attrition_Rate_Pct
FROM employees
GROUP BY 
    CASE 
        WHEN YearsAtCompany = 0 THEN 'Less than 1 year'
        WHEN YearsAtCompany BETWEEN 1 AND 3 THEN '1-3 years'
        WHEN YearsAtCompany BETWEEN 4 AND 7 THEN '4-7 years'
        WHEN YearsAtCompany BETWEEN 8 AND 15 THEN '8-15 years'
        ELSE '15+ years'
    END
ORDER BY Attrition_Rate_Pct DESC;

-- 5. Attrition by Job Satisfaction
SELECT 
    JobSatisfaction,
    CASE JobSatisfaction
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
    END AS Satisfaction_Label,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Attrited,
    CAST(ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS DECIMAL(5,2)) AS Attrition_Rate_Pct
FROM employees
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- 6. Multi-factor attrition analysis
-- Overtime + Low Salary = highest risk?
SELECT 
    OverTime,
    CASE 
        WHEN MonthlyIncome < 3000 THEN 'Low (<3K)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Mid (3K-6K)'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'Upper-Mid (6K-10K)'
        ELSE 'High (10K+)'
    END AS Salary_Band,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Attrited,
    CAST(ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS DECIMAL(5,2)) AS Attrition_Rate_Pct
FROM employees
GROUP BY OverTime,
    CASE 
        WHEN MonthlyIncome < 3000 THEN 'Low (<3K)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Mid (3K-6K)'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'Upper-Mid (6K-10K)'
        ELSE 'High (10K+)'
    END
ORDER BY Attrition_Rate_Pct DESC;