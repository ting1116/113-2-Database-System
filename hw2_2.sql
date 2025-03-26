/* create and use database */
DROP DATABASE IF EXISTS sc_gene_study_v2;
CREATE DATABASE sc_gene_study_v2;
USE sc_gene_study_v2;

/* info */
CREATE TABLE self (
    StuID varchar(10) NOT NULL,
    Department varchar(10) NOT NULL,
    SchoolYear int DEFAULT 1,
    Name varchar(10) NOT NULL,
    PRIMARY KEY (StuID)
);

INSERT INTO self
VALUES ('r00000000', '000', 0, 'yu-ting');

SELECT DATABASE();
SELECT * FROM self;



CREATE TABLE Sample (
    sample_id INT PRIMARY KEY,
    sample_type VARCHAR(50) NOT NULL,
    collected_at DATE NOT NULL,
    CHECK (sample_type IN ('blood', 'tumor', 'tissue'))
);

CREATE TABLE Cell (
    cell_id INT,
    sample_id INT,
    cell_type VARCHAR(50) DEFAULT 'unspecified',
    CHECK (cell_type IN ('T-cell', 'B-cell', 'NK-cell', 'other')),
    PRIMARY KEY (cell_id, sample_id),  --  composite key
    FOREIGN KEY (sample_id) REFERENCES Sample(sample_id) ON DELETE CASCADE
);

CREATE TABLE Gene (
    gene_id VARCHAR(20) PRIMARY KEY,
    gene_name VARCHAR(100) NOT NULL,
    gene_function TEXT,
    pathway VARCHAR(100)
);

CREATE TABLE Researcher (
    researcher_id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    role ENUM('PI', 'GraduateStudent') NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    years_of_experience INT DEFAULT 0,
    CHECK (years_of_experience >= 0)
);

CREATE TABLE Experiment (
    experiment_id INT PRIMARY KEY,
    method VARCHAR(100) NOT NULL,
    experiment_type ENUM('Single-Cell', 'Bulk') NOT NULL,
    conducted_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    platform VARCHAR(100),
    sample_count INT DEFAULT 0,
    objective TEXT,
    date_performed DATE,
    CHECK (sample_count >= 0)
);

CREATE TABLE Expression (
    cell_id INT,
    sample_id INT,
    gene_id VARCHAR(20),
    expression_level DECIMAL(5,2) DEFAULT 0.00,
    PRIMARY KEY (cell_id, sample_id, gene_id),  --  composite key
    FOREIGN KEY (cell_id, sample_id) REFERENCES Cell(cell_id, sample_id) ON DELETE CASCADE,
    FOREIGN KEY (gene_id) REFERENCES Gene(gene_id) ON DELETE CASCADE
);

CREATE TABLE Conducts (
    researcher_id INT,
    experiment_id INT,
    PRIMARY KEY (researcher_id, experiment_id),
    FOREIGN KEY (researcher_id) REFERENCES Researcher(researcher_id),
    FOREIGN KEY (experiment_id) REFERENCES Experiment(experiment_id)
);

CREATE TABLE Analyzes (
    experiment_id INT,
    sample_id INT,
    PRIMARY KEY (experiment_id, sample_id),
    FOREIGN KEY (experiment_id) REFERENCES Experiment(experiment_id),
    FOREIGN KEY (sample_id) REFERENCES Sample(sample_id)
);

CREATE TABLE Regulates (
    source_gene_id VARCHAR(20),
    target_gene_id VARCHAR(20),
    regulation_type ENUM('activation', 'inhibition'),
    PRIMARY KEY (source_gene_id, target_gene_id),
    FOREIGN KEY (source_gene_id) REFERENCES Gene(gene_id),
    FOREIGN KEY (target_gene_id) REFERENCES Gene(gene_id)
);

CREATE TABLE GeneCategory (
    gene_id VARCHAR(20),
    category ENUM('Oncogene', 'TumorSuppressor', 'ImmuneRelated'),
    PRIMARY KEY (gene_id, category),
    FOREIGN KEY (gene_id) REFERENCES Gene(gene_id)
);


