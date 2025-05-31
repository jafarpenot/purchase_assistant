-- init_company.sql (for purchase_db)
-- (This is a minimal example; adjust as needed.)

-- (Optional) drop table if it exists (for re-initialization)
DROP TABLE IF EXISTS purchase;

-- Create a purchase table (for example, with an id, a product name, and a price)
CREATE TABLE purchase ( id SERIAL PRIMARY KEY, product_name TEXT NOT NULL, price DECIMAL NOT NULL );

-- (Optional) Insert a dummy row (for testing)
INSERT INTO purchase ( product_name, price ) VALUES ( 'Sample Product', 99.99 );

-- (Optional) (If you had a "\connect" or "\c" command, remove it or comment it out so that it does not try to connect to "app_db" (or any other DB) here.) 