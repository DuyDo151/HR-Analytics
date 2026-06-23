# HR Analytics — Employee Attrition Analysis

## Overview
SQL-based analysis of 1,470 employee records to identify 
attrition drivers and at-risk employees for proactive 
HR intervention.

**Tools:** SQL Server, SSMS  
**Dataset:** IBM HR Analytics — Kaggle  
**Records:** 1,470 employees, 35 attributes

---

## Business Questions
1. What is the overall attrition rate and which 
   departments are most affected?
2. What factors most strongly predict attrition?
3. Which employees are currently at highest risk 
   of leaving?
4. Is there a gender pay gap across departments?
5. How does compensation relate to attrition?

---

## Key Findings

### Attrition Overview
- Overall attrition rate: **16.12%** (237 of 1,470)
- **Sales** is highest risk department: 20.63%
- **Sales Representative** is highest risk role: 39.76%
- **67 critical-risk employees** are still active 
  and need immediate HR attention

### Top Attrition Drivers
- **Overtime:** employees working OT have 30.53% 
  attrition vs 10.44% for non-OT
- **Overtime + Low Salary:** combination reaches 
  56.14% attrition — highest in dataset
- **Age under 25:** 39.18% attrition rate
- **Single marital status:** 25.53% vs 12.48% married
- **No stock options:** 24.41% vs 9.40% with Level 1

### Compensation Insights
- Employees who left earned **less** than those who 
  stayed in 5 out of 9 job roles
- **Healthcare Representatives** who left earned 
  **more** than stayers — money not the issue here
- Low salary hike (≤11%) leads to 19.52% attrition 
  despite higher average salary
- Female attrition in HR reaches **30%** — 
  highest gender×department combination

### Risk Model
Built a 6-factor risk scoring model:
- Overtime, Salary Band, Job Satisfaction, 
  Tenure, Business Travel, Work-Life Balance
- **Critical risk (score ≥8):** 52.48% actual attrition
- **Low risk (score <3):** 4.95% actual attrition
- Model is **10x more accurate** than random guessing

---

## Recommendations
1. **Reduce overtime in Sales** — 28.7% OT rate 
   driving highest attrition
2. **Salary adjustment for low-income OT workers** — 
   56% attrition rate is unsustainable
3. **Improve onboarding** — Less than 1 year tenure 
   has 36.36% attrition
4. **Introduce stock options** — Level 0 → Level 1 
   drops attrition from 24% to 9%
5. **Focus retention on 67 critical-risk employees** 
   still active at company

---

## Files
| File | Description |
|---|---|
| `01_exploration.sql` | Dataset overview, attrition by dept/role/age/salary |
| `02_attrition_analysis.sql` | Deep dive: overtime, travel, tenure, satisfaction |
| `03_salary_analysis.sql` | Compensation analysis, gender pay gap |
| `04_advanced_analysis.sql` | Risk scoring model, cohort analysis |
| `05_recommendations.sql` | Executive summary, actionable insights |

---

## How to Run
1. Create database: `CREATE DATABASE HRAnalyticsDB`
2. Import `WA_Fn-UseC_-HR-Employee-Attrition.csv` 
   via SSMS Import Flat File
3. Run SQL files in order (01 → 05)
