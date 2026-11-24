CREATE DATABASE pathora_classification;

use pathora_classification;

CREATE TABLE raw_job_postings (
    posting_id INT PRIMARY KEY,
    posted_date DATE,
    title VARCHAR(255),
    company VARCHAR(255),
    job_role VARCHAR(100),
    seniority VARCHAR(100),
    city VARCHAR(100),
    region VARCHAR(100),
    country VARCHAR(50),
    remote VARCHAR(50),
    experience_years DOUBLE,
    skills TEXT,
    salary_band VARCHAR(20)
);

describe raw_job_postings;

SHOW VARIABLES LIKE 'local_infile';

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE
'C:/Users/ELCOT/Downloads/Balanced_dataset.csv'
INTO TABLE raw_job_postings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    posting_id,
    posted_date,
    title,
    company,
    job_role,
    seniority,
    city,
    region,
    country,
    remote,
    experience_years,
    skills,
    salary_band
);

SELECT COUNT(*) AS total_records FROM raw_job_postings;

SELECT DATABASE();

SHOW WARNINGS;

SELECT * FROM raw_job_postings LIMIT 5;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT posting_id) AS unique_ids
FROM raw_job_postings;

TRUNCATE TABLE raw_job_postings;

ALTER TABLE raw_job_postings
MODIFY posting_id VARCHAR(50) NOT NULL;

LOAD DATA LOCAL INFILE
'C:/Users/ELCOT/Downloads/Balanced_dataset.csv'
INTO TABLE raw_job_postings
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(
    posting_id,
    posted_date,
    title,
    company,
    job_role,
    seniority,
    city,
    region,
    country,
    remote,
    experience_years,
    skills,
    salary_band
);

SELECT COUNT(*) AS total_records
FROM raw_job_postings;

SELECT salary_band, COUNT(*) AS total
FROM raw_job_postings
GROUP BY salary_band;

SELECT
    SUM(posting_id IS NULL) AS null_posting_id,
    SUM(posted_date IS NULL) AS null_posted_date,
    SUM(title IS NULL) AS null_title,
    SUM(company IS NULL) AS null_company,
    SUM(job_role IS NULL) AS null_job_role,
    SUM(seniority IS NULL) AS null_seniority,
    SUM(city IS NULL) AS null_city,
    SUM(region IS NULL) AS null_region,
    SUM(country IS NULL) AS null_country,
    SUM(remote IS NULL) AS null_remote,
    SUM(experience_years IS NULL) AS null_experience,
    SUM(skills IS NULL) AS null_skills,
    SUM(salary_band IS NULL) AS null_salary_band
FROM raw_job_postings;

CREATE TABLE companies (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(255) UNIQUE NOT NULL
);

INSERT INTO companies (company_name)
SELECT DISTINCT company
FROM raw_job_postings
WHERE company IS NOT NULL;

ALTER TABLE raw_job_postings
ADD COLUMN company_id INT;

UPDATE raw_job_postings r
JOIN companies c
ON r.company = c.company_name
SET r.company_id = c.company_id;

SET SQL_SAFE_UPDATES = 0;

SELECT
    COUNT(*) AS total_records,
    COUNT(company_id) AS records_with_company_id,
    COUNT(*) - COUNT(company_id) AS missing_company_id
FROM raw_job_postings;

ALTER TABLE raw_job_postings
ADD CONSTRAINT fk_company
FOREIGN KEY (company_id)
REFERENCES companies(company_id);

