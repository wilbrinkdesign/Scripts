-- create SQL login in master database
CREATE LOGIN azureituser
WITH PASSWORD = 'password';

-- add database user for login testLogin1 => change to the correct database
CREATE USER azureituser
FROM LOGIN azureituser
WITH DEFAULT_SCHEMA=dbo;

-- add user to database role(s) (i.e. db_owner)
ALTER ROLE db_owner ADD MEMBER azureituser;
