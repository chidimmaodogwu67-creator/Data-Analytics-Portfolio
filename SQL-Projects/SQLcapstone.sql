/*
==========================================
SQL CAPSTONE PROJECT
Skin Cancer Diagnosis Analysis

Student: Chidimma Azudiugwu
Course: SQL Capstone
Database: Skin Cancer Dataset

==========================================
*/



SELECT * 
FROM table1
LIMIT 10;

SELECT * 
FROM table2
LIMIT 10;

SELECT *
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
LIMIT 10;

--Exploratory Data Analysis

---Query 1:How many patients?
Select COUNT(*) As total_patients
FROM table1;

--Query 2: Total lesion records?
SELECT COUNT(*) AS total_lesions
FROM table2;

--Query 3: Gender Distribution
SELECT
    gender,
    COUNT(*) AS total_patients
FROM table1
GROUP BY gender
ORDER BY total_patients DESC;

--Query 4: Diagnosis categories


SELECT
    diagnostic,
    COUNT(*) AS total_cases
FROM table2
GROUP BY diagnostic
ORDER BY total_cases DESC;

--Query 5: Body regions
SELECT
    region,
    COUNT(*) AS total_cases
FROM table2
GROUP BY region
ORDER BY total_cases DESC;

--Query 6: Patient age summary
SELECT
    MIN(age) AS youngest_patient,
    MAX(age) AS oldest_patient,
    ROUND(AVG(age),2) AS average_age
FROM table1;


-- Task 1, Question 1
--Which age group has the highest number of skin cancer diagnoses?
SELECT
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 39 THEN '20-39'
        WHEN age BETWEEN 40 AND 59 THEN '40-59'
        WHEN age BETWEEN 60 AND 79 THEN '60-79'
        ELSE '80+'
    END AS age_group,
    COUNT(*) AS total_diagnoses
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY age_group
ORDER BY total_diagnoses DESC;

--Task 1 Question 2
--Distribution of diagnoses between male and female patients?
SELECT
    t1.gender,
    t2.diagnostic,
    COUNT(*) AS total_cases
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
GROUP BY
    t1.gender,
    t2.diagnostic
ORDER BY
    t1.gender,
    total_cases DESC;


--Task 1 Question 3
--The body regions that record the highest number of patients with malignant diagnoses
SELECT
    region,
    COUNT(*) AS malignant_cases
FROM table2
WHERE diagnostic IN ('BCC', 'SCC', 'MEL')
GROUP BY region
ORDER BY malignant_cases DESC;

-- Task 1 Question 4
-- How many patients have a previous history of skin cancer?
SELECT
    skin_cancer_history,
    COUNT(*) AS total_patients
FROM table1
GROUP BY skin_cancer_history;

---- Task 2 Question 1
-- Which diagnosis category appears most frequently?
SELECT
    diagnostic,
    COUNT(*) AS total_cases
FROM table2
GROUP BY diagnostic
ORDER BY total_cases DESC;

---- Task 2 Question 2
-- How many lesions were reported as growing over time?

SELECT
    COUNT(*) AS lesions_grew
FROM table2
WHERE grew = true;

---- Task 2 Question 3
-- Which symptoms are most commonly associated with lesions?

SELECT
    SUM(CASE WHEN itch = true THEN 1 ELSE 0 END) AS itch,
    SUM(CASE WHEN grew = true THEN 1 ELSE 0 END) AS grew,
    SUM(CASE WHEN hurt = true THEN 1 ELSE 0 END) AS hurt,
    SUM(CASE WHEN changed = true THEN 1 ELSE 0 END) AS changed,
    SUM(CASE WHEN bleed = true THEN 1 ELSE 0 END) AS bleed,
    SUM(CASE WHEN elevation = true THEN 1 ELSE 0 END) AS elevation
FROM table2;

---- Task 2 Question 4
-- How many lesions were biopsied before diagnosis confirmation?

SELECT
    COUNT(*) AS biopsied_lesions
FROM table2
WHERE biopsed = true;


-- Task 2 Question 5
-- Which diagnosis type has the highest average lesion diameter?
SELECT
    diagnostic,
    ROUND(
        AVG((diameter_1 + diameter_2) / 2.0)::numeric,
        2
    ) AS average_lesion_diameter
FROM table2
GROUP BY diagnostic
ORDER BY average_lesion_diameter DESC;

---- Task 3 Question 1
-- Which body region has the highest number of diagnosed cases?

SELECT
    region,
    COUNT(*) AS total_cases
FROM table2
GROUP BY region
ORDER BY total_cases DESC;


---- Task 3 Question 2
-- How many patients lack access to piped water?
SELECT
    COUNT(*) AS patients_without_piped_water
FROM table1
WHERE has_piped_water = false;


-- Task 3 Question 3
-- How many patients do not have access to sewage systems?

SELECT
    COUNT(*) AS patients_without_sewage
