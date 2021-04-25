------INDEX
--1.INDEX 조회
SELECT index_name,table_name,column_name
FROM user_ind_columns;
--2.INDEX 생성
CREATE INDEX idx_emp_name ON emp(ename);
-- 3. 조회
SELECT * FROM emp WHERE ename='SMITH';

----Optimizer
---1) RBO 2) CBO
--CBO여서 INDEX안탄거임 RBO로 바꾸면 규칙을 탐
ALTER SESSION SET OPTIMIZER_MODE=RULE;
ALTER SESSION SET OPTIMIZER_MODE=COST;
rollback;
-- 고유 INDEX
CREATE UNIQUE INDEX IDX_DEPT_DNO ON dept_second(deptno);


--결합 INDEX(복합키)
CREATE INDEX IDX_DEPT_COM ON dept_second(dname,loc);
--학생 테이블의 deptno와 name 칼럼으로 결합 인덱스를 생성하여라.
--단, deptno 칼럼을 내림차순으로 name 칼럼은 오름차순으로 생성하여라

CREATE INDEX idx_stud_no_name
       ON student (deptno DESC, name ASC);
       
-- FBI (Funtion Based Index)
CREATE INDEX IDX_EMP_ANNSAL
ON emp(sal*12+NVL(comm,0));

-- 1. 부서 테이블[department]에서 dname 칼럼을 고유 인덱스로 생성하여라. 
--    단  , 고유 인덱스의 이름을 idx_dept_name으로 정의
CREATE UNIQUE INDEX idx_dept_name ON department(dname);

-- 2.학생 테이블[student]의 birthdate 칼럼을 비고유 인덱스로 생성.
-- 비고유 인덱스의 이름은 idx_stud_birthdate로 정의
CREATE INDEX idx_stud_birthdate ON student(birthdate);

-- 3.학생 테이블[student]의 deptno, grade 칼럼을 결합 인덱스로 생성.
-- 결합 인덱스의 이름은 idx_stud_dno_grade 로 정의
CREATE INDEX idx_stud_dno_grade ON student(deptno,grade);

--4. emp 의 ename을 대문자로 인덱스의 이름은 uppercase_idx
CREATE INDEX uppercase_idx ON emp(UPPER(ename));

SELECT * FROM emp WHERE UPPER(ename) = 'KING';

-- 학생 테이블에 생성된 pk_studno 인덱스를 재구성
ALTER INDEX PK_STUDNO REBUILD;


-----  View 

-- View : 하나 이상의 기본 테이블이나 다른 뷰를 이용하여 생성되는 가상 테이블
--        뷰는 데이터딕셔너리 테이블에 뷰에 대한 정의만 저장
--        Performance(성능)은 더 저하 
--        목적 : 보안

CREATE VIEW VIEW_PROFESSOR AS
SELECT profno,name,userid,position,hiredate,deptno
FROM   professor;

SELECT * FROM VIEW_PROFESSOR;
INSERT INTO VIEW_PROFESSOR VALUES(2000,'view','userid','position' ,sysdate,101);
--뷰에 삽입되는게아니라 실제 professor테이블에 사입이된다.

CREATE OR REPLACE VIEW VIEW_PROFESSOR AS
SELECT profno,name,userid,position,deptno
FROM   professor;
--동일 뷰가 있으면 이렇게 교체하고 없다면 생성



CREATE OR REPLACE VIEW v_emp_sample
AS
SELECT empno,ename,job,mgr,deptno
FROm emp;

CREATE OR REPLACE VIEW v_emp_complex
AS
SELECT *
FROM emp NATURAL JOIN dept;

---문1)  학생 테이블에서 101번 학과 학생들의 학번, 이름, 학과 번호로 정의되는 단순 뷰를 생성
---     뷰 명 :  v_stud_dept101
CREATE VIEW v_stud_dept101 AS
SELECT studno,name,deptno
FROM student
WHERE deptno = 101;
--문2) 학생 테이블과 부서 테이블을 조인하여 102번 학과 학생들의 학번, 이름, 학년, 학과 이름으로 정의되는 복합 뷰를 생성
--      뷰 명 :   v_stud_dept102
CREATE VIEW v_stud_dept102 AS
SELECT studno,name,grade,dname
FROM student s ,department d
WHERE s.deptno = d.deptno 
AND d.deptno = 102;
--문3)  교수 테이블에서 학과별 평균 급여와     총계로 정의되는 뷰를 생성
--  뷰 명 :  v_prof_avg_sal       Column 명 :   avg_sal      sum_sal
CREATE VIEW v_prof_avg_sal AS
SELECT AVG(sal) as avg_sal, SUM(sal) as sum_sal
FROM professor
GROUP BY deptno;

-- 2. GROUP 함수 Column 등록안됨
INSERT INTO v_prof_avg_sal
VALUES(203,600,300);

SELECT view_name,text
FROM USER_views;

--View 삭제
DROP VIEW v_stud_dept102;



-----------------동의어 연습(420DCL에있음)
SELECT * FROM system.sampleTBL;
---전용 동의어 생성 (객체에 대한 접근 권한을 부여 받은 사용자가 정의한 동의어로 해당 사용자만 사용)
CREATE synonym priv_sampleTBL FOR system.sampleTBL;
--전용동의어 (여기 scott에서만 사용가능)
SELECT * FROM priv_sampleTBL;
--공용동의어 (시스템이 sampleTBL을 조회하는 권한을 준 모든 곳에서 사용가능)
SELECT * FROM pubSampleTBL;
--삭제
DROP SYNONYM 동의어이름;





-------TableSpace
--1.TableSpace생성
CREATE Tablespace user1 Datafile 'c:\tableSpace\user1.ora' SIZE 100M;
CREATE Tablespace user2 Datafile 'c:\tableSpace\user2.ora' SIZE 100M;
CREATE Tablespace user3 Datafile 'c:\tableSpace\user3.ora' SIZE 100M;
CREATE Tablespace user4 Datafile 'c:\tableSpace\user4.ora' SIZE 100M;

--1-2. TableSpace 재 할당 (100M가 다 쓰면 재할당해준다)
ALTER DATABASE DATAFILE 'c:\tableSpace\user2.ora' RESIZE 200M;

--2. TableSpace 조회
SELECT * FROM DBA_DATA_FILES;



-------계층적 질의문

-- 계층적 질의문을 사용하여 부서 테이블에서 학과,학부,단과대학을 검색하여 단대,학부
-- 학과순으로 top-down 형식의 계층 구조로 출력하여라. 단, 시작 데이터는 10번 부서

SELECT deptno,dname,college
FROM department
START WITH deptno =10
CONNECT BY PRIOR deptno = college;

-- 계층적 질의문을 사용하여 부서 테이블에서 학과,학부,단과대학을 검색하여 학과,학부
-- 단대 순으로 bottom-up 형식의 계층 구조로 출력하여라. 단, 시작 데이터는 102번 부서이다
SELECT deptno,dname,college
FROM department
START WITH deptno =102
CONNECT BY PRIOR college = deptno ;

--- 계층적 질의문을 사용하여 부서 테이블에서 부서 이름을 검색하여 단대, 학부, 학과순의
--- top-down 형식으로 출력하여라. 단, 시작 데이터는 ‘공과대학’이고,
--- 각 레벨별로 우측으로 2칸 이동하여 출력
SELECT LPAD(' ',(LEVEL-1)*2) || dname 조직도
FROM   department
START WITH dname = '공과대학'
CONNECT BY PRIOR deptno = college;

