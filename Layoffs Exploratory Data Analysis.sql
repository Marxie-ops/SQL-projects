SELECT DISTINCT*
FROM`world-layoffs`.layoffs_staging2;

SELECT DISTINCT MAX(total_laid_off), MAX(percentage_laid_off)
FROM`world-layoffs`.layoffs_staging2;

SELECT DISTINCT*
FROM`world-layoffs`.layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT DISTINCT*
FROM`world-layoffs`.layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT DISTINCT company,SUM(total_laid_off)
FROM`world-layoffs`.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(date), MAX(date)
FROM`world-layoffs`.layoffs_staging2;

SELECT DISTINCT YEAR(date), SUM(total_laid_off)
FROM`world-layoffs`.layoffs_staging2
GROUP BY YEAR(date)
ORDER BY 1 DESC;

SELECT DISTINCT stage, SUM(total_laid_off)
FROM`world-layoffs`.layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT DISTINCT company, AVG(percentage_laid_off)
FROM`world-layoffs`.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT DISTINCT*
FROM`world-layoffs`.layoffs_staging2;

WITH rolling_Total AS 
   (SELECT SUBSTRING(date,1,7) AS MWEZI, SUM(total_laid_off) AS total_off
      FROM`world-layoffs`.layoffs_staging2
         WHERE SUBSTRING(date,1,7) IS NOT NULL
           GROUP BY MWEZI
               ORDER BY 1 ASC)

SELECT MWEZI,total_off,SUM(total_off) OVER(ORDER BY MWEZI) AS rolling_Total
FROM Rolling_Total;

SELECT DISTINCT company,SUM(total_laid_off)
FROM`world-layoffs`.layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;
 
SELECT company, YEAR(date), SUM(total_laid_off)
FROM`world-layoffs`.layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS 
     (SELECT company, YEAR(date), SUM(total_laid_off)
         FROM`world-layoffs`.layoffs_staging2
            GROUP BY company, YEAR(date)
            ), Company_Year_Rank AS (
		SELECT*, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
        FROM Company_Year
           WHERE years IS NOT NULL)
SELECT*
FROM Company_Year_Rank
WHERE Ranking<=5;