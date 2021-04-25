 CREATE TABLE "SCOTT"."EMP5" 
   (	"EMPNO" NUMBER(4,0), 
        "ENAME" VARCHAR2(10 BYTE),    
    	"DEPTNO" NUMBER(2,0), 
        "DEPTName" VARCHAR2(10 BYTE)
    );
    
Drop table EMP5;
 CREATE TABLE "SCOTT"."SALGRADE2" 
   (	"GRADE" NUMBER(2,0), 
	"LOSAL" NUMBER(5,0), 
	"HISAL" NUMBER(5,0)
);
--------------------------����--------------------

-- �й��� 10101�� �л��� �̸��� �Ҽ� �а� �̸��� ����϶�
SELECT studno,name,deptno
FROM student
WHERE studno = 10101;

-- �а��� ������ �а��̸�
SELECT dname
FROM department
WHERE deptno = 101;

-- ������ �̿��� �л��̸��� �а��̸� �˻�
SELECT studno,name,student.deptno,department.dname
FROM student ,department 
WHERE student.deptno = department.deptno;

-- �ָŸ�ȣ�� ambiguously 
-- �ΰ��� ���̺� �ߺ��� �÷��� ��� ���̺��� �÷����� �˷����������� �������߻�
SELECT studno,name,deptno,dname
FROM student ,department 
WHERE student.deptno = department.deptno;

-- ���� (alias) ������̺��� �÷����� �� ���ִ°� ����
SELECT s.studno,s.name,d.deptno,d.dname
FROM student s,department d
WHERE s.deptno = d.deptno;

-- ������ �л��� �й�,�̸�,�а� �̸� �׸��� �а� ��ġ�� ���
SELECT s.studno, s.name, d.dname, d.loc
FROM student s ,department d
WHERE s.deptno=d.deptno 
AND s.name = '������';

-- �����԰� 80kg�̻��� �л��� �й�, �̸�, ü��, �а� �̸�, �а���ġ�� ���
SELECT s.studno, s.name, s.weight, d.dname, d.loc
FROM student s ,department d
WHERE s.deptno=d.deptno
AND s.weight >= 80;

-- īƼ�� �� �� �� �̻��� ���̺� ���� ���� ������ ���� ��� ����
-- student Ʃ�ü� 16 departmane Ʃ�� �� 7 ī��� �� Ʃ�ü� 16*7=112
SELECT s.studno, s.name, s.weight, d.dname, d.loc
FROM student s ,department d;

-- Natural Join Error
SELECT s.studno, s.name, s.weight, d.dname, d.loc, s.weight, d.deptno
FROM student s
     NATURAL JOIN department d;
     
-- Natural Join
-- Natural Join�� �ΰ��� ���̺� �ߺ��� �÷�(Join �÷�)�� ��� ���̺��÷����� ǥ���ϸ� �ȵȴ�.
SELECT s.studno, s.name, s.weight, d.dname, d.loc, s.weight,deptno
FROM student s
     NATURAL JOIN department d;
     
--NATURAL JOIN�� �̿��Ͽ� ���� ��ȣ, �̸�, �а� ��ȣ, �а� �̸��� ����Ͽ���
SELECT p.profno,p.name,deptno,d.dname
FROM professor p
     NATURAL JOIN department d;
     
--NATURAL JOIN�� �̿��Ͽ� 4�г� �л��� �̸�, �а� ��ȣ, �а��̸��� ����Ͽ���
SELECT s.grade,s.name,deptno,d.dname
FROM student s 
     NATURAL JOIN department d
WHERE s.grade = 4;

--JOIN ~ USING ���� �̿��Ͽ� �й�, �̸�, �а���ȣ, �а��̸�, �а���ġ�� ����Ͽ���
SELECT s.studno,s.name,deptno,d.dname,d.loc
FROM student s JOIN department d
     USING(deptno);
     
-- NON-EQUI JOIN Ư�� ���� ���� �ִ��� �����ϱ�����  BETWEEN�� ���� =������ �ƴ� ������ ���
-- ���� ���̺�� �޿� ��� ���̺��� NON-EQUI JOIN�Ͽ� �������� �޿� ����� ����Ͽ���
SELECT p.profno, p.name, p.sal , s.grade
FROM professor p , salgrade2 s
WHERE p.sal BETWEEN s.losal AND s.hisal;

-- OUTER JOIN 
-- EQUI JOIN ���� ���� Į�� ������ �ϳ��� NULL ������ ���� ����� ����� �ʿ䰡 �ִ°�� ���
-- (EQUI JOIN�� NULL���� ���� ���� ���ΰ���� ��� �Ұ�) ,��Ȯ���� OUTER JOIN�� ����

