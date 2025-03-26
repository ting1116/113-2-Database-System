/* create and use database */
CREATE DATABASE hw2_part1;
USE hw2_part1;

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

/* create table */
CREATE TABLE supplier (
    sid INT PRIMARY KEY,
    sname VARCHAR(255) NOT NULL
);

CREATE TABLE product (
    pid INT PRIMARY KEY,
    pname VARCHAR(255) NOT NULL,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES supplier(sid)
);

CREATE TABLE selling_price (
    pid INT PRIMARY KEY,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pid) REFERENCES product(pid)
);

CREATE TABLE stock (
    pid INT PRIMARY KEY,
    quantity INT NOT NULL,
    FOREIGN KEY (pid) REFERENCES product(pid)
);

CREATE TABLE price_change (
    pid INT PRIMARY KEY,
    new_price DECIMAL(10, 2) NOT NULL,
    change_date DATE NOT NULL,
    FOREIGN KEY (pid) REFERENCES product(pid)
);

/* insert sample data */
INSERT INTO supplier (sid, sname) VALUES
(1, 'Good_Quality'),
(2, 'Reliable_Supplies'),
(3, 'bad_sup'),
(4, 'low_quality'),
(5, 'unstable');

INSERT INTO product (pid, pname, supplier_id) VALUES
(101, 'xyz', 1),
(102, 'Cheddar Cheese', 2),
(103, 'Mozzarella Cheese', 2),
(104, 'Blue Cheese', 1),
(105, 'Milk', 1),
(106, 'Bread', 2),
(107, 'Product from bad_sup', 3),
(108, 'Product from low_quality', 4),
(109, 'Product from unstable', 5);

INSERT INTO selling_price (pid, price) VALUES
(101, 10.99),
(102, 5.49),
(103, 6.99),
(104, 7.99),
(105, 2.99),
(106, 3.49),
(107, 9.99),
(108, 4.99),
(109, 8.49);

INSERT INTO stock (pid, quantity) VALUES
(101, 50),
(102, 30),
(103, 40),
(104, 25),
(105, 100),
(106, 80),
(107, 10),
(108, 15),
(109, 20);

INSERT INTO price_change (pid, new_price, change_date) VALUES
(101, 11.49, '2005-04-01'),
(102, 5.99, '2005-04-01'),
(103, 7.49, '2005-04-01'),
(104, 8.49, '2005-04-01'),
(105, 3.29, '2005-04-01'),
(106, 3.99, '2005-04-01');

/* write your answer */
-- (1) write your answer statement here

SELECT p.pname, sp.price, st.quantity
FROM product AS p
JOIN selling_price AS sp ON p.pid = sp.pid
JOIN stock AS st ON p.pid = st.pid
WHERE p.pname = 'xyz';

-- (2) write your answer statement here

SELECT p.pname, sp.price, st.quantity
FROM product AS p
JOIN selling_price AS sp ON p.pid = sp.pid
JOIN stock AS st ON p.pid = st.pid
WHERE p.pname LIKE '%cheese%';

-- (3) write your answer statement here

UPDATE selling_price AS sp
JOIN price_change AS pc ON sp.pid = pc.pid
SET sp.price = pc.new_price;

-- (4) write your answer statement here

DELETE p
FROM product AS p
JOIN supplier AS s ON p.supplier_id = s.sid
WHERE s.sname IN ('bad_sup', 'low_quality', 'unstable');

-- (5) directly update the content of CREATE TABLE selling_price and CREATE TABLE stock

CREATE TABLE selling_price (
    pid INT PRIMARY KEY,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pid) REFERENCES product(pid) ON DELETE CASCADE
);

CREATE TABLE stock (
    pid INT PRIMARY KEY,
    quantity INT NOT NULL,
    FOREIGN KEY (pid) REFERENCES product(pid) ON DELETE CASCADE
);

/* drop database */
DROP DATABASE hw2_part1;
