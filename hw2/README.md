## Database overview
This database, named sc_gene_study_v2, is designed based on the ER model created in Homework 1. It represents a study of gene expression using single-cell or bulk RNA sequencing technologies. The database includes entities such as biological samples, cells, genes, experiments, and researchers, and models their complex relationships. The implementation covers weak entities, many-to-many relationships, recursive relationships, overlapping and disjoint specialization, and union types.
## Tables and ER mapping
1.	Sample Table
(1)	Entity Type: Strong entity
  (2)	Attributes: sample_id (PK), sample_type, collected_at
  (3)	A sample represents a biological material (blood, tumor, or tissue) and serves as the origin of cells.
  (4)	A CHECK constraint is used to enforce valid sample types.
3.	Cell Table (Weak Entity)
(1)	Entity Type: Weak entity, dependent on Sample
(2)	Composite Key: (cell_id, sample_id)
(3)	Each cell exists within a sample and is uniquely identified by its local ID (cell_id) combined with the sample ID.
(4)	The design correctly models a weak entity with a composite primary key and a foreign key to Sample.
4.	Gene Table
(1)	Entity Type: Strong entity
(2)	Attributes: gene_id (PK), gene_name, gene_function, pathway
(3)	Additional attributes describe gene behavior and related biological pathways.
5.	Researcher Table
(1)	Entity Type: Strong entity with disjoint specialization
(2)	Attributes: researcher_id (PK), name, role, email, years_of_experience
(3)	The role attribute uses ENUM('PI', 'GraduateStudent') to implement disjoint specialization.
6.	Experiment Table
(1)	Entity Type: Strong entity with union type
(2)	Attributes: experiment_id (PK), method, experiment_type, conducted_at, platform, sample_count, objective, date_performed
(3)	The experiment_type enum distinguishes between Single-Cell and Bulk experiments.
6.	Expression Table
(1)	Relationship: Cell expresses Gene (M:N)
(2)	Composite Key: (cell_id, sample_id, gene_id)
(3)	Links each cell to genes it expresses with an associated expression level.
7.	Conducts Table
(1)	Relationship: Researcher conducts Experiment (M:N)
(2)	Composite Key: (researcher_id, experiment_id)
8.	Analyzes Table
(1)	Relationship: Experiment analyzes Sample (M:N)
(2)	Composite Key: (experiment_id, sample_id)
9.	Regulates Table
(1)	Recursive Relationship: Gene regulates Gene (M:N)
(2)	Includes source_gene_id, target_gene_id, and regulation_type (activation or inhibition).
10.	GeneCategory Table
(1)	Specialization (Overlapping): A gene may belong to multiple categories
(2)	Categories include: Oncogene, TumorSuppressor, and ImmuneRelated
## summmary
This ER diagram was originally created in Homework 1. In Homework 2, I implemented a simplified relational schema based on this diagram. Some composite attributes, such as Name, were implemented as single string fields. Multivalued attributes were converted to relational tables. Weak entity Cell was implemented using a composite key (cell_id, sample_id). All relationships—including recursive, M:N, and specialization—were fully translated into SQL tables with appropriate constraints.
