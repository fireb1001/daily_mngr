USE shader_demo;
START TRANSACTION;

TRUNCATE TABLE cashflow;
TRUNCATE TABLE customers;
TRUNCATE TABLE customer_trans;
TRUNCATE TABLE incomings;
TRUNCATE TABLE incomings_header;
TRUNCATE TABLE outgoings;
TRUNCATE TABLE outgoings_header;
TRUNCATE TABLE products;
TRUNCATE TABLE receipts;
TRUNCATE TABLE receipts_details;
TRUNCATE TABLE suppliers;
TRUNCATE TABLE supplier_trans;


COMMIT;
