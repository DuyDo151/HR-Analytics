-- 1. Overall attrition rate
SELECT 
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Total_Attrition,
    ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM employees;

-- 2. Attrition by Department
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(Cast(Attrition AS INT)) AS Attrited,
    ROUND(SUM(Cast(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM employees
GROUP BY Department
ORDER BY Attrition_Rate_Pct DESC;

-- 3. Attrition by Job Role
SELECT 
    JobRole,
    Department,
    COUNT(*) AS Total_Employees,
    SUM(Cast(Attrition AS INT)) AS Attrited,
    ROUND(SUM(Cast(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM employees
GROUP BY JobRole, Department
ORDER BY Attrition_Rate_Pct DESC;

-- 4. Age distribution
SELECT 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS Age_Group,
    COUNT(*) AS Total_Employees,
    SUM(Cast(Attrition AS INT)) AS Attrited,
    ROUND(SUM(Cast(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct
FROM employees
GROUP BY 
    CASE 
        WHEN Age < 25 THEN 'Under 25'
        WHEN Age BETWEEN 25 AND 34 THEN '25-34'
        WHEN Age BETWEEN 35 AND 44 THEN '35-44'
        WHEN Age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END
ORDER BY Attrition_Rate_Pct DESC;

-- 5. Salary distribution
SELECT 
    CASE 
        WHEN MonthlyIncome < 3000 THEN 'Low (<3K)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Mid (3K-6K)'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'Upper-Mid (6K-10K)'
        ELSE 'High (10K+)'
    END AS Salary_Band,
    COUNT(*) AS Total_Employees,
    SUM(Cast(Attrition AS INT)) AS Attrited,
    ROUND(SUM(Cast(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 2) AS Avg_Salary
FROM employees
GROUP BY 
    CASE 
        WHEN MonthlyIncome < 3000 THEN 'Low (<3K)'
        WHEN MonthlyIncome BETWEEN 3000 AND 6000 THEN 'Mid (3K-6K)'
        WHEN MonthlyIncome BETWEEN 6001 AND 10000 THEN 'Upper-Mid (6K-10K)'
        ELSE 'High (10K+)'
    END
ORDER BY Attrition_Rate_Pct DESC;