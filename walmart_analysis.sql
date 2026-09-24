-- walmart_db Which categories and branches drive revenue vs. which drive profit — and where do they diverge?"

SELECT COUNT (*) 
FROM walmart;

-- 100 branches 
SELECT COUNT(DISTINCT Branch)  -- find out the total number of unique store branches
FROM walmart;

-- Determine which category makes the most revenue and profit
SELECT 
    category,
    SUM(unit_price * quantity) AS total_revenue, 
    SUM(unit_price* quantity * profit_margin) AS total_profit,
    AVG(profit_margin) AS avg_margin
From walmart
Group BY category
ORDER BY total_revenue DESC; 

-- BREAKDOWN PER BRANCH: Determine category revenue and profit per branch 
SELECT 
    Branch,
    category,
    SUM(unit_price * quantity) AS total_revenue, 
    AVG(profit_margin) AS avg_margin
From walmart
Group BY category, Branch
ORDER BY total_revenue, avg_margin DESC;

-- PROFIT MARGIN ANALYSIS 
-- avg profit MARGIN BENCHMARK used 
SELECT AVG(profit_margin) FROM walmart;

-- profit margin is discrete
SELECT DISTINCT profit_margin FROM walmart ORDER BY profit_margin;

-- TIER DISTRIBUTION PER CATEGORY: profit margin distinction by number of transactions 
SELECT 
    category, 
    profit_margin, 
    COUNT(*) AS num_transactions,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY category), 1) AS pct_of_category
FROM walmart
GROUP BY category, profit_margin
ORDER BY category, profit_margin;
 
-- COMPARISON ACROSS CITIES
-- check if number of transactions across cities

SELECT 
    City,
    category,
    COUNT(*) AS num_transactions,
    AVG(profit_margin) AS avg_margin
FROM walmart
WHERE category IN ('Fashion accessories', 'Home and lifestyle')
GROUP BY City, category
ORDER BY num_transactions ASC; 

-- check the distribution of rating across cities
SELECT 
    City,
    category,
    AVG(rating) AS avg_rating,
    AVG(profit_margin) AS avg_margin
FROM walmart
WHERE category IN ('Fashion accessories', 'Home and lifestyle')
GROUP BY City, category
ORDER BY avg_rating ASC;

-- check total profit comparison across cities 

SELECT 
    City,
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM walmart
WHERE category IN ('Fashion accessories', 'Home and lifestyle')
GROUP BY City, category
ORDER BY total_profit ASC;


-- SUMMARY: overview of profit 

SELECT 
    category,
    SUM(unit_price * quantity) AS total_revenue,
    SUM(unit_price * quantity * profit_margin) AS total_profit,
    ROUND(
        SUM(unit_price * quantity * profit_margin) * 100.0 
        / (SELECT SUM(unit_price * quantity * profit_margin) FROM walmart), 
        1
    ) AS pct_of_total_profit,
    ROUND(AVG(profit_margin) * 100, 1) AS avg_margin_pct
FROM walmart
GROUP BY category
ORDER BY pct_of_total_profit DESC;