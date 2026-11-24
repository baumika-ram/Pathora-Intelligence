-- Q1. Display all records from the job postings table.
SELECT *
FROM raw_job_postings;

-- Q2. Display job title, company name, city and salary band.
SELECT title, company, city, salary_band
FROM raw_job_postings;

-- Q3. Find the total number of job postings.
SELECT COUNT(*) AS total_job_postings
FROM raw_job_postings;

-- Q4. Find the total number of unique companies.
SELECT COUNT(DISTINCT company_name) AS total_companies
FROM companies;

-- Q5. Display all unique job roles.
SELECT DISTINCT job_role
FROM raw_job_postings;

-- Level 2 – Filtering and Sorting
-- Q6. Find all job postings with a High salary band.
SELECT *
FROM raw_job_postings
WHERE salary_band = 'High';

-- Q7. Find job postings that require more than 5 years of experience.
SELECT title, company, experience_years
FROM raw_job_postings
WHERE experience_years > 5;

-- Q8. Find job postings from a particular country.
SELECT *
FROM raw_job_postings
WHERE country = 'United States';

-- Q9. Display the 10 most recently posted jobs.
SELECT title, company, posted_date
FROM raw_job_postings
ORDER BY posted_date DESC
LIMIT 10;

-- Q10. Find the number of job postings for each remote-work category.
SELECT remote, COUNT(*) AS total_jobs
FROM raw_job_postings
GROUP BY remote;

-- Level 3 – Aggregate Functions
-- Q11. Find the average experience required for all jobs.
SELECT AVG(experience_years) AS average_experience
FROM raw_job_postings;

-- Q12. Find the minimum and maximum experience required.
SELECT
    MIN(experience_years) AS minimum_experience,
    MAX(experience_years) AS maximum_experience
FROM raw_job_postings;

-- Q13. Find the total number of job postings for each salary band.
SELECT salary_band, COUNT(*) AS total_jobs
FROM raw_job_postings
GROUP BY salary_band;

-- Q14. Find the number of job postings for each seniority level.
SELECT seniority, COUNT(*) AS total_jobs
FROM raw_job_postings
GROUP BY seniority;

-- Q15. Find the average experience required for each job role.
SELECT
    job_role,
    AVG(experience_years) AS average_experience
FROM raw_job_postings
GROUP BY job_role;

-- Level 4 – GROUP BY and HAVING
-- Q16. Find the top 10 cities with the highest number of job postings.
SELECT city, COUNT(*) AS total_jobs
FROM raw_job_postings
GROUP BY city
ORDER BY total_jobs DESC
LIMIT 10;

-- Q17. Find companies that have more than 100 job postings.
SELECT
    company,
    COUNT(*) AS total_jobs
FROM raw_job_postings
GROUP BY company
HAVING COUNT(*) > 100;

-- Q18. Find job roles that require an average experience of more than 5 years.
SELECT
    job_role,
    AVG(experience_years) AS average_experience
FROM raw_job_postings
GROUP BY job_role
HAVING AVG(experience_years) > 5;

-- Q19. Find the total job postings for each country, arranged from highest to lowest.
SELECT country, COUNT(*) AS total_jobs
FROM raw_job_postings
GROUP BY country
ORDER BY total_jobs DESC;

-- Q20. Calculate the percentage of each salary band in the dataset.
SELECT
    salary_band,
    COUNT(*) AS total_jobs,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM raw_job_postings),
        2
    ) AS percentage
FROM raw_job_postings
GROUP BY salary_band;

-- Level 5 – JOIN Queries
-- Ippo namma rendu tables-um use pannuvom.

-- Q21. Display job postings along with their company IDs using INNER JOIN.
SELECT
    r.posting_id,
    r.title,
    c.company_id,
    c.company_name
FROM raw_job_postings r
INNER JOIN companies c
ON r.company_id = c.company_id;

-- Q22. Find the total number of job postings for each company using JOIN.
SELECT
    c.company_name,
    COUNT(r.posting_id) AS total_jobs
FROM companies c
INNER JOIN raw_job_postings r
ON c.company_id = r.company_id
GROUP BY c.company_name
ORDER BY total_jobs DESC;

-- Q23. Display all companies, including companies without matching job postings, using LEFT JOIN.
SELECT
    c.company_id,
    c.company_name,
    r.posting_id
FROM companies c
LEFT JOIN raw_job_postings r
ON c.company_id = r.company_id;

-- Q24. Find companies that have job postings in more than one city.
SELECT
    c.company_name,
    COUNT(DISTINCT r.city) AS total_cities
FROM companies c
INNER JOIN raw_job_postings r
ON c.company_id = r.company_id
GROUP BY c.company_name
HAVING COUNT(DISTINCT r.city) > 1;

-- Q25. Find the average experience required for each company using JOIN.
SELECT
    c.company_name,
    AVG(r.experience_years) AS average_experience
FROM companies c
INNER JOIN raw_job_postings r
ON c.company_id = r.company_id
GROUP BY c.company_name;

-- Level 6 – Advanced SQL Queries
-- Q26. Find job postings where experience is greater than the overall average experience.
SELECT title, company, experience_years
FROM raw_job_postings
WHERE experience_years >
(
    SELECT AVG(experience_years)
    FROM raw_job_postings
);

-- Q27. Find the second-highest experience requirement.
SELECT MAX(experience_years) AS second_highest_experience
FROM raw_job_postings
WHERE experience_years <
(
    SELECT MAX(experience_years)
    FROM raw_job_postings
);

-- Q28. Find companies that have posted jobs in the High salary band.
SELECT DISTINCT
    c.company_name
FROM companies c
INNER JOIN raw_job_postings r
ON c.company_id = r.company_id
WHERE r.salary_band = 'High';

-- Q29. Rank cities based on their total number of job postings.
SELECT
    city,
    COUNT(*) AS total_jobs,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS city_rank
FROM raw_job_postings
GROUP BY city;

-- Q30. Rank job roles based on their average experience requirement.
SELECT
    job_role,
    AVG(experience_years) AS average_experience,
    DENSE_RANK() OVER (
        ORDER BY AVG(experience_years) DESC
    ) AS role_rank
FROM raw_job_postings
GROUP BY job_role;