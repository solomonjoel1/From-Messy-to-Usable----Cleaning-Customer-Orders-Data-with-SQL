# From-Messy-to-Usable----Cleaning-Customer-Orders-Data-with-SQL
# Cleaning Messy Customer & Orders Data with SQL

## Problem
Raw data from a sales system had duplicates, inconsistent casing, 
mixed date formats, text amounts, and invalid values like -5000.

## Tables
- raw_customers: 200 rows
- raw_orders: 500 rows

## Errors Found (Audit)
- 10 duplicate customer_ids
- Names like ' ada ', 'TUNDE' vs 'tunde'
- Cities: Lagos, lagos, LAGOS , Abuja
- Phones with dashes and 'unknown'
- Emails with 'no-email'
- Dates in 2 formats: YYYY-MM-DD and DD/MM/YYYY
- Amounts as text with commas, and one -5000 (invalid)
- Orphan orders with no customer

## Cleaning Steps
1. TRIM() - remove spaces
2. INITCAP() / LOWER() - fix casing
3. DISTINCT ON (customer_id) - remove duplicates
4. CAST() + Regex - convert amount text to NUMERIC
5. TO_DATE() - standardize dates
6. CASE WHEN - replace 'unknown' / 'no-email' with NULL
7. DELETE WHERE amount <= 0 and orphan orders

## Result
- clean_customers: no duplicates, clean names/cities
- clean_orders: numeric amounts, real dates, no negative orders
- Ready for JOIN, GROUP BY, SUM analysis

## Example Analysis
Total sales by city and month using JOIN + GROUP BY + SUM
