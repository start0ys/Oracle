-- Scott Emp 조회
--권한 부여받아서 가능 아니면 불가능
SELECT * FROM scott.emp; 
--권한 부여받아서 권한도 줄수있음
GRANT SELECT on scott.emp TO usertest03