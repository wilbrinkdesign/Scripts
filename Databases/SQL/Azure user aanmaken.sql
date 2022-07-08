-- create SQL auth login from master  
CREATE LOGIN user1 WITH PASSWORD = 'password' 
-- select your db in the dropdown and create a user mapped to a login  
CREATE USER user1 FOR LOGIN ictwodvwesql WITH DEFAULT_SCHEMA = dbo;  
-- add user to role(s) in db  
ALTER ROLE db_owner ADD MEMBER user1;   
