#DATA CLEANING
SELECT * FROM `world-layoffs`.layoffs;
#1.REMOVE ANY DUPLICATES 
#2.STANDARDIZE THE DATA
#3.NULL VALUES
#4.REMOVE UNNECESSARY COLUMNS AND ROWS
#5.NEVER WORK WITH REAL DATA CREATE A DUPLICATE
SELECT * FROM layoffs;

CREATE TABLE `world-layoffs`.layoffs_staging
LIKE `world-layoffs`.layoffs; 

SELECT * 
FROM `world-layoffs`.layoffs_staging;

INSERT `world-layoffs`.layoffs_staging
SELECT*
FROM `world-layoffs`.layoffs;

 SELECT * FROM `world-layoffs`.layoffs_staging;
 
 #1.REMOVE DUPLICATES

SELECT*,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',
stage,country,funds_raised_millions) as row_num
FROM `world-layoffs`.layoffs_staging;

WITH duplicate_cte AS (SELECT*,
ROW_NUMBER() OVER(
PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',
stage,country,funds_raised_millions) as row_num
FROM `world-layoffs`.layoffs_staging)

SELECT*
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `world-layoffs`.`layoffs_staging2` (
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
SELECT*
FROM `world-layoffs`.`layoffs_staging2`;

INSERT INTO `world-layoffs`.layoffs_staging2
   (SELECT*,
      ROW_NUMBER() OVER(
	  PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,'date',
	  stage,country,funds_raised_millions) as row_num
	   FROM `world-layoffs`.layoffs_staging);

SET SQL_SAFE_UPDATES=0;
DELETE
FROM `world-layoffs`.layoffs_staging2
WHERE row_num > 1;

SELECT*
FROM `world-layoffs`.layoffs_staging2;

#STANDARDIZING DATA
SELECT company, TRIM(company)
FROM `world-layoffs`.layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;
UPDATE `world-layoffs`.layoffs_staging2
SET company = TRIM(company);

SELECT *
FROM `world-layoffs`.layoffs_staging2
WHERE industry LIKE 'crypto%';

SET SQL_SAFE_UPDATES = 0;
UPDATE `world-layoffs`.layoffs_staging2
SET industry = 'crypto'
WHERE industry LIKE 'crypto%';

SELECT industry
FROM `world-layoffs`.layoffs_staging2
WHERE industry = 'crypto';

SELECT DISTINCT  TRIM( TRAILING '.' FROM country)
FROM `world-layoffs`.layoffs_staging2
ORDER BY 1;

SET SQL_SAFE_UPDATES = 0;
UPDATE `world-layoffs`.layoffs_staging2
SET country = TRIM( TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT country
FROM `world-layoffs`.layoffs_staging2
WHERE country = 'united states';

SELECT date,
STR_TO_DATE(date,'%m/%d/%Y')
FROM `world-layoffs`.layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;
UPDATE`world-layoffs`.layoffs_staging2
SET date = STR_TO_DATE(date,'%m/%d/%Y');
SET SQL_SAFE_UPDATES = 1;

SELECT date 
FROM `world-layoffs`.layoffs_staging2;

ALTER TABLE`world-layoffs`.layoffs_staging2
MODIFY COLUMN date DATE;

SELECT*
FROM `world-layoffs`.layoffs_staging2;

#3.WORKING WITH BLANK VALUES
SELECT*
FROM `world-layoffs`.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SET SQL_SAFE_UPDATES =0;
UPDATE `world-layoffs`.layoffs_staging2
SET industry=NULL
WHERE industry='';

SELECT*
FROM `world-layoffs`.layoffs_staging2
WHERE industry IS NULL
OR industry = '';

SELECT DISTINCT*
FROM `world-layoffs`.layoffs_staging2
WHERE company = 'Airbnb';

SELECT T1.industry, T2.industry
FROM `world-layoffs`.layoffs_staging2 T1
      JOIN `world-layoffs`.layoffs_staging2 T2
          ON T1.company= T2.company
WHERE T1.industry IS NULL 
          AND T2.industry IS NOT NULL;

SET SQL_SAFE_UPDATES =0;
UPDATE `world-layoffs`.layoffs_staging2 T1
          JOIN `world-layoffs`.layoffs_staging2 T2
              ON T1.company= T2.company
           SET  T1.industry= T2.industry
           WHERE T1.industry IS NULL 
				AND T2.industry IS NOT NULL;
         
SET SQL_SAFE_UPDATES =0;
DELETE
FROM`world-layoffs`.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT DISTINCT*
FROM`world-layoffs`.layoffs_staging2;

ALTER TABLE `world-layoffs`.layoffs_staging2
DROP COLUMN row_num;
