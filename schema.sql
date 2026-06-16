-- ============================================================
-- Lattice Cryptography & Post-Quantum Cryptography
-- Research Paper Database — Schema (PostgreSQL)
-- ============================================================
-- This database models a small but real set of papers in
-- lattice-based and post-quantum cryptography, the same
-- research area as my M.Sc. thesis. It includes papers,
-- authors, a many-to-many paper-author relationship, and a
-- citation graph between papers.
-- ============================================================

DROP TABLE IF EXISTS citations;
DROP TABLE IF EXISTS paper_authors;
DROP TABLE IF EXISTS papers;
DROP TABLE IF EXISTS authors;

CREATE TABLE papers (
    paper_id INTEGER PRIMARY KEY,
    title    VARCHAR(200) NOT NULL,
    year     INTEGER NOT NULL,
    venue    VARCHAR(100),
    field    VARCHAR(50)
);

CREATE TABLE authors (
    author_id   INTEGER PRIMARY KEY,
    author_name VARCHAR(100) NOT NULL
);

-- Many-to-many relationship between papers and authors
CREATE TABLE paper_authors (
    paper_id     INTEGER NOT NULL REFERENCES papers(paper_id),
    author_id    INTEGER NOT NULL REFERENCES authors(author_id),
    author_order INTEGER,
    PRIMARY KEY (paper_id, author_id)
);

-- Self-referencing citation graph: a paper can cite other papers
CREATE TABLE citations (
    citing_paper_id INTEGER NOT NULL REFERENCES papers(paper_id),
    cited_paper_id  INTEGER NOT NULL REFERENCES papers(paper_id),
    PRIMARY KEY (citing_paper_id, cited_paper_id)
);

CREATE INDEX idx_paper_authors_paper  ON paper_authors(paper_id);
CREATE INDEX idx_paper_authors_author ON paper_authors(author_id);
CREATE INDEX idx_citations_citing     ON citations(citing_paper_id);
CREATE INDEX idx_citations_cited      ON citations(cited_paper_id);
