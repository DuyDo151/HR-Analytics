# HR Analytics — Employee Attrition Analysis

## Project Overview
An end-to-end data analysis project exploring employee attrition patterns at a technology company. Using SQL Server for data analysis and Power BI for interactive visualization, this project identifies key drivers of employee turnover and provides actionable retention recommendations.

**Tools:** SQL Server, SSMS, Power BI Desktop  
**Dataset:** [IBM HR Analytics Employee Attrition — Kaggle](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset)  
**Records:** 1,470 employees · 35 attributes

---

## Dashboard Preview

> *Screenshot — Overview Page*

<img width="1305" height="728" alt="Screenshot 2026-06-10 113359" src="https://github.com/user-attachments/assets/13f7ca2a-86f7-44b2-a20f-5544a8eb671b" />


> *Screenshot — Attrition Analysis Page*

<img width="1285" height="705" alt="Screenshot 2026-06-10 120254" src="https://github.com/user-attachments/assets/8bb05140-0b46-43b7-8ebe-24b070e2335c" />


> *Screenshot — Salary Analysis Page*

<img width="1922" height="1038" alt="Screenshot 2026-06-16 111103" src="https://github.com/user-attachments/assets/d0561c5a-30d2-4f60-98e3-c3dedd165410" />


---

## Business Questions
1. What is the overall attrition rate and which departments are most affected?
2. What factors most strongly predict employee attrition?
3. Is there a relationship between salary and attrition?
4. Which employees are currently at highest risk of leaving?
5. Is there a gender pay gap across departments?

---

## Key Findings

### Attrition Overview
- Overall attrition rate: **16.12%** (237 of 1,470 employees)
- **Sales** is the highest-risk department at **20.63%**
- **Sales Representative** is the highest-risk role at **39.76%**
- **67 critical-risk employees** are still active and need immediate HR attention

### Top Attrition Drivers
| Factor | Attrition Rate |
|---|---|
| Overtime = Yes | 30.53% |
| Overtime + Low Salary | 56.14% |
| Age under 25 | 39.18% |
| Tenure < 1 year | 36.36% |
| Single marital status | 25.53% |
| No stock options | 24.41% |
| Travel frequently | 24.91% |

### Compensation Insights
- Employees who left earned **less** than those who stayed in 5 out of 9 job roles
- **Healthcare Representatives** who left earned **more** than stayers — money is not the issue for this role
- Low salary hike (≤11%) leads to **19.52% attrition** despite higher average salary
- **Female attrition in HR reaches 30%** — highest gender × department combination

### Risk Scoring Model
Built a 6-factor risk scoring model based on: Overtime, Salary Band, Job Satisfaction, Tenure, Business Travel, and Work-Life Balance.

| Risk Level | Employees | Attrition Rate |
|---|---|---|
| Critical (score ≥ 8) | 141 | 52.48% |
| High (score ≥ 5) | 611 | 19.64% |
| Medium (score ≥ 3) | 496 | 6.45% |
| Low (score < 3) | 222 | 4.95% |

The model is **10x more accurate** than random prediction.

---

## Recommendations
1. **Reduce overtime in Sales** — 28.7% overtime rate is driving the highest attrition in the company
2. **Salary adjustment for low-income overtime workers** — 56% attrition rate for this group is unsustainable
3. **Improve onboarding experience** — employees with less than 1 year tenure have 36.36% attrition
4. **Introduce stock options** — moving from Level 0 to Level 1 drops attrition from 24% to 9%
5. **Prioritize retention of 67 critical-risk employees** still active at the company

---

## Repository Structure
```
hr-analytics/
├── README.md
├── screenshots/
│   ├── overview.png
│   ├── attrition.png
│   └── salary.png
├── sql/
│   ├── 01_exploration.sql          -- Dataset overview, attrition by dept/role/age/salary
│   ├── 02_attrition_analysis.sql   -- Deep dive: overtime, travel, tenure, satisfaction
│   ├── 03_salary_analysis.sql      -- Compensation analysis, gender pay gap
│   ├── 04_advanced_analysis.sql    -- Risk scoring model, cohort analysis
│   └── 05_recommendations.sql      -- Executive summary, actionable insights
└── HR_analytics.pbix               -- Power BI dashboard (3 pages)
```

---

## Power BI Dashboard
The dashboard consists of 3 interactive pages with Department slicer on each page:

**Page 1 — Overview**
KPI cards, attrition by department, age group, and job role

**Page 2 — Attrition Analysis**
Deep dive into attrition drivers: marital status, business travel, overtime, tenure, salary band, and age vs income scatter chart

**Page 3 — Salary Analysis**
Salary by job role, gender pay gap by department, attrition salary gap, and employee distribution by salary band

---

## How to Run SQL Analysis
1. Create database: `CREATE DATABASE HRAnalyticsDB`
2. Import `WA_Fn-UseC_-HR-Employee-Attrition.csv` via SSMS Import Flat File wizard
3. Run SQL files in order: `01` → `02` → `03` → `04` → `05`

## How to View Dashboard
Open `HR_analytics.pbix` in Power BI Desktop (free download at powerbi.microsoft.com)
