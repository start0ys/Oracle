SELECT ename,sal, comm,COALESCE(comm,sal,0) --1번이 null이면 2번을 출력 2번도 없으면 3번을 출력
FROM emp;

--Decode *****(if)
SELECT ename,deptno,
       DECODE (deptno,10,'ACCOUNTING'
                     ,20,'RESEARCH'
                     ,30,'SALES'
                     ,'이름좀 줘')
FROM emp;
--CASE (switch)
SELECT ename,deptno,
       CASE WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            ELSE                  '이름좀 줘'
            END AS 부서명
FROM emp;


--문제 1

-- 1. 학생 테이블에서 1학년이거나 몸무게가 70KG이상인 학생만 검색하여
--    이룸 , 학년 , 학과번호 출력
SELECT name,grade,studno
FROM student
WHERE grade = 1 or weight >=70 ;
-- 2. 학생 테이블에서 학과번호가 101 이 아닌 학생의 학번과 이름가 학과번호 출력
SELECT studno,name,deptno
FROM student
WHERE deptno != 101;
-- 3. BETWEEN 연산자를 사용하여 몸무게가 50KG에서 70KG사이인
--   학생의 학번 이름 몸무게를 출력
SELECT studno,name,weight
FROM student
WHERE weight BETWEEN 50 AND 70;
--4. 학생테이블에서 81년에서 83년도에 태어난 학생의 이름과 생년원일을 출력
SELECT name,birthdate
FROM student
WHERE SUBSTR(birthdate,1,2) BETWEEN '81' AND '83';
--5. 학생 테이블에서 이름이 3글자,성은 "이"씨고 마지막글자가 
--  "훈"으로 끝나는 학생의 이름 학년 학과번호를 출력
SELECT  name,grade,deptno
FROM student
WHERE name like '이_훈';
--6. 102번 학과 학생 중에서 1학년 또는 4학년 학생의
--   이름 학년 학과번호를 출력
SELECT name,grade,deptno
FROM student
WHERE deptno = 102 AND grade in (1,4);
--7. 학생 테이블에서 이름을 가나다 순으로 정렬 하여 이름 학년 전화번호를 출력
SELECT name,grade,tel
FROM student
ORDER BY name;


--문제 2

--1. salgrade 데이터 전체 보기
SELECT *
FROM salgrade;
--2. scott에서 사용가능한 테이블 보기
SELECT *
FROM tab;
--3. emp Table에서 사번 , 이름, 급여, 업무, 입사일
SELECT empno,ename,sal,job,hiredate
FROM emp;
--4. emp Table에서 급여가 2000미만인 사람 에 대한 사번, 이름, 급여 항목 조회
SELECT empno,ename,sal
FROM emp
WHERE sal <2000;
--5. emp Table에서 81/02이후에 입사한 사람에 대한  사번,이름,업무,입사일 
SELECT empno,ename,job,hiredate
FROM emp
WHERE hiredate >= '81/02/01';
--6. emp Table에서 급여가 1500이상이고 3000이하 사번, 이름, 급여  조회
SELECT empno,ename,sal
FROM emp
WHERE sal BETWEEN 1500 AND 3000;
--7. emp Table에서 사번, 이름, 업무, 급여 출력 [ 급여가 2500이상이고
--   업무가 MANAGER인 사람]
SELECT empno,ename,job,sal
FROM emp
WHERE sal >=2500 AND job = 'MANAGER';
--8. emp Table에서 이름, 급여, 연봉 조회 [단 조건은  연봉 = (급여+상여) * 12  , null을 0으로 변경]
SELECT ename,sal,(NVL(sal,0)+NVL(comm,0))*12 연봉
FROM emp;
    
--9. emp Table에서  81/02 이후에 입사자들중 xxx는 업무가 xxx이고 급여가 xxx 
--  [ 전체 Row 출력 ]
SELECT  CONCAT(CONCAT(CONCAT(CONCAT(ename,'는 업무가 '),job),'이고 급여가 '),sal) --||가 훨씬 편함
FROM emp
WHERE hiredate >= '81/02/01';
--10.emp Table에서 이름속에 T가 있는 사번,이름 출력
SELECT empno,ename
FROM emp
WHERE ename like '%T%';
--11.82년에 입사한 사람 전체 컬럼 출력
SELECT *
FROM emp
WHERE SUBSTR(hiredate,1,2) ='82';
--12.salgrade 구조보기
desc salgrade;

