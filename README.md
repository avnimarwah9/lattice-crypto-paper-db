# Lattice Cryptography & Post-Quantum Cryptography — Research Paper Database

A SQL project built around a small database of real research papers in lattice-based and post-quantum cryptography, the same research area as my M.Sc. thesis on lattice-based attribute-based encryption. I built this to practice schema design from scratch, rather than working with a ready-made flat dataset, and to write queries on a citation network rather than a typical sales or business dataset.

## About this project

The dataset is a curated set of 45 real papers in lattice cryptography, attribute-based encryption, identity-based encryption, homomorphic encryption, and post-quantum cryptography (including the BGG+14 scheme that my thesis is based on, Regev’s original LWE paper, and CRYSTALS-Kyber). Titles, authors, years, and venues were checked by hand against published sources before upload. The citation relationships between papers are based on the real reference structure of this literature, though for a dataset this size I focused on building an accurate and representative citation network rather than an exhaustive one.

## Database design

Unlike the EdTech project, which started from an existing spreadsheet, this database was designed from scratch with four tables:

|Table          |Description                                                    |
|---------------|---------------------------------------------------------------|
|`papers`       |45 papers with title, year, venue, and research field          |
|`authors`      |74 distinct authors                                            |
|`paper_authors`|many-to-many link between papers and authors, with author order|
|`citations`    |self-referencing table linking citing papers to cited papers   |

## Files

- `schema.sql` — table definitions and indexes
- `load_data.sql` — commands to load the CSV data into the tables
- `queries.sql` — 8 queries, from simple aggregations to self-joins and window functions
- `data/` — the CSV files (authors, papers, paper_authors, citations)

## How to run this

1. Create a database in PostgreSQL.
1. Run `schema.sql` to create the tables.
1. Run `load_data.sql` from the project folder to load the CSV files (uses `\copy`, so run it from `psql`).
1. Run any query from `queries.sql`.

## Queries included

1. Most prolific authors by number of papers
1. Papers per research field, by year
1. Co-authorship pairs (self-join on the paper-author link table)
1. Most cited papers in the dataset
1. Authors who have published across more than one research field
1. Papers that directly cite a specific foundational paper (Regev’s 2005 LWE paper)
1. Papers per year with a running total (window function)
1. Papers ranked by citation count within each research field (window function with PARTITION BY)

## Key findings

- The BGG+14 paper (Fully Key-Homomorphic Encryption, Arithmetic Circuit ABE and Compact Garbled Circuits) is the most cited paper in this dataset, which matches its role as a foundational scheme that much later attribute-based encryption work builds on or critiques.
- Craig Gentry, Vadim Lyubashevsky, and Brent Waters are the most prolific authors in this set, reflecting their central role across lattice cryptography, homomorphic encryption, and post-quantum schemes.
- A few authors, including Craig Gentry and Shweta Agrawal, appear across more than one research field in this dataset, showing how lattice techniques are reused across attribute-based encryption, homomorphic encryption, and identity-based encryption.

## Tools used

PostgreSQL (schema design, joins, GROUP BY, self-joins, CTEs, window functions: RANK, SUM OVER for running totals)
