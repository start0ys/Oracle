------INDEX
--1.INDEX ��ȸ
SELECT index_name,table_name,column_name
FROM user_ind_columns;
--2.INDEX ����
CREATE INDEX idx_emp_name ON emp(ename);
-- 3. ��ȸ
SELECT * FROM emp WHERE ename='SMITH';

----Optimizer
---1) RBO 2) CBO
--CBO���� INDEX��ź���� RBO�� �ٲٸ� ��Ģ�� Ž
ALTER SESSION SET OPTIMIZER_MODE=RULE;
ALTER SESSION SET OPTIMIZER_MODE=COST;
rollback;
-- ���� INDEX
CREATE UNIQUE INDEX IDX_DEPT_DNO ON dept_second(deptno);


--���� INDEX(����Ű)
CREATE INDEX IDX_DEPT_COM ON dept_second(dname,loc);
--�л� ���̺��� deptno�� name Į������ ���� �ε����� �����Ͽ���.
--��, deptno Į���� ������������ name Į���� ������������ �����Ͽ���

CREATE INDEX idx_stud_no_name
       ON student (deptno DESC, name ASC);
       
-- FBI (Funtion Based Index)
CREATE INDEX IDX_EMP_ANNSAL
ON emp(sal*12+NVL(comm,0));

-- 1. �μ� ���̺�[department]���� dname Į���� ���� �ε����� �����Ͽ���. 
--    ��  , ���� �ε����� �̸��� idx_dept_name���� ����
CREATE UNIQUE INDEX idx_dept_name ON department(dname);

-- 2.�л� ���̺�[student]�� birthdate Į���� ����� �ε����� ����.
-- ����� �ε����� �̸��� idx_stud_birthdate�� ����
CREATE INDEX idx_stud_birthdate ON student(birthdate);

-- 3.�л� ���̺�[student]�� deptno, grade Į���� ���� �ε����� ����.
-- ���� �ε����� �̸��� idx_stud_dno_grade �� ����
CREATE INDEX idx_stud_dno_grade ON student(deptno,grade);

--4. emp �� ename�� �빮�ڷ� �ε����� �̸��� uppercase_idx
CREATE INDEX uppercase_idx ON emp(UPPER(ename));

SELECT * FROM emp WHERE UPPER(ename) = 'KING';

-- �л� ���̺� ������ pk_studno �ε����� �籸��
ALTER INDEX PK_STUDNO REBUILD;


-----  View 

-- View : �ϳ� �̻��� �⺻ ���̺��̳� �ٸ� �並 �̿��Ͽ� �����Ǵ� ���� ���̺�
--        ��� �����͵�ųʸ� ���̺� �信 ���� ���Ǹ� ����
--        Performance(����)�� �� ���� 
--        ���� : ����

CREATE VIEW VIEW_PROFESSOR AS
SELECT profno,name,userid,position,hiredate,deptno
FROM   professor;

SELECT * FROM VIEW_PROFESSOR;
INSERT INTO VIEW_PROFESSOR VALUES(2000,'view','userid','position' ,sysdate,101);
--�信 ���ԵǴ°Ծƴ϶� ���� professor���̺� �����̵ȴ�.

CREATE OR REPLACE VIEW VIEW_PROFESSOR AS
SELECT profno,name,userid,position,deptno
FROM   professor;
--���� �䰡 ������ �̷��� ��ü�ϰ� ���ٸ� ����



CREATE OR REPLACE VIEW v_emp_sample
AS
SELECT empno,ename,job,mgr,deptno
FROm emp;

CREATE OR REPLACE VIEW v_emp_complex
AS
SELECT *
FROM emp NATURAL JOIN dept;

