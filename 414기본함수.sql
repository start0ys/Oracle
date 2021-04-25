--------------------기본함수--------------------
select name,grade ,tel
from student
order by grade desc;
-- 대소문자 변환
SELECT ename,UPPER(ename),LOWER(ename), INITCAP(ename)
FROM emp;

--소문자로 맞춰주기
SELECT ename,sal,deptno
FROM emp
WHERE LOWER(ename) = 'scott';

--LENGTH , LENGTHB URF - 8 은 한글을 3BYTE씩 반환
SELECT dname , LENGTH(dname), LENGTHB(dname)
FROM dept;

--문자열 결합
SELECT 'ORACLE','MAINA',CONCAT('ORACLE','MAINA'),'ORACLE'||'MAINA'
FROM DUAL;

SELECT CONCAT(CONCAT(name,' 의 직책은 '),position)
FROM professor;

--문자열 일부
SELECT dname,SUBSTR(dname,3,6),SUBSTR(dname,-3,6)
FROM DEPT;

--문자열 위치
SELECT INSTR('ORACLE MAINA','A')
FROM DUAL;

SELECT INSTR('ORACLE MAINA','A',5)
FROM DUAL;

--LPAD,RPAD
SELECT SAL,LPAD(SAL,10,'*')
FROM EMP;

SELECT SAL,RPAD(SAL,10,'*')
FROM EMP;

--TRIM (주변 공백제거)
SELECT 'ORACLE MANIA',LTRIM(' ORACLE MANIA '), RTRIM(' ORACLE MANIA ')
    ,TRIM(' ORACLE MANIA ' )
FROM DUAL;

--숫자 함수
SELECT 98.76554,ROUND(98.7654),ROUND(98.7654,2),ROUND(98.7654,-1)
FROM DUAL;

SELECT ROUND(2345.7654,-1),ROUND(2345.7654,-2)
FROM DUAL; --반올림

SELECT 98.76554,TRUNC(98.7654),TRUNC(98.7654,2),TRUNC(98.7654,-1)
FROM DUAL; --버림

SELECT MOD(31,2),MOD(31,5),MOD(31,8) 
FROM DUAL; --나머지 %

--DATE
SELECT SYSDATE
FROM DUAL;

SELECT SYSDATE-1,SYSDATE,SYSDATE+1 FROM DUAL;

SELECT ename,SYSDATE,ROUND(SYSDATE-hiredate) R근무일수,TRUNC(SYSDATE-hiredate) T근무일수
FROM EMP;

SELECT ENAME,SYSDATE,HIREDATE,MONTHS_BETWEEN(SYSDATE,HIREDATE)
FROM emp;

SELECT ename,hiredate,ADD_MONTHS(hiredate,6)
FROM emp; --입사일로부터 6개월 후

SELECT sysdate,LAST_DAY(sysdate)
FROM dual;

--형변환 함수
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

SELECT NULLIF('A','A'),NULLIF('A','B') --첫번째 두번째가 동일하면 null다르면 첫번째 출력
FROM DUAL;


--문제

--모든 사원의 이름과 급여 및 부서번호를 출력하는데, 
--부서 번호로 결과를 정렬한 다음 급여에 대해서는 내림차순으로 정렬하라

select ename,sal,deptno
from  emp 
order by deptno, sal desc;

-- 부서 10과 30에 속하는 모든 사원의 이름과 부서번호를 이름의 알파벳 순으로 
-- 정렬되도록 질의문(emp)


SELECT ename,deptno
FROM emp
WHERE deptno in(10,30)
ORDER BY ename;

--1982년에 입사한 모든 사원의 이름과 입사일을 구하는 질의문은

SELECT ename,hiredate
FROM emp
where hiredate like '82%';

-- 보너스를 받는 모든 사원에 대해서 이름, 급여 그리고 보너스를 
-- 출력하는 질의문을 형성. 단 급여와 보너스에 대해서 내림차순 정렬

SELECT ename,sal,comm
FROM emp
WHERE ( comm IS NOT NULL AND comm != 0 )
ORDER BY sal desc,comm desc;

-- 보너스가 급여의 20% 이상이고 부서번호가 30인 모든 사원에 대해서 
-- 이름, 급여 그리고 보너스를 출력하는 질의문을 형성하라

SELECT ename,sal,comm
FROM emp
WHERE comm >= (sal*0.2) and deptno = 30;