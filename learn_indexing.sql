
# resource: https://www.freecodecamp.org/news/database-indexing-at-a-glance-bb50809d48bd/


create database learn_indexing;

use learn_indexing;

CREATE TABLE index_demo(
    name VARCHAR(20) NOT NULL ,
    age INT,
    pan_no VARCHAR(20),
    phone_no VARCHAR(20)
);

SHOW TABLE STATUS WHERE name = 'index_demo';

INSERT INTO index_demo (name,age,pan_no,phone_no) VALUES
                                                      ('kousik',27,'IPOET0935V','9281920292'),
                                                      ('alex',26,'MNWTT0935V','9281748482'),
                                                      ('francis',20,'OPETV0915E','9281092482'),
                                                      ('tom',40,'OPETV8935E','9281072002'),
                                                      ('harry',50,'IEYTV8935E','0993372002');


SELECT * FROM index_demo;

SHOW index from index_demo;

EXPLAIN SELECT * FROM index_demo WHERE name = 'alex';

SHOW EXTENDED INDEX FROM index_demo;



# Note that CREATE INDEX can not be used to create a primary index,
# but ALTER TABLE is used.
ALTER TABLE index_demo ADD PRIMARY KEY (phone_no);


SHOW INDEXES FROM index_demo;

EXPLAIN SELECT * FROM index_demo WHERE phone_no = '9281072002';


SELECT * FROM index_demo WHERE phone_no > '9010000000' AND phone_no < '9020000000';

EXPLAIN SELECT * FROM index_demo WHERE phone_no > '9000000000' AND phone_no < '9020000000';



#When you delete a primary key,
# the related clustered index as well as
# the uniqueness property of that column gets lost.

ALTER TABLE `index_demo` DROP PRIMARY KEY;

#- If the primary key does not exist, you get the following error:
#"ERROR 1091 (42000): Can't DROP 'PRIMARY'; check that column/key exists"


####################SECONDARY INDEX#############################################

CREATE INDEX secondary_idx_1 ON index_demo (name);

SHOW INDEXES FROM index_demo;

############################UNIQUE KEY INDEX####################################

# Like primary keys, unique keys can also identify records uniquely with one difference
# — the unique key column can contain null values.
CREATE UNIQUE INDEX unique_idx_1 ON index_demo (pan_no);


SHOW INDEXES FROM index_demo;

###########################COMPOSITE INDEX######################################

CREATE INDEX composite_index_1 ON index_demo (phone_no, name, age);

CREATE INDEX composite_index_2 ON index_demo (pan_no, name, age);

SHOW INDEXES FROM index_demo;


#######################COVERING INDEX###########################################

# the query optimizer does not need to hit the database to get the data
# rather it gets the result from the index itself.
# Example: we have already defined a composite index on (pan_no, name, age)
# , so now consider the following query:

SELECT age FROM index_demo WHERE pan_no = 'IEYTV8935E' AND name = 'harry';

EXPLAIN SELECT age FROM index_demo WHERE pan_no = 'IEYTV8935E' AND name = 'harry';



EXPLAIN FORMAT=JSON SELECT age FROM index_demo
                               WHERE pan_no = 'IEYTV8935E' AND name = 'harry';

ALTER TABLE index_demo DROP INDEX secondary_idx_1;

##########################PARTIAL INDEX#######################################

# the following command creates an index on the first 4 bytes of name.
# Though this method reduces memory overhead by a certain amount,
# the index can’t eliminate many rows,
# since in this example the first 4 bytes may be common across many names.
# Usually this kind of prefix indexing is supported on
# CHAR ,VARCHAR, BINARY, VARBINARY type of columns.
CREATE INDEX secondary_index_1 ON index_demo (name(4));

SHOW EXTENDED INDEXES FROM index_demo;


