SELECT ename,sal, comm,COALESCE(comm,sal,0) --1���� null�̸� 2���� ��� 2���� ������ 3���� ���
FROM emp;

--Decode *****(if)
SELECT ename,deptno,
       DECODE (deptno,10,'ACCOUNTING'
                     ,20,'RESEARCH'
                     ,30,'SALES'
                     ,'�̸��� ��')
FROM emp;
--CASE (switch)
SELECT ename,deptno,
       CASE WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            ELSE                  '�̸��� ��'
            END AS �μ���
FROM emp;


--���� 1

-- 1. �л� ���̺��� 1�г��̰ų� �����԰� 70KG�̻��� �л��� �˻��Ͽ�
--    �̷� , �г� , �а���ȣ ���
SELECT name,grade,studno
FROM student
WHERE grade = 1 or weight >=70 ;
-- 2. �л� ���̺��� �а���ȣ�� 101 �� �ƴ� �л��� �й��� �̸��� �а���ȣ ���
SELECT studno,name,deptno
FROM student
WHERE deptno != 101;
-- 3. BETWEEN �����ڸ� ����Ͽ� �����԰� 50KG���� 70KG������
--   �л��� �й� �̸� �����Ը� ���
SELECT studno,name,weight
FROM student
WHERE weight BETWEEN 50 AND 70;
--4. �л����̺��� 81�⿡�� 83�⵵�� �¾ �л��� �̸��� ��������� ���
SELECT name,birthdate
FROM student
WHERE SUBSTR(birthdate,1,2) BETWEEN '81' AND '83';
--5. �л� ���̺��� �̸��� 3����,���� "��"���� ���������ڰ� 
--  "��"���� ������ �л��� �̸� �г� �а���ȣ�� ���
SELECT  name,grade,deptno
FROM student
WHERE name like '��_��';
--6. 102�� �а� �л� �߿��� 1�г� �Ǵ� 4�г� �л���
--   �̸� �г� �а���ȣ�� ���
SELECT name,grade,deptno
FROM student
WHERE deptno = 102 AND grade in (1,4);
--7. �л� ���̺��� �̸��� ������ ������ ���� �Ͽ� �̸� �г� ��ȭ��ȣ�� ���
SELECT name,grade,tel
FROM student
ORDER BY name;


--���� 2

--1. salgrade ������ ��ü ����
SELECT *
FROM salgrade;
--2. scott���� ��밡���� ���̺� ����
SELECT *
FROM tab;
--3. emp Table���� ��� , �̸�, �޿�, ����, �Ի���
SELECT empno,ename,sal,job,hiredate
FROM emp;
--4. emp Table���� �޿��� 2000�̸��� ��� �� ���� ���, �̸�, �޿� �׸� ��ȸ
SELECT empno,ename,sal
FROM emp
WHERE sal <2000;
--5. emp Table���� 81/02���Ŀ� �Ի��� ����� ����  ���,�̸�,����,�Ի��� 
SELECT empno,ename,job,hiredate
FROM emp
WHERE hiredate >= '81/02/01';
--6. emp Table���� �޿��� 1500�̻��̰� 3000���� ���, �̸�, �޿�  ��ȸ
SELECT empno,ename,sal
FROM emp
WHERE sal BETWEEN 1500 AND 3000;
--7. emp Table���� ���, �̸�, ����, �޿� ��� [ �޿��� 2500�̻��̰�
--   ������ MANAGER�� ���]
SELECT empno,ename,job,sal
FROM emp
WHERE sal >=2500 AND job = 'MANAGER';
--8. emp Table���� �̸�, �޿�, ���� ��ȸ [�� ������  ���� = (�޿�+��) * 12  , null�� 0���� ����]
SELECT ename,sal,(NVL(sal,0)+NVL(comm,0))*12 ����
FROM emp;
    
--9. emp Table����  81/02 ���Ŀ� �Ի��ڵ��� xxx�� ������ xxx�̰� �޿��� xxx 
--  [ ��ü Row ��� ]
SELECT  CONCAT(CONCAT(CONCAT(CONCAT(ename,'�� ������ '),job),'�̰� �޿��� '),sal) --||�� �ξ� ����
FROM emp
WHERE hiredate >= '81/02/01';
--10.emp Table���� �̸��ӿ� T�� �ִ� ���,�̸� ���
SELECT empno,ename
FROM emp
WHERE ename like '%T%';
--11.82�⿡ �Ի��� ��� ��ü �÷� ���
SELECT *
FROM emp
WHERE SUBSTR(hiredate,1,2) ='82';
--12.salgrade ��������
desc salgrade;

