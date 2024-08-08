Use `World_layoffs`;

SELECT * FROM `layoffs`;


-- 1. Copy this dataset 
CREATE TABLE layofss_copy
LIKE layoffs;

SELECT * FROM layofss_copy;

INSERT layofss_copy
SELECT * FROM layoffs;



-- 2. Remove Duplicates

SELECT *, ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country,funds_raised_millions) AS row_num
 FROM layofss_copy;
 
 WITH duplicate_cte AS
 (SELECT *, ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country,funds_raised_millions) 
AS row_num
 FROM layofss_copy)
 SELECT * FROM duplicate_cte
 WHERE row_num>1;
 
 CREATE TABLE `layofss_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


INSERT INTO layofss_copy2 
 SELECT *, ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`,stage, country,funds_raised_millions) 
AS row_num
 FROM layofss_copy;
 
 DELETE 
 FROM layofss_copy2
 WHERE row_num>1;
 
SELECT * FROM layofss_copy2
 WHERE row_num>1;
 
 SELECT * FROM layofss_copy2;
 
 
-- 3. Standartize the data
SELECT company, TRIM(company) FROM layofss_copy2;

UPDATE layofss_copy2
SET company = TRIM(company);

SELECT * FROM layofss_copy2
WHERE industry lIKE 'Crypto%';

SELECT DISTINCT industry
FROM layofss_copy2
ORDER BY 1;

SELECT DISTINCT country
FROM layofss_copy2
ORDER BY 1;


UPDATE layofss_copy2
SET country = 'USA'
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layofss_copy2;

UPDATE layofss_copy2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')
WHERE `date` LIKE '%/%/%';

ALTER TABLE layofss_copy2
MODIFY COLUMN `date` DATE;


-- 4. Null values or blan values

SELECT * FROM layofss_copy2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE
FROM layofss_copy2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT * FROM layofss_copy2
WHERE industry IS NULL OR industry='';


UPDATE layofss_copy2 t1
JOIN layofss_copy2 t2
	ON t1.company=t1.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL OR t1.industry = ''
AND t2.industry IS NOT NULL;

SELECT * FROM layofss_copy2
WHERE company='Airbnb';
-- 5. Remove any columns

ALTER TABLE layofss_copy2
DROP COLUMN row_num;

SELECT * FROM layofss_copy2;

