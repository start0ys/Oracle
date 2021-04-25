--- Admin 사용자 생성 / 권한 부여
-- 1-1. USER 생성
CREATE USER usertest01 IDENTIFIED BY tiger;
CREATE USER usertest02 IDENTIFIED BY tiger;
CREATE USER usertest03 IDENTIFIED BY tiger;
CREATE USER usertest04 IDENTIFIED BY tiger;
-- 2-1. sesstion 권한 부여
GRANT CREATE session to usertest01;
GRANT CREATE session , CREATE table , CREATE VIEW to usertest02;
GRANT CREATE session , CREATE table , CREATE VIEW to usertest03;
-- 2-2. 현장에서 DBA가 개발자에게 권한부여 (실제)--롤
GRANT CONNECT , RESOURCE to usertest04;
-- 2-3. 현 SELECT 권한 부여 개발자에게 권한부여
GRANT SELECT on scott.emp TO usertest02 WITH GRANT OPTION;
-- 3.Table 생성 권한 부여
GRANT CREATE table to usertest01;
-- 4.Table Space 영역 할당 (코드아님 다음에 다시함)
ALTER USER usertest01 quota 2m on user;





-- Scott Emp 조회
SELECT * FROM emp; --안돼
SELECT * FROM scott.emp; --돼




-------------------------------------------------------------
--- EXAM
------------------------------------------------
--  1. tiger/tiger 계정 생성
CREATE USER tiger IDENTIFIED BY tiger;
-- 2.권한 부여 ROLE --> connect, Resource
GRANT connect, Resource TO tiger;
-- 3. scott에 있는 student TBL에 Read 권한 tiger 주세요
GRANT SELECT on scott.student TO tiger;

---- 권한 회수
REVOKE SELECT on scott.student FROM tiger;
--usertest02가 권한 준 녀석들도 다 권한 회수
REVOKE SELECT on scott.emp FROM usertest02 CASCADE CONSTRAINTS;



-----------동의어
--동의어와 별명(Alias) 차이점
--동의어는 데이터베이스 전체에서 사용할 수 있는 객체
--별명은 해당 SQL 명령문에서만 사용

CREATE TABLE sampleTBL(
    meno VARCHAR2(50)
    );
INSERT INTO sampleTBL VALUES('오월 푸름');    
INSERT INTO sampleTBL VALUES('결실을 맺으리라');

GRANT SELECT on sampleTBL TO scott;










