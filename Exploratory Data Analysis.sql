-- showing the max laid of in one day 
SELECT max(total_laid_off) 
FROM layoffs_staging2;
-- max percentage laied off in one day 
SELECT MAX(percentage_laid_off)
FROM layoffs_staging2;
-- showing companies that laied off all there employees
SELECT * 
FROM layoffs_staging2 
WHERE percentage_laid_off = 1
ORDER BY total_laid_off desc 
; 

#showing company with it is total laid off employees
SELECT company,sum(total_laid_off) 
FROM layoffs_staging2
GROUP BY company 
ORDER BY sum(total_laid_off)DESC;

-- Showing time period of our Data 
SELECT min(date), max(date)
FROM layoffs_staging2;
-- showing the most industry with total laied off 
SELECT industry,sum(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry 
ORDER BY sum(total_laid_off)DESC;

-- showing the country with the most laid off people 
SELECT country,sum(total_laid_off) 
FROM layoffs_staging2
GROUP BY country 
ORDER BY sum(total_laid_off)DESC;

-- which year has the most laied off people 
SELECT Year(DATE),sum(total_laid_off) 
FROM layoffs_staging2
GROUP BY YEAR(DATE) 
ORDER BY sum(total_laid_off)DESC;
-- which company stage have the most laid off people ? 
SELECT stage,sum(total_laid_off) 
FROM layoffs_staging2
GROUP BY stage 
ORDER BY sum(total_laid_off)DESC;

-- how total laied off peoble changed by month ? 
SELECT substring(DATE ,1,7) as 'month' ,sum(Total_laid_off)
FROM layoffs_staging2 
WHERE substring(DATE ,1,7) is not null 
GROUP BY substring(DATE ,1,7)
ORDER BY 1 asc;

-- making a rolling sum for months 

with Rolling_total as (
SELECT substring(DATE ,1,7) as 'month' , sum(total_laid_off) as rolling_sum
FROM layoffs_staging2 
WHERE substring(DATE ,1,7) is not null 
GROUP BY month 
ORDER BY 1 asc
)
SELECT month ,rolling_sum,sum(rolling_sum) over(ORDER by month) as 'rolling sum'
FROM Rolling_total ;

SELECT company ,YEAR(date),sum(total_laid_off)
FROM layoffs_staging2 
GROUP BY company , YEAR(DATE) ;

WITH rank_Totals AS (
    SELECT 
        company, 
        YEAR(date) AS years, 
        SUM(total_laid_off) AS TOTAL_LAID_off
    FROM 
        layoffs_staging2 
    GROUP BY 
        company, 
        YEAR(date)
)
SELECT 
    company, 
    years,
    TOTAL_LAID_OFF
    ,
    DENSE_RANK() OVER (PARTITION BY years ORDER BY TOTAL_LAID_off DESC) AS rank_of_company
    FROM 
    rank_totals 
WHERE 
    years IS NOT NULL;