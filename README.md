# Walmart-Sales-Analysis
Determining areas of revenue and profit from Walmart sales data - Revenue vs Profit Margin by sales categories and location. 

This project aimed to determine which drivers produced the highest overall profit by analysing revenue versus profit margin of Walmart stores across the USA. Specifically, location and sales categories were investigated. Python was used for data formatting, pre-processing, and visualization while SQL was used for in-depth data exploration and analysis. Other functions used included pandas, matplotlib and pymysql. 

## Key Findings: 

Analysis demonstrated that areas of high profit, determine by revenue to profit margin ration, were dependent on sales categories as well as location. Specifically, Home and Lifestyle product and Fashion and Accessories had the highest profit of ~ $384K, with a total similar revenue of $489,250 and a profit-margin of 0.40. Health and Beauty demonstrated the lowest profit of ~ $93,700. Interestingly, profit margins scarcely fluctuated across categories (~ 0.39). Therefore it was deduced that the substantial difference in profit is tied to primarily to revenue. Fashion and Accessories and Home and Lifestyle products are more profitable because they generate more revenue. 

Regarding profit based on location, through visual analysis of the high profit categories, it was determined that profit-margin fluctuated greatly across cities. In contrast, total profit grouped into two main clusters ($1K-$4K and $5K-$14K); the same is true regarding total revenue generated.  In this dataset margin acts more as a  fixed constant rather than dominant driver of profit. There is not enough in the dataset to determine the true cause of fluctuation in profit-margin and revenue by city appears to be a driver of profit, however the dataset does not allow for further investigation into this.  

## Methodology: 
1. Cleaned raw CSV in pandas — handled nulls, converted `unit_price` from string to float
2. Loaded cleaned data into MySQL via SQLAlchemy
3. Queried category-level revenue, profit, and margin (SQL) — identified Home & Lifestyle and Fashion Accessories as the two highest-revenue categories
4. Found `profit_margin` is non-continuous (only 6 discrete values), not a smoothly calculated field
5. Broke down each category's transactions by margin tier — found the category-level margin gap is driven by product mix, not a uniform per-category rate
6. Tested and ruled out confounding explanations for city-level margin variation: unit price, transaction volume/sample size, and customer rating
7. Compared total profit by city against revenue/transaction volume — found profit closely tracks volume, since margin's variation is small relative to revenue's larger swings
8. Concluded profit margin is likely an artifact of how the dataset was synthetically generated — findings demonstrate the analytical methodology rather than real-world business conclusions

## Sample Query: 

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

## Visualization: 
<img width="800" alt="image" src="https://github.com/user-attachments/assets/97fd6611-f038-43a6-97bb-c3c897004c50" />

<img width="800" alt="image" src="https://github.com/user-attachments/assets/1875bb36-2189-428f-9192-27cdc0204e9c" />

## Limitations: 

- **profit_margin appears synthetically generated.** The column takes only 6 discrete values (0.18, 0.21, 0.33, 0.36, 0.48, 0.57) with no continuous variation — atypical for real transaction data, where margin is usually derived from fluctuating cost and price figures. This suggests the dataset assigns margin programmatically rather than calculating it from underlying cost data.
- **The cause of margin-tier assignment can't be determined from this dataset.** Unit price, transaction volume, sample size, and customer rating were all tested as possible explanations for why a given transaction lands in a higher or lower margin tier — none showed a meaningful relationship. The dataset has no cost, supplier, or product-level fields that could explain the pattern further.
- **City-level margin variation is real but unexplained.** Some cities consistently show lower average margins across both compared categories, and this isn't attributable to sample size or the confounders tested above. A likely explanation (regional pricing, promotions, competition) isn't testable without additional data this dataset doesn't include.
- **No customer identifier exists**, so repeat-purchase, loyalty, or CRM-style analysis (segmentation, retention) isn't possible with this data — despite being a stated interest of the roles this project was built for.
- **Findings should be read as a demonstration of methodology**, not as real business insight for an actual retailer. Given the likely-synthetic nature of the margin field, the specific numbers (e.g., "Fashion accessories splits 45/45 across two tiers") reflect how this dataset was constructed rather than genuine retail economics — but the analytical approach (hypothesis testing, disaggregation by city/category, systematically ruling out confounders) directly transfers to real transactional data.


