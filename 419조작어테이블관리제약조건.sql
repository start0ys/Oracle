---------DEAD LOCK-----
--Transaction  A : Smith
UPDATE emp
SET sal = sal * 1.1
WHERE empno = 7369;

UPDATE emp
SET sat = sal * 1.1
WHERE empno = 7839;

--Transaction  B : King
UPDATE emp
SET comm = 500
WHERE empno = 7839;

UPDATE emp
SET comm = 300
WHERE empno = 7369;

-------------------DML-----

---INSERT
INSERT INTO dept VALUES (11,'인사','이대');
INSERT INTO dept(deptno,dname,loc) VALUES (51,'회계팀','충청로');
INSERT INTO dept(deptno,loc) VALUES (52,'홍대');
INSERT INTO professor (profno,name,position,hiredate,deptno)
VALUES (9920,'최윤식','조교수',TO_DATE('2006/01/01','YYYY/MM/DD'),102);
INSERT INTO professor (profno,name,position,hiredate,deptno)
VALUES (9910,'백미선','전임강사',sysdate,101);

CREATE TABLE JOB
( JOBno   VARCHAR2(2) CONSTRAINT PK_JOB3 PRIMARY KEY,
  JOBNAME VARCHAR2(20) );

CREATE TABLE Religion
( Religionno   VARCHAR2(2) CONSTRAINT PK_ReligionNo3 PRIMARY KEY,
  ReligionNAME VARCHAR2(20) );
  

INSERT INTO Religion
VALUES('10','기독교');
INSERT INTO Religion
VALUES('20','카톨릭교');
INSERT INTO Religion
VALUES('30','불교');
INSERT INTO Religion
VALUES('40','무교');

-- 1.생성된 TBL이용 신규 TBL 생성
CREATE TABLE dept_second
AS SELECT * FROM dept;  --제약조건이나 키값은 복사안되고 따로 지정해줘야함
-- 2. 가공 생성
CREATE TABLE emp20
AS SELECT empno, ename, sal*12 annsal
   FROM   emp
   WHERE  deptno = 20;
--3. TBL구조만
CREATE TABLE dept30
AS SELECT deptno,dname
   FROM   dept
   WHERE  0 = 1;
--4. Column추가
ALTER TABLE dept30
ADD (birth Date);
--5. Column변경
ALTER TABLE dept30
Modify dname varchar2(30);  
--기존데이터보다 적게는 안됨 ex 30크기의 데이터가 있을떄 40으로 변경가능 20으로 불가능
--6. Column삭제
ALTER TABLE dept30
Drop Column birth;  
--7. TBL 명 변경
RENAME dept30 TO dept35;
--8. TBL 명 제거
DROP TABLE dept35;
--9. Truncate
TRUNCATE TABLE dept_second;

CREATE TABLE height_info
( studNo   NUMBER(5) ,
  NAME     VARCHAR2(20),
  height   NUMBER(5,2));
  
CREATE TABLE weight_info
( studNo   NUMBER(5) ,
  NAME     VARCHAR2(20),
  weight   NUMBER(5,2));

INSERT ALL
INTO height_info VALUES(studNO,name,height)
INTO weight_info VALUES(studNO,name,weight)
SELECT studno,name,height,weight
FROM student
WHERE grade >=2;

DELETE height_info;
DELETE weight_info;
--학생 테이블에서 2학년 이상의 학생을 검색하여 
--height_info 테이블에는 키가 170보다 큰 학생의 학번, 이름, 키를 입력하고 
--weight_info 테이블에는 몸무게가 70보다 큰 학생의 학번, 이름, 몸무게를 각각 입력하여라

INSERT ALL
WHEN height > 170 Then
     INTO height_info VALUES(studNO,name,height)
WHEN weight > 70 Then    
     INTO weight_info VALUES(studNO,name,weight)
SELECT studno,name,height,weight
FROM student
WHERE grade >=2;

---- UPDATE
-- 교수 번호가 9903인 교수의 현재 직급을 '부교수;로 수정하여라
UPDATE professor
SET    position = '부교수'
WHERE  profno   = 9903; --where 은 보통 pk로 해줘야 좋음

--서브쿼리를 이용하여 학번이 10201인 학생의 학년과 학과 번호를 10103 학번 학생의 학년과 학과 번호와 동일하게 수정하여라
UPDATE student
SET (grade,deptno) = (SELECT grade,deptno
                      FROM   student
                      WHERE  studno = 10103)
WHERE studno =10201;     

---- DELETE
-- 학생 테이블에서 학번이 99999인 학생의 데이터를 삭제
DELETE 
FROM  student
WHERE studno = 99999;
--학생 테이블에서 컴퓨터공학과에 소속된 학생을 모두 삭제하여라.
DELETE student --FROM생략가능
WHERE deptno = (SELECT deptno
                FROM department
                WHERE dname = '컴퓨터공학과');

