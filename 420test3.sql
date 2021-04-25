--이거는 test2에서 권한받아서 가능
SELECT * FROM scott.emp; 
--이거는 권한받지못햇음 WITH GRANT OPTION
GRANT SELECT on scott.emp TO usertest04