FROM table1
WHERE has_sewage_system = false;


---- Task 3 Question 4
-- Which body regions report the highest number of biopsied lesions?

SELECT
    region,
    COUNT(*) AS biopsied_lesions
FROM table2
WHERE biopsed = true
GROUP BY region
ORDER BY biopsied_lesions DESC;

---- Task 3 Question 5
-- Is there a relationship between poor sanitation access
-- and severe diagnosis outcomes?

SELECT
    CASE
        WHEN t1.has_piped_water = false
          OR t1.has_sewage_system = false
        THEN 'Poor sanitation access'
        ELSE 'Adequate sanitation access'
    END AS sanitation_status,

    COUNT(*) AS total_patients,

    COUNT(*) FILTER (
        WHERE t2.diagnostic IN ('BCC', 'SCC', 'MEL')
    ) AS severe_diagnoses,

    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE t2.diagnostic IN ('BCC', 'SCC', 'MEL')
        ) / COUNT(*),
        2
    ) AS severe_diagnosis_percentage

FROM table1 t1
JOIN table2 t2
    ON t1.patient_id = t2.patient_id

GROUP BY sanitation_status
ORDER BY severe_diagnosis_percentage DESC;


---- Task 4 Question 1
-- How many patients are smokers?

SELECT
    COUNT(*) AS smokers
FROM table1
WHERE smoke = true;


---- Task 4 Question 2
-- How many patients consume alcohol regularly?

SELECT
    COUNT(*) AS drinkers
FROM table1
WHERE drink = true;

---- Task 4 Question 3
-- Which diagnosis types are most common among smokers?

SELECT
    t2.diagnostic,
    COUNT(*) AS total_smokers
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE t1.smoke = true
GROUP BY t2.diagnostic
ORDER BY total_smokers DESC;

--Task 4 Question 4
--What percentage of smokers also consume alcohol?
SELECT
    ROUND(
        COUNT(CASE WHEN drink = true THEN 1 END) * 100.0
        / COUNT(*),
        2
    ) AS smoker_drinker_percentage
FROM table1
WHERE smoke = true;

--Task 4, Question 5
--Are patients who both smoke and drink more likely to develop malignant conditions?
SELECT
    t2.diagnostic,
    COUNT(*) AS total_cases
FROM table1 t1
JOIN table2 t2
ON t1.patient_id = t2.patient_id
WHERE t1.smoke = true
  AND t1.drink = true
GROUP BY t2.diagnostic
ORDER BY total_cases DESC;

---- Task 4 Question 6
-- Which lifestyle factor has the strongest relationship
-- with severe diagnosis outcomes?

WITH patient_diagnosis AS (
    SELECT
        t1.smoke,
        t1.drink,
        t2.diagnostic
    FROM table1 t1
    JOIN table2 t2
        ON t1.patient_id = t2.patient_id
),

lifestyle_analysis AS (

    SELECT
        'Smoking' AS lifestyle_factor,

        ROUND(
            100.0 * COUNT(*) FILTER (
                WHERE smoke = true
                  AND diagnostic IN ('BCC', 'SCC', 'MEL')
            )
            / NULLIF(COUNT(*) FILTER (WHERE smoke = true), 0),
            2
        ) AS exposed_severe_rate,

        ROUND(
            100.0 * COUNT(*) FILTER (
                WHERE smoke = false
                  AND diagnostic IN ('BCC', 'SCC', 'MEL')
            )
            / NULLIF(COUNT(*) FILTER (WHERE smoke = false), 0),
            2
        ) AS unexposed_severe_rate

    FROM patient_diagnosis

    UNION ALL

    SELECT
        'Alcohol consumption' AS lifestyle_factor,

        ROUND(
            100.0 * COUNT(*) FILTER (
                WHERE drink = true
                  AND diagnostic IN ('BCC', 'SCC', 'MEL')
            )
            / NULLIF(COUNT(*) FILTER (WHERE drink = true), 0),
            2
        ) AS exposed_severe_rate,

        ROUND(
            100.0 * COUNT(*) FILTER (
                WHERE drink = false
                  AND diagnostic IN ('BCC', 'SCC', 'MEL')
            )
            / NULLIF(COUNT(*) FILTER (WHERE drink = false), 0),
            2
        ) AS unexposed_severe_rate

    FROM patient_diagnosis
)

SELECT
    lifestyle_factor,
    exposed_severe_rate,
    unexposed_severe_rate,
    ROUND(
        exposed_severe_rate - unexposed_severe_rate,
        2
    ) AS percentage_point_difference
FROM lifestyle_analysis
ORDER BY ABS(
    exposed_severe_rate - unexposed_severe_rate
) DESC;


-- Final dataset verification

SELECT
    (SELECT COUNT(*) FROM table1) AS total_patients,
    (SELECT COUNT(*) FROM table2) AS total_lesions;
   

