---��1)  �л� ���̺��� 101�� �а� �л����� �й�, �̸�, �а� ��ȣ�� ���ǵǴ� �ܼ� �並 ����
---     �� �� :  v_stud_dept101
CREATE VIEW v_stud_dept101 AS
SELECT studno,name,deptno
FROM student
WHERE deptno = 101;
--��2) �л� ���̺�� �μ� ���̺��� �����Ͽ� 102�� �а� �л����� �й�, �̸�, �г�, �а� �̸����� ���ǵǴ� ���� �並 ����
--      �� �� :   v_stud_dept102
CREATE VIEW v_stud_dept102 AS
SELECT studno,name,grade,dname
FROM student s ,department d
WHERE s.deptno = d.deptno 
AND d.deptno = 102;
--��3)  ���� ���̺��� �а��� ��� �޿���     �Ѱ�� ���ǵǴ� �並 ����
--  �� �� :  v_prof_avg_sal       Column �� :   avg_sal      sum_sal
CREATE VIEW v_prof_avg_sal AS
SELECT AVG(sal) as avg_sal, SUM(sal) as sum_sal
FROM professor
GROUP BY deptno;

-- 2. GROUP �Լ� Column ��Ͼȵ�
INSERT INTO v_prof_avg_sal
VALUES(203,600,300);

SELECT view_name,text
FROM USER_views;

--View ����
DROP VIEW v_stud_dept102;



-----------------���Ǿ� ����(420DCL������)
SELECT * FROM system.sampleTBL;
---���� ���Ǿ� ���� (��ü�� ���� ���� ������ �ο� ���� ����ڰ� ������ ���Ǿ�� �ش� ����ڸ� ���)
CREATE synonym priv_sampleTBL FOR system.sampleTBL;
--���뵿�Ǿ� (���� scott������ ��밡��)
SELECT * FROM priv_sampleTBL;
--���뵿�Ǿ� (�ý����� sampleTBL�� ��ȸ�ϴ� ������ �� ��� ������ ��밡��)
SELECT * FROM pubSampleTBL;
--����
DROP SYNONYM ���Ǿ��̸�;





-------TableSpace
--1.TableSpace����
CREATE Tablespace user1 Datafile 'c:\tableSpace\user1.ora' SIZE 100M;
CREATE Tablespace user2 Datafile 'c:\tableSpace\user2.ora' SIZE 100M;
CREATE Tablespace user3 Datafile 'c:\tableSpace\user3.ora' SIZE 100M;
CREATE Tablespace user4 Datafile 'c:\tableSpace\user4.ora' SIZE 100M;

--1-2. TableSpace �� �Ҵ� (100M�� �� ���� ���Ҵ����ش�)
ALTER DATABASE DATAFILE 'c:\tableSpace\user2.ora' RESIZE 200M;

--2. TableSpace ��ȸ
SELECT * FROM DBA_DATA_FILES;



-------������ ���ǹ�

-- ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �а�,�к�,�ܰ������� �˻��Ͽ� �ܴ�,�к�
-- �а������� top-down ������ ���� ������ ����Ͽ���. ��, ���� �����ʹ� 10�� �μ�

SELECT deptno,dname,college
FROM department
START WITH deptno =10
CONNECT BY PRIOR deptno = college;

-- ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �а�,�к�,�ܰ������� �˻��Ͽ� �а�,�к�
-- �ܴ� ������ bottom-up ������ ���� ������ ����Ͽ���. ��, ���� �����ʹ� 102�� �μ��̴�
SELECT deptno,dname,college
FROM department
START WITH deptno =102
CONNECT BY PRIOR college = deptno ;

--- ������ ���ǹ��� ����Ͽ� �μ� ���̺��� �μ� �̸��� �˻��Ͽ� �ܴ�, �к�, �а�����
--- top-down �������� ����Ͽ���. ��, ���� �����ʹ� ���������С��̰�,
--- �� �������� �������� 2ĭ �̵��Ͽ� ���
SELECT LPAD(' ',(LEVEL-1)*2) || dname ������
FROM   department
START WITH dname = '��������'
CONNECT BY PRIOR deptno = college;

