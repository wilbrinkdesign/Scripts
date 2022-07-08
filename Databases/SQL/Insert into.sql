SET IDENTITY_INSERT ittabletest ON
INSERT INTO ittabletest (id, hostname)
SELECT * FROM sccm_hosts
SET IDENTITY_INSERT ittabletest OFF
