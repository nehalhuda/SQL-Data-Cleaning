-- View the raw data
SELECT *
FROM layoffs;

-- ------------------------------------------------------
-- STEP 1: Create a staging table for cleaning
-- ------------------------------------------------------
-- This prevents us from modifying the original dataset.

CREATE TABLE layoffs_staging
LIKE layoffs;

-- Verify the empty staging table
SELECT *
FROM layoffs_staging;

-- Copy data from the original table into the staging table
INSERT layoffs_staging
SELECT *
FROM layoffs;

-- ------------------------------------------------------
-- STEP 2: Identify duplicate records
-- ------------------------------------------------------
-- Using ROW_NUMBER() to assign a unique number to duplicate rows
-- based on identical values in key columns.

SELECT *, ROW_NUMBER() OVER(
  PARTITION BY company, location, industry, total_laid_off,
               percentage_laid_off, `date`
) AS row_num
FROM layoffs_staging;

-- Create a CTE to isolate duplicates
WITH duplicate_CTE AS (
  SELECT *,
         ROW_NUMBER() OVER(
           PARTITION BY company, location, industry,
                        total_laid_off, percentage_laid_off,
                        `date`, stage, country, funds_raised_millions
         ) AS row_num
  FROM layoffs_staging
)
SELECT *
FROM duplicate_CTE
WHERE row_num > 1;

-- Check duplicates for a specific company example
SELECT *
FROM layoffs_staging
WHERE company = 'Casper';

-- ------------------------------------------------------
-- STEP 3: Remove duplicates
-- ------------------------------------------------------
-- MySQL doesn’t allow direct DELETE from CTE, so we create a new table.

CREATE TABLE layoffs_staging2 (
  `company` TEXT,
  `location` TEXT,
  `industry` TEXT,
  `total_laid_off` INT DEFAULT NULL,
  `percentage_laid_off` TEXT,
  `date` TEXT,
  `stage` TEXT,
  `country` TEXT,
  `funds_raised_millions` INT DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Insert data into new staging table with a row number to identify duplicates
INSERT INTO layoffs_staging2
SELECT *,
       ROW_NUMBER() OVER(
         PARTITION BY company, location, industry, total_laid_off,
                      percentage_laid_off, `date`, stage, country,
                      funds_raised_millions
       ) AS row_num
FROM layoffs_staging;

-- Delete duplicate rows (row_num > 1)
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

-- Verify cleaned dataset
SELECT *
FROM layoffs_staging2;

-- ------------------------------------------------------
-- STEP 4: Standardize data
-- ------------------------------------------------------

-- 🔹 Remove extra spaces from company names
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- 🔹 Standardize similar industry names (e.g., “Crypto”, “CryptoCurrency”)
SELECT DISTINCT industry
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- 🔹 Standardize country names (remove trailing periods)
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_staging2
ORDER BY 1;

UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- 🔹 Convert date column from text to proper DATE format
SELECT `date`
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

-- ------------------------------------------------------
-- STEP 5: Handle NULLs and blank values
-- ------------------------------------------------------

-- Identify rows where both layoff columns are null
SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Replace empty strings in industry with NULL
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- Check if any industries are still NULL or blank
SELECT DISTINCT industry
FROM layoffs_staging2
WHERE industry IS NULL
  OR industry = '';

-- Look at specific companies with missing industries
SELECT *
FROM layoffs_staging2
WHERE company LIKE 'Bally%';

-- 🔹 Fill in missing industries using other rows of the same company
SELECT *
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;

-- 🔹 Remove rows where both key layoff columns are null (no useful info)
DELETE 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

-- Verify final cleaned dataset
SELECT *
FROM layoffs_staging2;

-- ------------------------------------------------------
-- STEP 6: Remove helper columns
-- ------------------------------------------------------

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- ✅ Final Cleaned Dataset Ready for Analysis
SELECT *
FROM layoffs_staging2;
