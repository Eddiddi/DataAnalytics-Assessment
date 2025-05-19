
# Data Analyst Assessment
This project consists of four solutions using SQL to solve the data analyst assessment questions as well as the approach to tackling the problems and challenges.


## Question 1: High-Value Customers with Multiple Products

**Scenario**: The business wants to identify customers who have both a savings and an
investment plan (cross-selling opportunity).
**Task** : Write a query to find customers with at least one funded savings plan AND one
funded investment plan, sorted by total deposits.

**Approach**:
- Joined `users_customuser`, `savings_savingsaccount`, and `plans_plan`.
- Filtered for customers who had at least one **funded savings account** and one **funded investment plan**.
- Aggregated the total confirmed deposits and sorted the results by total deposits.


**Challenges**:
- Ensuring accurate classification between investment vs. regular savings required understanding `is_a_fund` and `is_regular_savings` flags.
- The need to convert `confirmed_amount` from Kobo to Naira by dividing by 100.

---

## Question 2: Transaction Frequency Analysis

**Scenario**: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
**Task**: Calculate the average number of transactions per customer per month and
categorize them:
● "High Frequency" (≥10 transactions/month)
● "Medium Frequency" (3-9 transactions/month)
● "Low Frequency" (≤2 transactions/month)

**Approach**:
1. Counted number of transactions per customer per month.
2. Computed the average monthly transaction volume per customer.
3. Categorized customers into:
   - **High Frequency**: ≥10 transactions/month
   - **Medium Frequency**: 3–9 transactions/month
   - **Low Frequency**: ≤2 transactions/month
4. Aggregated results to show category-wise customer count and average transaction volume.

**Challenges**:
- Grouping by `YYYY-MM` format required use of `DATE_FORMAT`.
- Needed to ensure correct handling of average calculations with decimals — solved by rounding.


## Question 3: Account Inactivity Alert

**Scenario**: The ops team wants to flag accounts with no inflow transactions for over one
year.
**Task**: Find all active accounts (savings or investments) with no transactions in the last 1
year (365 days).

**Approach**:
- Merged savings and investment accounts.
- Retrieved the **last transaction date** per plan.
- Calculated the **inactivity duration** in days using `DATEDIFF`.
- Filtered for accounts where the last transaction occurred more than **365 days ago**.

**Challenges**:
- Some investment plans might not have any transaction records; handled using `LEFT JOIN`.
- Ensured only non-deleted plans were considered by filtering on `is_deleted`.


## Question 4: Customer Lifetime Value (CLV) Estimation

**Scenario**: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).

**Approach**:
- Calculated each customer's **tenure** (in months) from `date_joined`.
- Counted **total transactions** and calculated **average transaction value**.
- Applied the CLV formula and sorted the results by highest estimated value.

**Challenges**:
- Ensured that new users (with 0-month tenure) were excluded to avoid division by zero.
- Used `NULLIF` to gracefully avoid divide-by-zero errors.
- Rounded results to 2 decimal places for better readability.

Prepared by:
Edidiong Uko
Email: uko2edidiong@gmail.com
LinkedIn: [Edidiong Uko](https://www.linkedin.com/in/edidiong-uko-18659a244/)
