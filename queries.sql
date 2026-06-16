-- ============================================================
-- Lattice Cryptography & PQC Research Paper Database
-- Queries (PostgreSQL)
-- ============================================================
-- Each query answers a question about the paper dataset and is
-- labelled with the main SQL concept it demonstrates.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Most prolific authors (by number of papers)
-- Concept: JOIN across a many-to-many relationship, GROUP BY
-- ------------------------------------------------------------
SELECT
    a.author_name,
    COUNT(*) AS paper_count
FROM paper_authors pa
JOIN authors a ON a.author_id = pa.author_id
GROUP BY a.author_name
ORDER BY paper_count DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 2. Papers per research field, by year
-- Concept: GROUP BY with multiple columns
-- ------------------------------------------------------------
SELECT
    field,
    year,
    COUNT(*) AS paper_count
FROM papers
GROUP BY field, year
ORDER BY field, year;


-- ------------------------------------------------------------
-- 3. Co-authorship pairs (authors who have written a paper together)
-- Concept: self-join on a junction table
-- ------------------------------------------------------------
SELECT
    a1.author_name AS author_1,
    a2.author_name AS author_2,
    COUNT(*) AS papers_together
FROM paper_authors pa1
JOIN paper_authors pa2
    ON pa1.paper_id = pa2.paper_id
    AND pa1.author_id < pa2.author_id
JOIN authors a1 ON a1.author_id = pa1.author_id
JOIN authors a2 ON a2.author_id = pa2.author_id
GROUP BY a1.author_name, a2.author_name
ORDER BY papers_together DESC, author_1
LIMIT 15;


-- ------------------------------------------------------------
-- 4. Most cited papers in this dataset
-- Concept: JOIN, COUNT, ORDER BY
-- ------------------------------------------------------------
SELECT
    p.title,
    p.year,
    COUNT(c.citing_paper_id) AS times_cited
FROM papers p
LEFT JOIN citations c ON c.cited_paper_id = p.paper_id
GROUP BY p.paper_id, p.title, p.year
ORDER BY times_cited DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 5. Authors who have published in more than one research field
-- Concept: JOIN, GROUP BY, HAVING with COUNT DISTINCT
-- ------------------------------------------------------------
SELECT
    a.author_name,
    COUNT(DISTINCT p.field) AS distinct_fields,
    STRING_AGG(DISTINCT p.field, ', ') AS fields
FROM paper_authors pa
JOIN authors a ON a.author_id = pa.author_id
JOIN papers p ON p.paper_id = pa.paper_id
GROUP BY a.author_name
HAVING COUNT(DISTINCT p.field) > 1
ORDER BY distinct_fields DESC;


-- ------------------------------------------------------------
-- 6. Papers that cite a given foundational paper (direct citations)
-- Concept: JOIN, filtering on a specific value
-- Example: papers that directly cite Regev's 2005 LWE paper
-- ------------------------------------------------------------
SELECT
    citing.title AS citing_paper,
    citing.year
FROM citations c
JOIN papers cited  ON cited.paper_id = c.cited_paper_id
JOIN papers citing ON citing.paper_id = c.citing_paper_id
WHERE cited.title = 'On Lattices, Learning with Errors, Random Linear Codes, and Cryptography'
ORDER BY citing.year;


-- ------------------------------------------------------------
-- 7. Papers per year, with a running total
-- Concept: window function (running total with SUM OVER)
-- ------------------------------------------------------------
WITH yearly_counts AS (
    SELECT year, COUNT(*) AS papers_this_year
    FROM papers
    GROUP BY year
)
SELECT
    year,
    papers_this_year,
    SUM(papers_this_year) OVER (ORDER BY year) AS running_total
FROM yearly_counts
ORDER BY year;


-- ------------------------------------------------------------
-- 8. Rank papers by citation count within each field
-- Concept: CTE, window function (RANK with PARTITION BY)
-- ------------------------------------------------------------
WITH paper_citation_counts AS (
    SELECT
        p.paper_id,
        p.title,
        p.field,
        COUNT(c.citing_paper_id) AS times_cited
    FROM papers p
    LEFT JOIN citations c ON c.cited_paper_id = p.paper_id
    GROUP BY p.paper_id, p.title, p.field
)
SELECT
    field,
    title,
    times_cited,
    RANK() OVER (PARTITION BY field ORDER BY times_cited DESC) AS rank_in_field
FROM paper_citation_counts
ORDER BY field, rank_in_field;