--�л� ���̺�� ���� ���̺��� �����Ͽ� �̸�, �г�, ���������� �̸�, ������ ����Ͽ���. 
-- ��, ���������� �������� ���� �л��̸��� �Բ� ����Ͽ���.
SELECT s.name,s.grade,p.name,p.position
FROM student s, professor p
WHERE s.profno = p.profno(+) --left (+)���� �ݴ�� �־ �����̶����?
ORDER BY s.grade;

--�л� ���̺�� ���� ���̺��� �����Ͽ� �̸�, �г�, �������� �̸�, ������ ����Ͽ���. 
-- ��, �����л��� �������� ���� ���� �̸��� �Բ� ����Ͽ��� 
SELECT s.name,s.grade,p.name,p.position
FROM student s, professor p
WHERE s.profno(+) = p.profno -- right (+)���� �ݴ�� �־ �����̶����?
ORDER BY s.grade;

--ANSI OUTER JOIN
--1. ANSI LEFT OUTER JOIN
SELECT s.studno, s.name, s.profno, p.name
FROM student s
    LEFT OUTER JOIN professor p
    ON         s.profno = p.profno;
--2. ANSI RIGHT OUTER JOIN
SELECT s.studno, s.name, s.profno, p.name
FROM student s
    RIGHT OUTER JOIN professor p
    ON         s.profno = p.profno;
--3. ANSI FULL OUTER JOIN
-- FULL�� ���� �� �����°��̰� ANSI������ ����
SELECT s.studno, s.name, s.profno, p.name
FROM student s
    FULL OUTER JOIN professor p
    ON         s.profno = p.profno;
    
--FULL OUTER ���
SELECT s.name,s.grade,p.name,p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
UNION
SELECT s.name,s.grade,p.name,p.position
FROM student s, professor p
WHERE s.profno(+) = p.profno;

--�μ� ���̺��� SELF JOIN
SELECT c.deptno,c.dname,c.college,d.dname college_name
FROM department c, department d
WHERE c.college = d.deptno;

-- �μ� ��ȣ�� 201 �̻��� �μ� �̸��� ���� �μ��� �̸��� ���
SELECT CONCAT(CONCAT(c.dname,' �� �Ҽ��� '),d.dname)
FROM department c, department d
WHERE c.college = d.deptno
      AND c.deptno >= 201;
      
-- ����
--1. �̸�, �����ڸ�(emp TBL)
SELECT e.ename||' �� ���� ' || m.ename
FROM emp e ,emp m
WHERE e.mgr = m.empno;
--2.  �̸�,�޿�,�μ��ڵ�,�μ���,�ٹ���, ������ ��, ��ü����(emp ,dept TBL)
SELECT e.ename,e.sal,e.deptno,d.dname,m.ename
FROM emp e, dept d,emp m
WHERE e.deptno=d.deptno
      AND e.mgr  = m.empno(+) ;
--3. �̸�,�޿�,���,�μ���,�����ڸ�, �޿��� 2000�̻��� ���(emp, dept,salgrade TBL)
SELECT e.ename, e.sal, s.grade, d.dname, m.ename
FROM emp e,dept d, salgrade s,emp m
WHERE e.deptno=d.deptno
      AND e.mgr = m.empno 
      AND e.sal BETWEEN s.losal AND s.hisal
      AND e.sal >=2000;
--4. ���ʽ��� �޴� ����� ���Ͽ� �̸�,�μ���,��ġ�� ����ϴ� SELECT ������ �ۼ�emp ,dept TBL)
SELECT e.ename,d.dname,d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno
      AND e.comm is not null 
      AND e.comm != 0;  
--5. ���, �����, �μ��ڵ�, �μ����� �˻��϶�. ������������ ������������(emp ,dept TBL)
SELECT e.empno,e.ename,e.deptno,d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY e.ename;



------------------------------------------------
----- SUB Query
------------------------------------------------
--  1. ��ǥ : ���� ���̺��� ���������� ������ ������ ������ ��� ������ �̸� �˻�
--       1-1 ���� ���̺��� ���������� ������ ���� �˻� SQL ��ɹ� ����
--       1-2 ���� ���̺��� ���� Į������ 1 ���� ���� ��� ���� ������ ������ ���� ���� �˻� ��ɹ� ����
-- 1-1
SELECT position
FROM professor
WHERE name = '������';
--1-2
SELECT name ,position
FROM professor
WHERE position = '���Ӱ���';

-- 1. sub query
SELECT name ,position
FROM professor
WHERE position = (
                    SELECT position
                    FROM professor
                    WHERE name = '������'
                    );
                    
