-- init_app.sql (for app_db)
-- (This is a minimal example; adjust as needed.)

-- (Optional) drop table if it exists (for re-initialization)
DROP TABLE IF EXISTS app_settings;

-- Create an app_settings table (for example, with an id, a setting name, and a value)
CREATE TABLE app_settings ( id SERIAL PRIMARY KEY, setting_name TEXT NOT NULL, setting_value TEXT NOT NULL );

-- (Optional) Insert a dummy row (for testing)
INSERT INTO app_settings ( setting_name, setting_value ) VALUES ( 'theme', 'dark' );

-- (Optional) (If you had a "\connect" or "\c" command, remove it or comment it out so that it does not try to connect to "purchase_db" (or any other DB) here.) 