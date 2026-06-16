-- ============================================================
-- Lattice Cryptography & PQC Research Paper Database
-- Data loading (PostgreSQL)
-- ============================================================
-- Run this after schema.sql, from the project folder, so the
-- relative paths to the data/ folder resolve correctly.
-- Run from psql so that \copy works.
-- ============================================================

\copy authors       FROM 'data/authors.csv'       WITH (FORMAT csv, HEADER true);
\copy papers        FROM 'data/papers.csv'         WITH (FORMAT csv, HEADER true);
\copy paper_authors FROM 'data/paper_authors.csv'  WITH (FORMAT csv, HEADER true);
\copy citations     FROM 'data/citations.csv'      WITH (FORMAT csv, HEADER true);

-- Quick sanity checks after loading
SELECT 'authors' AS table_name, COUNT(*) AS row_count FROM authors
UNION ALL
SELECT 'papers', COUNT(*) FROM papers
UNION ALL
SELECT 'paper_authors', COUNT(*) FROM paper_authors
UNION ALL
SELECT 'citations', COUNT(*) FROM citations;
