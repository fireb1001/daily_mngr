USE daily_mngr;
START TRANSACTION;

TRUNCATE TABLE cashflow;
TRUNCATE TABLE customer_trans;
TRUNCATE TABLE customers;
TRUNCATE TABLE incomings;
TRUNCATE TABLE incomings_header;
TRUNCATE TABLE outgoings;
TRUNCATE TABLE outgoings_header;
TRUNCATE TABLE supplier_trans;
TRUNCATE TABLE suppliers;
TRUNCATE TABLE receipts;
TRUNCATE TABLE receipts_details;

COMMIT;