-- ���� �� Sub Query
--����� ���̵� ��jun123���� �л��� ���� �г��� �л��� �й�, �̸�, �г��� ����Ͽ���
SELECT studno, name, grade
FROM student
WHERE grade = (
                SELECT grade
                FROM student
                WHERE userid = 'jun123'
                );



--101�� �а� �л����� ��� �����Ժ��� �����԰� ���� �л��� �̸�, �а���ȣ, �����Ը� ����Ͽ���
SELECT name,grade,deptno,weight
FROM student
WHERE weight < (
                    SELECT avg(weight)
                    FROM student
                    WHERE deptno = 101
                    );

--20101�� �л��� �г��� ����, Ű�� 20101�� �л����� ū �л��� �̸�, �г�, Ű�� ����Ͽ���
SELECT name,grade, height
FROM student
WHERE     grade = (
                    SELECT grade
                    FROM student
                    WHERE studno = 20101
                    )
      AND height > (
                     SELECT height
                     FROM student
                     WHERE studno = 20101
                     );
                     


-------���� ��

--1.IN
--�����̵���к�(�μ���ȣ:100)�� �Ҽӵ� ��� �л��� �й�, �̸�, �а� ��ȣ�� ����Ͽ���
SELECT name,grade,deptno
FROM student
WHERE deptno IN (
                    SELECT deptno
                    FROM department
                    WHERE college = 100
                );
                
--2.ANY �����ڸ� �̿��� ���� �� ��������
SELECT studno,name,height
FROM student
WHERE height > any (
                        --175,176,177  any�� �ϸ� �ּ� �� 175���� ū ���� ã�´�
                        SELECT height
                        FROM student
                        WHERE grade = 4
                    );
  
--3.ALL �����ڸ� �̿��� ���� �� ��������
SELECT studno,name,height
FROM student
WHERE height > all (
                        --175,176,177  any�� �ϸ� �ִ� �� 177���� ū ���� ã�´�
                        SELECT height
                        FROM student
                        WHERE grade = 4
                    );
                    
--4. EXISTS �����ڸ� �̿��� ���� �� ��������
SELECT profno, name, sal, comm,position
FROM   professor
WHERE EXISTS (
                SELECT position
                FROM   professor
                WHERE  comm is not null
              );
              
--���������� �޴� ������ �� ���̶� ������ ��� ������ ���� ��ȣ, �̸�, �������� �׸��� �޿��� ���������� ���� ����Ͽ���
SELECT profno,name,comm,sal+nvl(comm,0)
FROM   professor
WHERE EXISTS (
                SELECT name
                FROM   professor
                WHERE  comm is not null
              );
                
--PAIRWISE ���� Į�� ��������
--PAIRWISE �� ����� ���� �г⺰�� �����԰� �ּ��� �л��� �̸�, �г�, �����Ը� ����Ͽ���
SELECT name,grade,weight
FROM   student
WHERE  (grade,weight) IN ( 
                            SELECT grade,MIN(weight)
                            FROM   student
                            GROUP BY grade
                          );

--��ȣ���� ��������
--������������ ������������ �˻� ����� ��ȯ�ϴ� ��������
-- �� �а� �л��� ��� Ű���� Ű�� ū �л��� �̸�, �а� ��ȣ, Ű�� ����Ͽ���
SELECT deptno,name,grade,height
FROM   student s1
WHERE height > (
                    SELECT AVG(height)
                    FROM   student s2
                    WHERE  s2.deptno = s1.deptno
                )
ORDER BY deptno;        

--1. Blake�� ���� �μ��� �ִ� ��� ����� ���ؼ� ��� �̸��� �Ի����� ���÷����϶�
SELECT ename,hiredate
FROM emp
WHERE deptno = (
                    SELECT deptno
                    FROM emp
                    WHERE INITCAP(ename) = 'Blake'
                );
--2. ��� �޿� �̻��� �޴� ��� ����� ���ؼ� ��� ��ȣ�� �̸��� ���÷����ϴ� ���ǹ��� �����϶�. 
--�� ����� �޿� �������� �����϶�
SELECT empno,ename
FROM emp
WHERE sal > (
                SELECT avg(sal)
                FROM emp
             )
ORDER BY   sal desc;           
--3. �μ� ��ȣ�� �޿��� ���ʽ��� �޴� � ����� �μ� ��ȣ�� �޿��� ��ġ�ϴ� ����� �̸�, �μ� ��ȣ �׸��� �޿��� ���÷����϶�.
SELECT ename,deptno,sal
FROM emp
WHERE (deptno,sal) IN (
                        SELECT deptno,sal
                        FROM emp
                        WHERE comm>0
                       );

             


















