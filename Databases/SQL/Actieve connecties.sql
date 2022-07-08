-- Connecties 1 database
USE master
SELECT * FROM sys.sysprocesses WHERE dbid = DB_ID('dbnaam')

-- Alle connecties van alle user databases
USE master
SELECT spid, loginame, hostname, program_name, login_time, dbid FROM sys.sysprocesses WHERE dbid NOT IN (DB_ID('master'),DB_ID('model'),DB_ID('msdb'),DB_ID('tempdb'))


USE [master];

DECLARE @kill varchar(8000) = '';  
SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
FROM sys.dm_exec_sessions
--WHERE database_id  = db_id('dbnaam')

EXEC(@kill);
