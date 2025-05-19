-- Step 1: Calculate the number of transactions per user per month
WITH monthly_transactions AS (
    SELECT 
        u.id AS customer_id,  -- Get user ID as customer_id
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS month,  -- Extract year and month from transaction_date
        COUNT(*) AS transaction_count  -- Count number of transactions per customer per month
    FROM 
        users_customuser u
    JOIN 
        savings_savingsaccount s ON u.id = s.owner_id  -- Join users with their savings accounts
    GROUP BY 
        u.id, DATE_FORMAT(s.transaction_date, '%Y-%m')  -- Group by customer and month
),

-- Step 2: Calculate the average number of monthly transactions for each customer
customer_avg AS (
    SELECT 
        customer_id,  -- Use customer_id from previous step
        AVG(transaction_count) AS avg_monthly_transactions  -- Compute average transactions per month
    FROM 
        monthly_transactions
    GROUP BY 
        customer_id  -- Group by each customer
),

-- Step 3: Categorize customers based on their average transaction frequency
categorized_customers AS (
    SELECT 
        customer_id,
        avg_monthly_transactions,
        CASE 
            WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'  -- 10 or more transactions/month
            WHEN avg_monthly_transactions >= 3 THEN 'Medium Frequency'  -- Between 3 and 9
            ELSE 'Low Frequency'  -- Less than 3
        END AS frequency_category  -- Assign category based on avg_monthly_transactions
    FROM 
        customer_avg
)

-- Step 4: Summarize the results by frequency category
SELECT 
    frequency_category,  -- 'High Frequency', 'Medium Frequency', or 'Low Frequency'
    COUNT(*) AS customer_count,  -- Count of customers in each category
    ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month  -- Average of the average transactions
FROM 
    categorized_customers
GROUP BY 
    frequency_category  -- Group by each frequency category
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1  -- Order categories: High first
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3  -- Low Frequency last
    END;
