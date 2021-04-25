--------------------�⺻�Լ�--------------------
select name,grade ,tel
from student
order by grade desc;
-- ��ҹ��� ��ȯ
SELECT ename,UPPER(ename),LOWER(ename), INITCAP(ename)
FROM emp;

--�ҹ��ڷ� �����ֱ�
SELECT ename,sal,deptno
FROM emp
WHERE LOWER(ename) = 'scott';

--LENGTH , LENGTHB URF - 8 �� �ѱ��� 3BYTE�� ��ȯ
SELECT dname , LENGTH(dname), LENGTHB(dname)
FROM dept;

--���ڿ� ����
SELECT 'ORACLE','MAINA',CONCAT('ORACLE','MAINA'),'ORACLE'||'MAINA'
FROM DUAL;

SELECT CONCAT(CONCAT(name,' �� ��å�� '),position)
FROM professor;

--���ڿ� �Ϻ�
SELECT dname,SUBSTR(dname,3,6),SUBSTR(dname,-3,6)
FROM DEPT;

--���ڿ� ��ġ
SELECT INSTR('ORACLE MAINA','A')
FROM DUAL;

SELECT INSTR('ORACLE MAINA','A',5)
FROM DUAL;

--LPAD,RPAD
SELECT SAL,LPAD(SAL,10,'*')
FROM EMP;

SELECT SAL,RPAD(SAL,10,'*')
FROM EMP;

--TRIM (�ֺ� ��������)
SELECT 'ORACLE MANIA',LTRIM(' ORACLE MANIA '), RTRIM(' ORACLE MANIA ')
    ,TRIM(' ORACLE MANIA ' )
FROM DUAL;

--���� �Լ�
SELECT 98.76554,ROUND(98.7654),ROUND(98.7654,2),ROUND(98.7654,-1)
FROM DUAL;

SELECT ROUND(2345.7654,-1),ROUND(2345.7654,-2)
FROM DUAL; --�ݿø�

SELECT 98.76554,TRUNC(98.7654),TRUNC(98.7654,2),TRUNC(98.7654,-1)
FROM DUAL; --����

SELECT MOD(31,2),MOD(31,5),MOD(31,8) 
FROM DUAL; --������ %

--DATE
SELECT SYSDATE
FROM DUAL;

SELECT SYSDATE-1,SYSDATE,SYSDATE+1 FROM DUAL;

SELECT ename,SYSDATE,ROUND(SYSDATE-hiredate) R�ٹ��ϼ�,TRUNC(SYSDATE-hiredate) T�ٹ��ϼ�
FROM EMP;

SELECT ENAME,SYSDATE,HIREDATE,MONTHS_BETWEEN(SYSDATE,HIREDATE)
FROM emp;

SELECT ename,hiredate,ADD_MONTHS(hiredate,6)
FROM emp; --�Ի��Ϸκ��� 6���� ��

SELECT sysdate,LAST_DAY(sysdate)
FROM dual;

--����ȯ �Լ�
SELECT ename,hiredate,TO_CHAR(hiredate,'YY-MM'),TO_CHAR(hiredate,'YYYY/MM/DD DAY')
FROM emp;

SELECT TO_CHAR(sysdate,'YYYY/MM/DD,HH24:MI:SS')
FROM dual;

SELECT ename,hiredate
FROM emp
WHERE hiredate = '81/06/09';
--WHERE hiredate = TO_DATE('81/06/09');

SELECT TO_NUMBER('100,000','999,999')-TO_NUMBER('50,000','999,999')
FROM DUAL;

SELECT ename,sal,comm, nvl2(comm,sal*12+comm,sal*12)
FROM emp;

SELECT NULLIF('A','A'),NULLIF('A','B') --ù��° �ι�°�� �����ϸ� null�ٸ��� ù��° ���
FROM DUAL;


--����

--��� ����� �̸��� �޿� �� �μ���ȣ�� ����ϴµ�, 
--�μ� ��ȣ�� ����� ������ ���� �޿��� ���ؼ��� ������������ �����϶�

select ename,sal,deptno
from  emp 
order by deptno, sal desc;

-- �μ� 10�� 30�� ���ϴ� ��� ����� �̸��� �μ���ȣ�� �̸��� ���ĺ� ������ 
-- ���ĵǵ��� ���ǹ�(emp)


SELECT ename,deptno
FROM emp
WHERE deptno in(10,30)
ORDER BY ename;

--1982�⿡ �Ի��� ��� ����� �̸��� �Ի����� ���ϴ� ���ǹ���

SELECT ename,hiredate
FROM emp
where hiredate like '82%';

-- ���ʽ��� �޴� ��� ����� ���ؼ� �̸�, �޿� �׸��� ���ʽ��� 
-- ����ϴ� ���ǹ��� ����. �� �޿��� ���ʽ��� ���ؼ� �������� ����

SELECT ename,sal,comm
FROM emp
WHERE ( comm IS NOT NULL AND comm != 0 )
ORDER BY sal desc,comm desc;

-- ���ʽ��� �޿��� 20% �̻��̰� �μ���ȣ�� 30�� ��� ����� ���ؼ� 
-- �̸�, �޿� �׸��� ���ʽ��� ����ϴ� ���ǹ��� �����϶�

SELECT ename,sal,comm
FROM emp
WHERE comm >= (sal*0.2) and deptno = 30;