/* insert */
INSERT INTO Sample VALUES
(1, 'blood', '2025-03-01'),
(2, 'tumor', '2025-03-02'),
(3, 'tissue', '2025-03-03');

INSERT INTO Cell VALUES
(1, 1, 'T-cell'),    -- Cell 1 in Sample 1
(2, 1, 'B-cell'),    -- Cell 2 in Sample 1
(1, 2, 'NK-cell');   -- Cell 1 in Sample 2 → same cell_id with different sample_id → weak-entity

INSERT INTO Gene VALUES
('G1', 'TP53', 'Tumor suppressor gene involved in cell cycle regulation', 'p53 signaling pathway'),
('G2', 'BRCA1', 'DNA repair associated gene', 'Homologous recombination'),
('G3', 'PDCD1', 'Immune checkpoint regulator', 'T cell receptor signaling pathway'),
('G4', 'CD8A', 'Involved in cytotoxic T cell activity', 'T cell receptor signaling pathway');

INSERT INTO Researcher VALUES
(1, 'Dr. Chen', 'PI', 'chen@ntu.edu.tw', 15),
(2, 'Yu-Ting Weng', 'GraduateStudent', 'r13631016@ntu.edu.tw', 2),
(3, 'Vicky Lin', 'GraduateStudent', 'vickyyyy@ntu.edu.tw', 3);

INSERT INTO Experiment VALUES
(1, 'Smart-seq2', 'Single-Cell', '2025-03-10', 'Illumina NovaSeq', 2, 'Profile gene expression in blood cells', '2025-03-09'),
(2, '10X Genomics', 'Single-Cell', '2025-03-11', 'Chromium X', 3, 'Single-cell transcriptomics of tumor samples', '2025-03-10'),
(3, 'Bulk RNA-seq', 'Bulk', '2025-03-12', 'HiSeq 4000', 1, 'Bulk RNA profiling as control group', '2025-03-11'),
(4, 'CITE-seq', 'Single-Cell', '2025-03-13', 'Chromium Next GEM', 4, 'Analyze immune cell surface markers and transcriptome', '2025-03-12');

INSERT INTO Expression VALUES
(1, 1, 'G1', 5.21),   -- Cell 1 in Sample 1 express G1
(2, 1, 'G2', 3.44),   -- Cell 2 in Sample 1 express G2
(1, 2, 'G3', 2.10);   -- Cell 1 in Sample 2 express G3

INSERT INTO Conducts VALUES
(1, 1),
(2, 1),
(3, 2);

INSERT INTO Analyzes VALUES
(1, 1),
(1, 2),
(2, 3);

INSERT INTO Regulates VALUES
('G1', 'G2', 'activation'),
('G2', 'G3', 'inhibition');

INSERT INTO GeneCategory VALUES
('G1', 'Oncogene'),
('G1', 'TumorSuppressor'),
('G2', 'ImmuneRelated');


/* create two views */
CREATE VIEW view_expression_details AS
SELECT c.cell_id, c.sample_id, c.cell_type, g.gene_name, e.expression_level
FROM Expression e
JOIN Cell c ON e.cell_id = c.cell_id AND e.sample_id = c.sample_id
JOIN Gene g ON e.gene_id = g.gene_id;

CREATE VIEW view_experiment_summary AS
SELECT r.name AS researcher_name, r.role, ex.experiment_id, ex.method, ex.platform
FROM Researcher r
JOIN Conducts c ON r.researcher_id = c.researcher_id
JOIN Experiment ex ON c.experiment_id = ex.experiment_id;


/* select from all tables and views */
SELECT * FROM Sample;
SELECT * FROM Cell;
SELECT * FROM Gene;
SELECT * FROM Researcher;
SELECT * FROM Experiment;
SELECT * FROM Expression;
SELECT * FROM Conducts;
SELECT * FROM Analyzes;
SELECT * FROM Regulates;
SELECT * FROM GeneCategory;
SELECT * FROM view_expression_details;
SELECT * FROM view_experiment_summary;


/* drop database */
DROP DATABASE sc_gene_study_v2;
