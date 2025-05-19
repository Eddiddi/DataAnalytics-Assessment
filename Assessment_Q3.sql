-- Step 1: Combine savings and investment accounts along with their last transaction dates
WITH combined_accounts AS (
    
    -- Select regular savings accounts and their last transaction date
    SELECT 
        s.plan_id,
        s.owner_id,
        'Savings' AS type,  -- Label as 'Savings'
        MAX(s.transaction_date) AS last_transaction_date  -- Get the most recent transaction date
    FROM 
        savings_savingsaccount s
    JOIN 
        plans_plan p ON s.plan_id = p.id  -- Join savings account to its associated plan
    WHERE 
        p.is_regular_savings = 1  -- Include only regular savings accounts
        AND p.is_deleted = 0  -- Exclude deleted plans
    GROUP BY 
        s.plan_id, s.owner_id  -- Group by plan and owner
    
    UNION ALL  -- Combine with investment accounts
    
    -- Select investment plans and their last transaction date
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        'Investment' AS type,  -- Label as 'Investment'
        MAX(s.transaction_date) AS last_transaction_date  -- May be NULL if no transactions exist
    FROM 
        plans_plan p
    LEFT JOIN 
        savings_savingsaccount s ON p.id = s.plan_id  -- Left join to include plans even with no transactions
    WHERE 
        p.is_a_fund = 1  -- Include only investment plans
        AND p.is_deleted = 0  -- Exclude deleted plans
    GROUP BY 
        p.id, p.owner_id  -- Group by plan and owner
),

-- Step 2: Identify accounts that have been inactive
inactive_accounts AS (
    SELECT 
        plan_id,
        owner_id,
        type,
        last_transaction_date,
        DATEDIFF(CURRENT_DATE(), last_transaction_date) AS inactivity_days  -- Calculate days since last transaction
    FROM 
        combined_accounts
    WHERE 
        last_transaction_date IS NOT NULL  -- Exclude accounts that have never had a transaction
)

-- Step 3: Select and display only accounts inactive for over 1 year
SELECT 
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    inactivity_days
FROM 
    inactive_accounts
WHERE 
    inactivity_days > 365  -- Filter for accounts inactive for more than 365 days
ORDER BY 
    inactivity_days DESC;  -- Show longest inactive_
