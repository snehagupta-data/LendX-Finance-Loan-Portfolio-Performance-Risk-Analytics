# 🏦 LendX Finance — Loan Portfolio Performance & Risk Analytics

> **A full-stack Business Intelligence project** built with **PostgreSQL** + **Power BI**, analyzing loan performance, customer risk, branch efficiency, and revenue profitability across a multi-segment lending company.

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Business Problem](#-business-problem)
- [Data Architecture](#-data-architecture)
- [Database Schema](#-database-schema)
- [SQL Analytics](#-sql-analytics)
- [Power BI Dashboard](#-power-bi-dashboard)
- [Key Insights](#-key-insights)
- [Tech Stack](#-tech-stack)
- [How to Run](#-how-to-run)
- [Project Structure](#-project-structure)
- [Author](#-author)

---

## 📖 Project Overview

**LendX Finance** is a fictional multi-segment lending company offering Personal, Home, Auto, Business, and BNPL loans across 20 branches in India. This end-to-end analytics project:

- Designs a **production-ready PostgreSQL relational database** from scratch
- Writes **25+ SQL queries** covering KPIs, risk analysis, profitability, and advanced window functions
- Builds a **7 main pages + 2 drill-through pages Power BI dashboard**, slicers, and DAX measures

| Metric | Value |
|---|---|
| Total Revenue | ₹386.68M |
| Total Loan Book | ₹7.11 Billion |
| Total Loans | 4,000 |
| Total Customers | 981 |
| Active Branches | 20 |
| Overall Default Rate | 9.2% |
| On-Time Payment Rate | 76.31% |

---

## 📊 Business Story

The portfolio shows a clear imbalance — **Home Loans are stable**, but **BNPL and Personal Loans are driving high defaults**.

The company is heavily exposed to **low credit score customers (avg: 512)**, leading to poor portfolio quality and financial losses.

This analysis focuses on identifying **risk concentration and profitability gaps**.

---

## ❗ Business Problem

| Problem | Impact |
|---|---|
| Rising default rates | Directly erodes profitability |
| Delayed repayments | Disrupts cash flow planning |
| Risk varies by loan type & segment | No unified risk view |

**Objective:** Analyze loan performance, identify high-risk customer segments, and enable data-driven decisions to reduce financial risk and improve portfolio health.

---

## 🗄️ Data Architecture

The project follows a **Star Schema** design with 2 fact tables and 4 dimension tables:

![Data Model](Data%20Model/DATA%20MODEL.png)

```
                    ┌──────────────┐
                    │  Loan_Type   │
                    │  (Dimension) │
                    └──────┬───────┘
                           │
┌──────────────┐    ┌──────┴───────┐    ┌──────────────┐
│  Customers   │────│    Loans     │────│   Branch     │
│  (Dimension) │    │   (Fact)     │    │  (Dimension) │
└──────────────┘    └──────┬───────┘    └──────────────┘
                           │
                    ┌──────┴───────┐    ┌──────────────┐
                    │  Repayments  │    │   Calendar   │
                    │   (Fact)     │    │  (Dimension) │
                    └─────────────-┘    └──────────────┘
```

---

## 🧱 Database Schema

### `branches` — Geographic dimension
| Column | Type | Description |
|---|---|---|
| `branch_id` | VARCHAR(10) PK | Unique branch identifier |
| `branch_name` | VARCHAR(100) | Branch name |
| `city` | VARCHAR(50) | City |
| `state` | VARCHAR(50) | State |
| `region` | VARCHAR(20) | North / South / East / West |

### `loan_types` — Product dimension
| Column | Type | Description |
|---|---|---|
| `loan_type_id` | VARCHAR(10) PK | Unique type ID |
| `loan_type_name` | VARCHAR(50) | Personal / Home / Auto / Business / BNPL |
| `risk_level` | VARCHAR(10) | Low / Medium / High |

### `customers` — Customer dimension
| Column | Type | Description |
|---|---|---|
| `customer_id` | VARCHAR(10) PK | Unique customer ID |
| `customer_name` | VARCHAR(100) | Full name |
| `age` | SMALLINT | Age (18–100) |
| `gender` | VARCHAR(10) | Male / Female / Other |
| `city`, `state` | VARCHAR | Location |
| `employment_type` | VARCHAR(20) | Salaried / Self-Employed / Business |
| `salary` | NUMERIC(12,2) | Annual salary |
| `credit_score` | SMALLINT | 300–900 range |
| `customer_since` | DATE | Onboarding date |

### `loans` — Loan fact table
| Column | Type | Description |
|---|---|---|
| `loan_id` | VARCHAR(10) PK | Unique loan ID |
| `customer_id` | FK → customers | Borrower |
| `branch_id` | FK → branches | Issuing branch |
| `loan_type_id` | FK → loan_types | Product type |
| `loan_amount` | NUMERIC(14,2) | Disbursed amount |
| `interest_rate` | NUMERIC(5,2) | Annual interest % |
| `loan_date` | DATE | Disbursement date |
| `tenure_months` | SMALLINT | Repayment tenure |

### `repayments` — Payment fact table
| Column | Type | Description |
|---|---|---|
| `payment_id` | VARCHAR(10) PK | Unique payment ID |
| `loan_id` | FK → loans | Associated loan |
| `due_date` | DATE | Scheduled date |
| `payment_date` | DATE | Actual payment date |
| `payment_amount` | NUMERIC(12,2) | Amount paid |
| `payment_status` | VARCHAR(10) | On-time / Late / Default |
| `penalty_amount` | NUMERIC(10,2) | Penalty charged |
| `default_flag` *(computed)* | INT | 1 if Default, else 0 |
| `delay_days` *(computed)* | INT | payment_date − due_date |

---

## 🔍 SQL Analytics

The SQL file contains **30 queries** organized into 7 analytical sections:

### Section 1 — KPI Framework
Core business metrics including total portfolio value, default rate, NPA%, delinquency rate, portfolio yield, collection efficiency, and average credit score.

### Section 2 — Portfolio Overview
Answers questions like: What is the total loan book size? Which loan types dominate? Which regions contribute the most?

### Section 3 — Growth & Distribution
Monthly disbursement trends, branch-wise business volumes, loan tenure distribution, and high-lending city zones.

### Section 4 — Customer Quality Analysis
Income band vs loan size correlation, credit score distribution, employment type borrowing patterns, new vs old customer risk comparison, and gender-based behavior.

### Section 5 — Risk & Default Analysis
Overall default rate, default by loan type, credit score as default predictor, region-wise default rates, and loan size vs risk relationship.

### Section 6 — Profitability & Efficiency
Revenue by loan type, profit vs risk tradeoff analysis, regional revenue contribution, and late payment rate.

### Section 7 — Advanced Analytics (Window Functions)
- Customer revenue ranking with `DENSE_RANK()`
- Branch performance vs portfolio average using `AVG() OVER()`
- Cumulative portfolio growth using `SUM() OVER()`
- Early warning system for increasing payment delays using `LAG()`
- Top loan per region using `ROW_NUMBER() OVER(PARTITION BY ...)`

---

## 📊 Power BI Dashboard

The `.pbix` file contains **7 interactive report pages**:

### 🏠 Home
Landing page with project context, business problem statement, and navigation to all report pages.

![Home](Dashboard%20Image/LENDX%20FINANCE.png)

### 📋 Executive Overview

![Executive Overview](Dashboard%20Image/EXECUTIVE%20OVERVIEW.png)

### 📈 Growth & Time Analysis

![Growth & Time Analysis](Dashboard%20Image/GROWTH%20%26%20TIME%20ANALYSIS.png)

### 👥 Customer Insights

![Customer Insights](Dashboard%20Image/CUSTOMER%20INSIGHTS.png)

![Customer Insights Detail](Dashboard%20Image/CUSTOMER%20INSIGHTS%20-%20DETAIL%20VIEW.png)

### 💼 Loan Portfolio Analysis

![Loan Portfolio Analysis](Dashboard%20Image/LOAN%20PORTFOLIO%20ANALYSIS.png)

![Loan Portfolio Detail](Dashboard%20Image/LOAN%20PORTFOLIO%20ANALYSIS%20-%20DETAIL%20VIEW.png)

### ⚠️ Risk & Default Analysis

![Risk & Default Analysis](Dashboard%20Image/RISK%20%26%20DEFAULT%20ANALYSIS.png)

### 🏢 Branch Performance

![Branch Performance](Dashboard%20Image/BRANCH%20PERFORMANCE.png)

### 💡 Insights

![Insights](Dashboard%20Image/INSIGHTS.png)

---

## 🎯 Dashboard Features

- Drill-through analysis for customer and loan-level insights
- Interactive filtering by loan type, region, and time
- KPI cards with dynamic measures
- Risk segmentation using credit score and income
- Button-based navigation for clean UX

---

## 🔑 Key Insights

| # | Insight | Category |
|---|---|---|
| 1 | Portfolio is **loss-making** — ₹75.6Cr interest income offset by credit losses → net loss of ₹204Cr | 🔴 Critical |
| 2 | **BNPL** has 20.5% default rate on ₹31.3M book — unsustainable risk levels | 🔴 Critical |
| 3 | Average credit score is **512** with DTI of **2.12** — subprime, over-leveraged customer base | 🔴 Critical |
| 4 | **Home Loans** lead with ₹4.5bn (63%), 4.9% default — largest, safest, most profitable segment | 🟢 Positive |
| 5 | **Maharashtra** leads all states: 618 loans, ₹1.03bn book, ₹55.5M revenue, 8.8% default | 🟢 Positive |
| 6 | **Chennai Anna Nagar** is benchmark branch: 243 loans, ₹2.27Cr revenue, 9.4% default | 🟢 Positive |
| 7 | **Personal Loans** dominate by volume (1,241 loans) but carry 11.2% default — largest risk contributor | 🟡 Watch |
| 8 | **East region** lags: 807 loans, ₹1.4bn book, 9.8% default — weakest risk-return profile | 🟡 Watch |
| 9 | **Premium segment** (52 customers, 5.3%) has 734 avg score and 7.0% default — underutilized growth opportunity | 🟡 Watch |
| 10 | December default rate spikes to **12.3%** — seasonal risk pattern requiring proactive action | 🟡 Watch |

---

## 🚀 Business Recommendations

- Reduce exposure to **BNPL segment** or tighten approvals  
- Focus growth on **Home Loans (low risk, stable returns)**  
- Apply **minimum credit score threshold (≥650)**  
- Expand **premium customer segment**  
- Build **early warning system** for delayed payments  
- Strengthen collections in high-risk regions  

---

## 📐 Key DAX Measures

- Default Rate %
- Total Revenue
- On-Time Payment %
- Total Loan Book

---

## 🛠️ Tech Stack

| Tool | Purpose |
|---|---|
| **PostgreSQL** | Database design, DDL, and all SQL analytics |
| **Power BI Desktop** | Data modeling, DAX measures, and interactive dashboards |
| **DAX** | Custom KPIs, calculated columns, time intelligence |
| **Power Query (M)** | Data transformation and cleaning |


---

## 📁 Project Structure

```
lendx-finance-analytics/
│
├── 📄 README.md                          # This file
├── 🗃️ sql_all_Querries.txt               # Full PostgreSQL DDL + 30 analytical queries
├── 📊 LendX_Finance___Loan_Portfolio_Performance___Risk_Analytics.pbix
│
└── 📸 screenshots/
    ├── LENDX_FINANCE.png                 # Home page
    ├── EXECUTIVE_OVERVIEW.png            # Executive summary dashboard
    ├── GROWTH___TIME_ANALYSIS.png        # Time series analysis
    ├── CUSTOMER_INSIGHTS.png             # Customer segmentation
    ├── CUSTOMER_INSIGHTS_-_DETAIL_VIEW.png
    ├── LOAN_PORTFOLIO_ANALYSIS.png       # Loan portfolio breakdown
    ├── LOAN_PORTFOLIO_ANALYSIS_-_DETAIL_VIEW.png
    ├── RISK_DEFAULT_ANALYSIS.png         # Risk & default analysis
    ├── BRANCH_PERFORMANCE.png            # Branch-level KPIs
    ├── INSIGHTS.png                      # Auto-generated insights page
    └── DATA_MODEL.png                    # Power BI data model
```

---

## 👤 Author

**Built by:** Sneha Gupta
**Tools:** PostgreSQL · Power BI · DAX · SQL  
**Domain:** Financial Analytics · Lending · Risk Management

---

> ⭐ If you found this project useful, please consider starring the repository!

---

*This is a synthetic dataset created for analytical and portfolio demonstration purposes only.*