--���� 3
--1. emp Table �� �̸��� �빮��, �ҹ���, ù���ڸ� �빮�ڷ� ���
SELECT UPPER(ename),LOWER(ename),INITCAP(ename)
FROM emp;
--2. emp Table ��  �̸�, ����, ������ 2-5���� ���� ���
SELECT ename,job,SUBSTR(job,2,4)
FROM emp;
--3. emp Table �� �̸�, �̸��� 10�ڸ��� �ϰ� ���ʿ� #���� ä���
SELECT ename,LPAD(ename,10,'#')
FROM emp;
--4. emp Table �� �̸�, ����, ������ MANAGER�� �����ڷ� ���
SELECT ename, job,replace(job,'MANAGER','������')
FROM emp;
--5. emp Table ��  �̸�, �޿�/7�� ���� ����, �Ҽ��� 1�ڸ�. 10������
--   �ݿø��Ͽ� ���
SELECT ename,ROUND((sal/7)),ROUND((sal/7),1),ROUND((sal/7),-1)
FROM emp;
--6. 5���� �����Ͽ� �����Ͽ� ���
SELECT ename,TRUNC((sal/7)),TRUNC((sal/7),1),TRUNC((sal/7),-1)
FROM emp;
--7. emp Table ��  �̸�, �޿�/7�� ����� �ݿø�,����,ceil,floor
SELECT ename,ROUND((sal/7)),TRUNC((sal/7)),CEIL((sal/7)),FLOOR((sal/7))
FROM emp;
--8. emp Table ��  �̸�, �޿�, �޿�/7�� ������
SELECT ename,sal,MOD(sal,7)
FROM emp;
--9. emp Table �� �̸�, �޿�, �Ի���, �Ի�Ⱓ(���� ����,��)���
--  �Ҽ��� ���ϴ� �ݿø�
SELECT ename,sal,hiredate,ROUND(sysdate-hiredate) �Ի�Ⱓ��¥
                        ,ROUND(MONTHS_BETWEEN(sysdate,hiredate))  �Ի�Ⱓ��
FROM emp;
--10.emp Table ��  job �� 'CLERK' �϶� 10% ,'ANALYSY' �϶� 20% 
--                                 'MANAGER' �϶� 30% ,'PRESIDENT' �϶� 40%
--                                 'SALESMAN' �϶� 50% 
--                                 �׿��϶� 60% �λ� �Ͽ� 
--   empno, ename, job, sal, �� �� �λ� �޿��� ����ϼ���(CASE/Decode�� ���)

--CASE
SELECT ename,job,sal, 
        CASE WHEN job = 'CLERK'     THEN sal*1.1
             WHEN job = 'ANALYSY'   THEN sal*1.2
             WHEN job = 'MANAGER'   THEN sal*1.3
             WHEN job = 'PRESIDENT' THEN sal*1.4
             WHEN job = 'SALESMAN'  THEN sal*1.5
             ELSE                        sal*1.6
             END as �λ�޿�
FROM emp;
--DECODE
SELECT ename,job,sal,
       DECODE(job,'CLERK'    ,sal*1.1
                 ,'ANALYSY'  ,sal*1.2
                 ,'MANAGER'  ,sal*1.3
                 ,'PRESIDENT',sal*1.4
                 ,'SALESMAN ',sal*1.5
                             ,sal*1.6)as �λ�޿�
FROM emp;      




--------------�׷��Լ�-------------------------
SELECT count(*)
FROM professor
WHERE deptno = 101;

SELECT count(comm)
FROM professor
WHERE deptno = 101;

-- 101�� �а� �л����� ������ ��հ� �հ踦 ����Ͽ���
SELECT AVG(weight),SUM(weight)
FROM student
WHERE deptno = 101;

-- 101�� �а� �л����� �ִ� Ű�� �ּ� Ű�� ����Ͽ���
SELECT MAX(height),MIN(height)
FROM student
WHERE deptno = 101;

--���� ���̺��� �޿��� ǥ�������� �л��� ����Ͽ���
SELECT STDDEV(sal),VARIANCE(sal)
FROM professor;

-- ���� ���̺��� �а����� ���� ���� ���������� �޴� ���� ���� ����Ͽ���
SELECT deptno, COUNT(*),COUNT(comm)
FROM professor
GROUP BY deptno;
--GROUP BY ���ٴ� ���� ��ü ��踦 �ǹ��ϸ� 
--SELECT Group �Լ� �տ� Column�� ���� �� ��
--SELECT deptno, COUNT(*),COUNT(comm)
--FROM professor   

--�л� ���� 4���̻��� �г⿡ ���ؼ� �г�, �л� ��, ��� Ű, ��� �����Ը� ����Ͽ���. 
--��, ��� Ű�� ��� �����Դ� �Ҽ��� ù ��° �ڸ����� �ݿø� �ϰ�, ��¼����� ��� Ű�� ���� ������ ������������ ���
SELECT grade,COUNT(*)
        ,ROUND(AVG(height)) avg_h
        ,ROUND(AVG(weight)) avg_w
FROM      student
GROUP BY  grade 
HAVING COUNT(*) >= 4
ORDER BY avg_h DESC;

--1. �ֱ� �Ի� ����� ���� ������ ����� �Ի��� ��� (emp)
SELECT MIN(hiredate),MAX(hiredate)
FROM emp;
--2. �μ��� �ֱ� �Ի� ����� ���� ������ ����� �Ի��� ��� (emp)
SELECT deptno, MIN(hiredate),MAX(hiredate)
FROM emp
GROUP BY deptno;
--3. �Ѱ� �̻� Column ���� --> �μ��� ������ count & sum(�޿�) (emp)
SELECT deptno,job, COUNT(*), SUM(sal)
FROM emp
GROUP BY deptno,job;
--4. �μ��� �޿� �Ѿ� 3000�̻� �μ���ȣ,�μ��� �޿� �ִ� (emp)
SELECT deptno,max(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) >= 3000;
--5. ��ü �л��� �Ҽ� �а����� ������, ���� �а� �л��� �ٽ� �г⺰�� �׷����Ͽ�, 
--   �а��� �г⺰ �ο���, ��� �����Ը� ���, 
-- (��, ��� �����Դ� �Ҽ��� ���� ù��° �ڸ����� �ݿø� )  (STUDENT)
SELECT deptno,grade ,count(*),round(avg(weight))
FROM student
GROUP BY deptno,grade
ORDER BY deptno;



