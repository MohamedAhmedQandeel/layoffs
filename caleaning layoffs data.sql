#1- creating a backup from our data
create table layoffs_staging  #creating table like the original table
like layoffs ; 

INSERT layoffs_staging #inserting Our original table data to the other Table 
SELECT * 
FROM layoffs ;

SELECT *   #Showing the data that we will work on it 
FROM layoffs_staging;

#removing the dublicates from our Data 
# this Query creating a counting for each typical indivisual in the table as number_of row , if number_of more than one then there is duplication
#creating table to hold row number data
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
  
  )
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

 insert into layoffs_staging2 
 select * ,
 row_number() over (partition by location ,'Date',company,country,funds_raised_millions,total_laid_off,percentage_laid_off,industry ) as row_num
 from layoffs_staging ;
 
 #now this removing all duplicates from our table
 DELETE FROM layoffs_staging2 
 where row_num>1 ;
 
 #removing white spaces from string 
 UPDATE layoffs_staging2 
 SET Company = trim(company) , industry =trim(industry) ,DATE=trim(DATE),STAGE =trim(Stage) ,Country = trim(country) , location =trim(location);
 
 SELECT DISTINCT industry
 FROM layoffs_staging2;  
 #crypto , cryptocurrency is the same thing 
 #standrizing our DATA 
 UPDATE layoffs_staging2 
 SET industry = "Crypto" 
 where industry like'crypto%' ;
 
 SELECT DISTINCT country 
 FROM layoffs_staging 
 ORDER BY country; # united stated appears twice 
 
UPDATE layoffs_staging2
SET country = 'United States' 
WHERE country LIKE 'United S%' ;

SELECT distinct country 
FROM layoffs_staging2
ORDER BY country;
 
 # adjusting date format 
 SELECT date , str_to_date(date,'%m/%d/%Y')
 FROM layoffs_staging ; 
 
 UPDATE layoffs_staging2 
 SET date =str_to_date(date,'%m/%d/%Y');
 select * from layoffs_staging2;
 
 #change from text to date data type
 
 alter table layoffs_staging2 
 modify column date DATE ;
 # Fixing blank and null values 
 
 SELECT * FROM layoffs_staging2  ;  
 
 SELECT * 
 FROM layoffs_staging2 
 WHERE industry ='' OR industry is null; 
 
UPDATE layoffs_staging2 
SET industry ="Transportation"
WHERE company ="Carvana"; #as carvana company appear in the other data points in 'Transportation' industry

SELECT * 
FROM layoffs_staging2 
WHERE company ='airbnb'; 

UPDATE layoffS_staging2 
SET industry ='Trave'
Where Company ='airbnb'; #as airbnb company appear in the other data points in 'Travel' industry 
SELECT * FROM layoffs_staging2 WHERE Company = 'Juul';

UPDATE layoffs_staging 
SET industry = 'consumer'
where Company = 'Juul'; #as juul company appear in the other data points in 'consumer' industry 

#removing NULL VALUES 
SELECT * 
FROM layoffs_staging 
WHERE total_laid_off IS NULL 
AND  percentage_laid_off IS NULL ; 

#Removing all rows with total laid odd and percentage laid off is null because we can not use it 
DELETE 
FROM layoffs_staging 
WHERE total_laid_off IS NULL 
AND  percentage_laid_off IS NULL ; 

ALTER TABLE layoffs_staging2 
drop column row_num ; 