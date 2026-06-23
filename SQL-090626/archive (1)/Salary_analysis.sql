-- 1. Average salary by Job Role
SELECT 
    JobRole,
    Department,
    COUNT(*) AS Total_Employees,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 2) AS Avg_Salary,
    MIN(MonthlyIncome) AS Min_Salary,
    MAX(MonthlyIncome) AS Max_Salary,
    MAX(MonthlyIncome) - MIN(MonthlyIncome) AS Salary_Range
FROM employees
GROUP BY JobRole, Department
ORDER BY Avg_Salary DESC;

-- 2. Salary vs Attrition by Job Role
SELECT 
    JobRole,
    ROUND(AVG(CASE WHEN Attrition = 1 
              THEN CAST(MonthlyIncome AS FLOAT) END), 2) AS Avg_Salary_Attrited,
    ROUND(AVG(CASE WHEN Attrition = 0 
              THEN CAST(MonthlyIncome AS FLOAT) END), 2) AS Avg_Salary_Stayed,
    ROUND(AVG(CASE WHEN Attrition = 1 
              THEN CAST(MonthlyIncome AS FLOAT) END) - 
          AVG(CASE WHEN Attrition = 0 
              THEN CAST(MonthlyIncome AS FLOAT) END), 2) AS Salary_Gap
FROM employees
GROUP BY JobRole
ORDER BY Salary_Gap ASC;

-- 3. Salary hike vs Attrition
SELECT 
    CASE 
        WHEN PercentSalaryHike <= 11 THEN 'Low (<=11%)'
        WHEN PercentSalaryHike BETWEEN 12 AND 15 THEN 'Medium (12-15%)'
        ELSE 'High (>15%)'
    END AS Hike_Band,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Attrited,
    ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 2) AS Avg_Salary
FROM employees
GROUP BY 
    CASE 
        WHEN PercentSalaryHike <= 11 THEN 'Low (<=11%)'
        WHEN PercentSalaryHike BETWEEN 12 AND 15 THEN 'Medium (12-15%)'
        ELSE 'High (>15%)'
    END
ORDER BY Attrition_Rate_Pct DESC;

-- 4. Stock option impact on attrition
SELECT 
    StockOptionLevel,
    COUNT(*) AS Total_Employees,
    SUM(CAST(Attrition AS INT)) AS Attrited,
    ROUND(SUM(CAST(Attrition AS INT)) * 100.0 / COUNT(*), 2) AS Attrition_Rate_Pct,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 2) AS Avg_Salary
FROM employees
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel;

-- 5. Gender pay gap analysis
SELECT 
    Department,
    Gender,
    COUNT(*) AS Total_Employees,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 2) AS Avg_Salary,
    ROUND(MIN(MonthlyIncome), 2) AS Min_Salary,
    ROUND(MAX(MonthlyIncome), 2) AS Max_Salary
FROM employees
GROUP BY Department, Gender
ORDER BY Department, Gender;