ROLLBACK; --복구         

---- MERGE
CREATE TABLE professor_temp
as SELECT * FROM professor WHERE position = '교수';

UPDATE professor_temp
SET position = '명예교수'
WHERE position = '교수';

INSERT INTO professor_temp
VALUES (9999,'김도경','arom21','전임강사',200,sysdate,10,101);

-- MERGE 개요
-- 구조가 같은 두개의 테이블을 비교하여 하나의 테이블로 합치기 위한 데이터 조작어
-- WHEN 절의 조건절에서 결과 테이블에 해당 행이 존재하면 UPDATE 명령문에 의해 새로운 값으로 수정,
-- 그렇지 않으면 INSERT 명령문으로 새로운 행을 삽입
-- 현재 상황
-- 1) 교수가 명예교수로 2행 Update
-- 2) 김도경 씨가 신규 Insert

-- 3. Merge
MERGE INTO professor p
USING professor_temp f
ON   (p.profno = f.profno)
when matched then       -- PK가 같으면 직위를 Update
    update set p.position = f.position
when not matched then   -- PK가 없으면 신규 Insert
    insert values (f.profno, f.name, f.userid, f.position, f.sal, f.hiredate,
                   f.comm, f.deptno);
                   

---- SEQUENCE
CREATE SEQUENCE dno_seq
INCREMENT BY 10
START WITH 10;

-- Data 사전에서 정보 조회
SELECT sequence_name, min_value,max_value, increment_by
FROM user_sequences;

SELECT sample_seq.nextval FROM dual; --다음값
SELECT sample_seq.CURRVAL FROM dual; --현재값

INSERT INTO dept_second
VALUES(dno_seq.nextval,'Accounting','NEW YORK');

INSERT INTO dept_second
VALUES(dno_seq.nextval,'회계','이대');

INSERT INTO dept_second
VALUES(dno_seq.nextval,'인사팀','당산');

SELECT dno_seq.CURRVAL FROM dual; --현재값

DROP SEQUENCE sample_seq;

CREATE TABLE address
( id    NUMBER(3) ,
  Name  VARCHAR2(50),
  addr  VARCHAR2(100) ,
  phone  VARCHAR2(30), 
  email  VARCHAR2(100) );
  
INSERT INTO ADDRESS
VALUES (1,'HGDONG','SEOUL','123-4567','gdhong@naver.com');

CREATE TABLE addr_second(id,name,addr,phone,email)
AS select * from address;

CREATE TABLE addr_fourth(id,name,addr,phone,email)
AS select * from address
WHERE 1=2;

-- 주소록 테이블에서 id, name 칼럼만 복사하여 addr_third 테이블을 생성하여라
CREATE TABLE addr_third 
AS select id,name from address;
--default를 하면 따로 지정하지않아도 정해진 값이 자동으로 입력된다
ALTER TABLE address
ADD (comments VARCHAR2(200) DEFAULT 'BASIC Comments');

ALTER TABLE address 
DROP Column comments;

RENAME addr_second TO addr_tmp;

DROP TABLE addr_third;
--협업할때 comments중요
COMMENT ON TABLE address
IS '고객 주소록';
COMMENT ON COLUMN address.name
IS '고객 이름';
--테이블 이름과 테이블 주인 찾기
SELECT table_name FROM user_tables;
SELECT owner,table_name FROM all_tables WHERE owner='SCOTT';

------------제약조건
CREATE TABLE subject (
subno NUMBER(5) CONSTRAINT subject_no_pk PRIMARY KEY,
subname VARCHAR2(20) CONSTRAINT subject_name_nn NOT NULL,
term VARCHAR2(1) CONSTRAINT subject_term_ck CHECK(term IN ('1','2')));

ALTER TABLE student
ADD CONSTRAINT stud_idnum_uk UNIQUE(idnum);

ALTER TABLE student
MODIFY(name CONSTRAINT stud_idnum_nn NOT NULL);

ALTER TABLE student
MODIFY(idnum CONSTRAINT stud_idnum_ukn UNIQUE);

-- CONSTRAINT 조회
SELECT CONSTRAINT_name , CONSTRAINT_Type
FROM user_CONSTRAINTS
WHERE table_name = 'SUBJECT';

SELECT CONSTRAINT_name , CONSTRAINT_Type
FROM user_CONSTRAINTS
WHERE LOWER(table_name) = 'subject';

SELECT CONSTRAINT_name , CONSTRAINT_Type
FROM user_CONSTRAINTS
WHERE table_name IN ('SUBJECT','STUDENT');
