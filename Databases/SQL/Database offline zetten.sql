-- Verkrijg de actieve connecties
USE master
SELECT * FROM sys.sysprocesses WHERE dbid = DB_ID('dbnaam')

-- Dit is de normale manier om een database offline te halen, krijg je een fout, kill dan het proces
USE master
GO
ALTER DATABASE ICT_TEST
SET OFFLINE WITH ROLLBACK IMMEDIATE
GO

USE master
GO
ALTER DATABASE dbnaam
SET ONLINE
GO

-- Dit is de keiharde manier als de ALTER DATABASE fuctie niet werkt
KILL <SPID>