--문제 3
--1. emp Table 의 이름을 대문자, 소문자, 첫글자만 대문자로 출력
SELECT UPPER(ename),LOWER(ename),INITCAP(ename)
FROM emp;
--2. emp Table 의  이름, 업무, 업무를 2-5사이 문자 출력
SELECT ename,job,SUBSTR(job,2,4)
FROM emp;
--3. emp Table 의 이름, 이름을 10자리로 하고 왼쪽에 #으로 채우기
SELECT ename,LPAD(ename,10,'#')
FROM emp;
--4. emp Table 의 이름, 업무, 업무가 MANAGER면 관리자로 출력
SELECT ename, job,replace(job,'MANAGER','관리자')
FROM emp;
--5. emp Table 의  이름, 급여/7을 각각 정수, 소숫점 1자리. 10단위로
--   반올림하여 출력
SELECT ename,ROUND((sal/7)),ROUND((sal/7),1),ROUND((sal/7),-1)
FROM emp;
--6. 5번을 참조하여 절사하여 출력
SELECT ename,TRUNC((sal/7)),TRUNC((sal/7),1),TRUNC((sal/7),-1)
FROM emp;
--7. emp Table 의  이름, 급여/7한 결과를 반올림,절사,ceil,floor
SELECT ename,ROUND((sal/7)),TRUNC((sal/7)),CEIL((sal/7)),FLOOR((sal/7))
FROM emp;
--8. emp Table 의  이름, 급여, 급여/7한 나머지
SELECT ename,sal,MOD(sal,7)
FROM emp;
--9. emp Table 의 이름, 급여, 입사일, 입사기간(각각 날자,월)출력
--  소숫점 이하는 반올림
SELECT ename,sal,hiredate,ROUND(sysdate-hiredate) 입사기간날짜
                        ,ROUND(MONTHS_BETWEEN(sysdate,hiredate))  입사기간월
FROM emp;
--10.emp Table 의  job 이 'CLERK' 일때 10% ,'ANALYSY' 일때 20% 
--                                 'MANAGER' 일때 30% ,'PRESIDENT' 일때 40%
--                                 'SALESMAN' 일때 50% 
--                                 그외일때 60% 인상 하여 
--   empno, ename, job, sal, 및 각 인상 급여를 출력하세요(CASE/Decode문 사용)

--CASE
SELECT ename,job,sal, 
        CASE WHEN job = 'CLERK'     THEN sal*1.1
             WHEN job = 'ANALYSY'   THEN sal*1.2
             WHEN job = 'MANAGER'   THEN sal*1.3
             WHEN job = 'PRESIDENT' THEN sal*1.4
             WHEN job = 'SALESMAN'  THEN sal*1.5
             ELSE                        sal*1.6
             END as 인상급여
FROM emp;
--DECODE
SELECT ename,job,sal,
       DECODE(job,'CLERK'    ,sal*1.1
                 ,'ANALYSY'  ,sal*1.2
                 ,'MANAGER'  ,sal*1.3
                 ,'PRESIDENT',sal*1.4
                 ,'SALESMAN ',sal*1.5
                             ,sal*1.6)as 인상급여
FROM emp;      




--------------그룹함수-------------------------
SELECT count(*)
FROM professor
WHERE deptno = 101;

SELECT count(comm)
FROM professor
WHERE deptno = 101;

-- 101번 학과 학생들의 몸무게 평균과 합계를 출력하여라
SELECT AVG(weight),SUM(weight)
FROM student
WHERE deptno = 101;

-- 101번 학과 학생들의 최대 키와 최소 키를 출력하여라
SELECT MAX(height),MIN(height)
FROM student
WHERE deptno = 101;

--교수 테이블에서 급여의 표준편차와 분산을 출력하여라
SELECT STDDEV(sal),VARIANCE(sal)
FROM professor;

-- 교수 테이블에서 학과별로 교수 수와 보직수당을 받는 교수 수를 출력하여라
SELECT deptno, COUNT(*),COUNT(comm)
FROM professor
GROUP BY deptno;
--GROUP BY 없다는 것은 전체 통계를 의미하며 
--SELECT Group 함수 앞에 Column이 들어가면 안 됨
--SELECT deptno, COUNT(*),COUNT(comm)
--FROM professor   

--학생 수가 4명이상인 학년에 대해서 학년, 학생 수, 평균 키, 평균 몸무게를 출력하여라. 
--단, 평균 키와 평균 몸무게는 소수점 첫 번째 자리에서 반올림 하고, 출력순서는 평균 키가 높은 순부터 내림차순으로 출력
SELECT grade,COUNT(*)
        ,ROUND(AVG(height)) avg_h
        ,ROUND(AVG(weight)) avg_w
FROM      student
GROUP BY  grade 
HAVING COUNT(*) >= 4
ORDER BY avg_h DESC;

--1. 최근 입사 사원과 가장 오래된 사원의 입사일 출력 (emp)
SELECT MIN(hiredate),MAX(hiredate)
FROM emp;
--2. 부서별 최근 입사 사원과 가장 오래된 사원의 입사일 출력 (emp)
SELECT deptno, MIN(hiredate),MAX(hiredate)
FROM emp
GROUP BY deptno;
--3. 한개 이상 Column 적용 --> 부서별 직업별 count & sum(급여) (emp)
SELECT deptno,job, COUNT(*), SUM(sal)
FROM emp
GROUP BY deptno,job;
--4. 부서별 급여 총액 3000이상 부서번호,부서별 급여 최대 (emp)
SELECT deptno,max(sal)
FROM emp
GROUP BY deptno
HAVING SUM(sal) >= 3000;
--5. 전체 학생을 소속 학과별로 나누고, 같은 학과 학생은 다시 학년별로 그룹핑하여, 
--   학과와 학년별 인원수, 평균 몸무게를 출력, 
-- (단, 평균 몸무게는 소수점 이하 첫번째 자리에서 반올림 )  (STUDENT)
SELECT deptno,grade ,count(*),round(avg(weight))
FROM student
GROUP BY deptno,grade
ORDER BY deptno;



