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
INSERT INTO dept VALUES (11,'�λ�','�̴�');
INSERT INTO dept(deptno,dname,loc) VALUES (51,'ȸ����','��û��');
INSERT INTO dept(deptno,loc) VALUES (52,'ȫ��');
INSERT INTO professor (profno,name,position,hiredate,deptno)
VALUES (9920,'������','������',TO_DATE('2006/01/01','YYYY/MM/DD'),102);
INSERT INTO professor (profno,name,position,hiredate,deptno)
VALUES (9910,'��̼�','���Ӱ���',sysdate,101);

CREATE TABLE JOB
( JOBno   VARCHAR2(2) CONSTRAINT PK_JOB3 PRIMARY KEY,
  JOBNAME VARCHAR2(20) );

CREATE TABLE Religion
( Religionno   VARCHAR2(2) CONSTRAINT PK_ReligionNo3 PRIMARY KEY,
  ReligionNAME VARCHAR2(20) );
  

INSERT INTO Religion
VALUES('10','�⵶��');
INSERT INTO Religion
VALUES('20','ī�縯��');
INSERT INTO Religion
VALUES('30','�ұ�');
INSERT INTO Religion
VALUES('40','����');

-- 1.������ TBL�̿� �ű� TBL ����
CREATE TABLE dept_second
AS SELECT * FROM dept;  --���������̳� Ű���� ����ȵǰ� ���� �����������
-- 2. ���� ����
CREATE TABLE emp20
AS SELECT empno, ename, sal*12 annsal
   FROM   emp
   WHERE  deptno = 20;
--3. TBL������
CREATE TABLE dept30
AS SELECT deptno,dname
   FROM   dept
   WHERE  0 = 1;
--4. Column�߰�
ALTER TABLE dept30
ADD (birth Date);
--5. Column����
ALTER TABLE dept30
Modify dname varchar2(30);  
--���������ͺ��� ���Դ� �ȵ� ex 30ũ���� �����Ͱ� ������ 40���� ���氡�� 20���� �Ұ���
--6. Column����
ALTER TABLE dept30
Drop Column birth;  
--7. TBL �� ����
RENAME dept30 TO dept35;
--8. TBL �� ����
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
--�л� ���̺��� 2�г� �̻��� �л��� �˻��Ͽ� 
--height_info ���̺��� Ű�� 170���� ū �л��� �й�, �̸�, Ű�� �Է��ϰ� 
--weight_info ���̺��� �����԰� 70���� ū �л��� �й�, �̸�, �����Ը� ���� �Է��Ͽ���

INSERT ALL
WHEN height > 170 Then
     INTO height_info VALUES(studNO,name,height)
WHEN weight > 70 Then    
     INTO weight_info VALUES(studNO,name,weight)
SELECT studno,name,height,weight
FROM student
WHERE grade >=2;

---- UPDATE
-- ���� ��ȣ�� 9903�� ������ ���� ������ '�α���;�� �����Ͽ���
UPDATE professor
SET    position = '�α���'
WHERE  profno   = 9903; --where �� ���� pk�� ����� ����

--���������� �̿��Ͽ� �й��� 10201�� �л��� �г�� �а� ��ȣ�� 10103 �й� �л��� �г�� �а� ��ȣ�� �����ϰ� �����Ͽ���
UPDATE student
SET (grade,deptno) = (SELECT grade,deptno
                      FROM   student
                      WHERE  studno = 10103)
WHERE studno =10201;     

---- DELETE
-- �л� ���̺��� �й��� 99999�� �л��� �����͸� ����
DELETE 
FROM  student
WHERE studno = 99999;
--�л� ���̺��� ��ǻ�Ͱ��а��� �Ҽӵ� �л��� ��� �����Ͽ���.
DELETE student --FROM��������
WHERE deptno = (SELECT deptno
                FROM department
                WHERE dname = '��ǻ�Ͱ��а�');

ROLLBACK; --����         

---- MERGE
CREATE TABLE professor_temp
as SELECT * FROM professor WHERE position = '����';

UPDATE professor_temp
SET position = '������'
WHERE position = '����';

INSERT INTO professor_temp
VALUES (9999,'�赵��','arom21','���Ӱ���',200,sysdate,10,101);

-- MERGE ����
-- ������ ���� �ΰ��� ���̺��� ���Ͽ� �ϳ��� ���̺�� ��ġ�� ���� ������ ���۾�
-- WHEN ���� ���������� ��� ���̺� �ش� ���� �����ϸ� UPDATE ��ɹ��� ���� ���ο� ������ ����,
-- �׷��� ������ INSERT ��ɹ����� ���ο� ���� ����
-- ���� ��Ȳ
-- 1) ������ �������� 2�� Update
-- 2) �赵�� ���� �ű� Insert

-- 3. Merge
MERGE INTO professor p
USING professor_temp f
ON   (p.profno = f.profno)
when matched then       -- PK�� ������ ������ Update
    update set p.position = f.position
when not matched then   -- PK�� ������ �ű� Insert
    insert values (f.profno, f.name, f.userid, f.position, f.sal, f.hiredate,
                   f.comm, f.deptno);
                   

---- SEQUENCE
CREATE SEQUENCE dno_seq
INCREMENT BY 10
START WITH 10;

-- Data �������� ���� ��ȸ
SELECT sequence_name, min_value,max_value, increment_by
FROM user_sequences;

SELECT sample_seq.nextval FROM dual; --������
SELECT sample_seq.CURRVAL FROM dual; --���簪

INSERT INTO dept_second
VALUES(dno_seq.nextval,'Accounting','NEW YORK');

INSERT INTO dept_second
VALUES(dno_seq.nextval,'ȸ��','�̴�');

INSERT INTO dept_second
VALUES(dno_seq.nextval,'�λ���','���');

SELECT dno_seq.CURRVAL FROM dual; --���簪

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

-- �ּҷ� ���̺��� id, name Į���� �����Ͽ� addr_third ���̺��� �����Ͽ���
CREATE TABLE addr_third 
AS select id,name from address;
--default�� �ϸ� ���� ���������ʾƵ� ������ ���� �ڵ����� �Էµȴ�
ALTER TABLE address
ADD (comments VARCHAR2(200) DEFAULT 'BASIC Comments');

ALTER TABLE address 
DROP Column comments;

RENAME addr_second TO addr_tmp;

DROP TABLE addr_third;
--�����Ҷ� comments�߿�
COMMENT ON TABLE address
IS '�� �ּҷ�';
COMMENT ON COLUMN address.name
IS '�� �̸�';
--���̺� �̸��� ���̺� ���� ã��
SELECT table_name FROM user_tables;
SELECT owner,table_name FROM all_tables WHERE owner='SCOTT';

------------��������
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

-- CONSTRAINT ��ȸ
SELECT CONSTRAINT_name , CONSTRAINT_Type
FROM user_CONSTRAINTS
WHERE table_name = 'SUBJECT';

SELECT CONSTRAINT_name , CONSTRAINT_Type
FROM user_CONSTRAINTS
WHERE LOWER(table_name) = 'subject';

SELECT CONSTRAINT_name , CONSTRAINT_Type
FROM user_CONSTRAINTS
WHERE table_name IN ('SUBJECT','STUDENT');
