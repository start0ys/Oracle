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
--------------------------조인--------------------

-- 학번이 10101인 학생의 이름과 소속 학과 이름을 출력하라
SELECT studno,name,deptno
FROM student
WHERE studno = 10101;

-- 학과를 가지고 학과이름
SELECT dname
FROM department
WHERE deptno = 101;

-- 조인을 이용한 학생이름과 학과이름 검색
SELECT studno,name,student.deptno,department.dname
FROM student ,department 
WHERE student.deptno = department.deptno;

-- 애매모호성 ambiguously 
-- 두개의 테이블에 중복된 컬럼은 어느 테이블의 컬럼인지 알려주지않으면 에러가발생
SELECT studno,name,deptno,dname
FROM student ,department 
WHERE student.deptno = department.deptno;

-- 별명 (alias) 어느테이블의 컬럼인지 다 써주는거 권장
SELECT s.studno,s.name,d.deptno,d.dname
FROM student s,department d
WHERE s.deptno = d.deptno;

-- 전인하 학생의 학번,이름,학과 이름 그리고 학과 위치를 출력
SELECT s.studno, s.name, d.dname, d.loc
FROM student s ,department d
WHERE s.deptno=d.deptno 
AND s.name = '전인하';

-- 몸무게가 80kg이상인 학생의 학번, 이름, 체중, 학과 이름, 학과위치를 출력
SELECT s.studno, s.name, s.weight, d.dname, d.loc
FROM student s ,department d
WHERE s.deptno=d.deptno
AND s.weight >= 80;

-- 카티션 곱 두 개 이상의 테이블에 대해 연결 가능한 행을 모두 결합
-- student 튜플수 16 departmane 튜플 수 7 카디션 곱 튜플수 16*7=112
SELECT s.studno, s.name, s.weight, d.dname, d.loc
FROM student s ,department d;

-- Natural Join Error
SELECT s.studno, s.name, s.weight, d.dname, d.loc, s.weight, d.deptno
FROM student s
     NATURAL JOIN department d;
     
-- Natural Join
-- Natural Join은 두개의 테이블에 중복된 컬럼(Join 컬럼)은 어느 테이블컬럼인지 표시하면 안된다.
SELECT s.studno, s.name, s.weight, d.dname, d.loc, s.weight,deptno
FROM student s
     NATURAL JOIN department d;
     
--NATURAL JOIN을 이용하여 교수 번호, 이름, 학과 번호, 학과 이름을 출력하여라
SELECT p.profno,p.name,deptno,d.dname
FROM professor p
     NATURAL JOIN department d;
     
--NATURAL JOIN을 이용하여 4학년 학생의 이름, 학과 번호, 학과이름을 출력하여라
SELECT s.grade,s.name,deptno,d.dname
FROM student s 
     NATURAL JOIN department d
WHERE s.grade = 4;

--JOIN ~ USING 절을 이용하여 학번, 이름, 학과번호, 학과이름, 학과위치를 출력하여라
SELECT s.studno,s.name,deptno,d.dname,d.loc
FROM student s JOIN department d
     USING(deptno);
     
-- NON-EQUI JOIN 특정 범위 내에 있는지 조사하기위해  BETWEEN과 같이 =조건이 아닌 연산자 사용
-- 교수 테이블과 급여 등급 테이블을 NON-EQUI JOIN하여 교수별로 급여 등급을 출력하여라
SELECT p.profno, p.name, p.sal , s.grade
FROM professor p , salgrade2 s
WHERE p.sal BETWEEN s.losal AND s.hisal;

-- OUTER JOIN 
-- EQUI JOIN 에서 양측 칼럼 값중의 하나가 NULL 이지만 조인 결과로 출력할 필요가 있는경우 사용
-- (EQUI JOIN은 NULL값을 가진 행은 조인결과로 출력 불가) ,정확성은 OUTER JOIN이 좋음

--학생 테이블과 교수 테이블을 조인하여 이름, 학년, 지도교수의 이름, 직급을 출력하여라. 
-- 단, 지도교수가 배정되지 않은 학생이름도 함께 출력하여라.
SELECT s.name,s.grade,p.name,p.position
FROM student s, professor p
WHERE s.profno = p.profno(+) --left (+)쪽을 반대로 넣어서 조인이라생각?
ORDER BY s.grade;

--학생 테이블과 교수 테이블을 조인하여 이름, 학년, 지도교수 이름, 직급을 출력하여라. 
-- 단, 지도학생을 배정받지 않은 교수 이름도 함께 출력하여라 
SELECT s.name,s.grade,p.name,p.position
FROM student s, professor p
WHERE s.profno(+) = p.profno -- right (+)쪽을 반대로 넣어서 조인이라생각?
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
-- FULL은 양쪽 다 나오는것이고 ANSI에서만 가능
SELECT s.studno, s.name, s.profno, p.name
FROM student s
    FULL OUTER JOIN professor p
    ON         s.profno = p.profno;
    
--FULL OUTER 모방
SELECT s.name,s.grade,p.name,p.position
FROM student s, professor p
WHERE s.profno = p.profno(+)
UNION
SELECT s.name,s.grade,p.name,p.position
FROM student s, professor p
WHERE s.profno(+) = p.profno;

--부서 테이블의 SELF JOIN
SELECT c.deptno,c.dname,c.college,d.dname college_name
FROM department c, department d
WHERE c.college = d.deptno;

-- 부서 번호가 201 이상인 부서 이름과 상위 부서의 이름을 출력
SELECT CONCAT(CONCAT(c.dname,' 의 소속은 '),d.dname)
FROM department c, department d
WHERE c.college = d.deptno
      AND c.deptno >= 201;
      
-- 문제
--1. 이름, 관리자명(emp TBL)
SELECT e.ename||' 의 상사는 ' || m.ename
FROM emp e ,emp m
WHERE e.mgr = m.empno;
--2.  이름,급여,부서코드,부서명,근무지, 관리자 명, 전체직원(emp ,dept TBL)
SELECT e.ename,e.sal,e.deptno,d.dname,m.ename
FROM emp e, dept d,emp m
WHERE e.deptno=d.deptno
      AND e.mgr  = m.empno(+) ;
--3. 이름,급여,등급,부서명,관리자명, 급여가 2000이상인 사람(emp, dept,salgrade TBL)
SELECT e.ename, e.sal, s.grade, d.dname, m.ename
FROM emp e,dept d, salgrade s,emp m
WHERE e.deptno=d.deptno
      AND e.mgr = m.empno 
      AND e.sal BETWEEN s.losal AND s.hisal
      AND e.sal >=2000;
--4. 보너스를 받는 사원에 대하여 이름,부서명,위치를 출력하는 SELECT 문장을 작성emp ,dept TBL)
SELECT e.ename,d.dname,d.loc
FROM emp e, dept d
WHERE e.deptno = d.deptno
      AND e.comm is not null 
      AND e.comm != 0;  
--5. 사번, 사원명, 부서코드, 부서명을 검색하라. 사원명기준으로 오름차순정열(emp ,dept TBL)
SELECT e.empno,e.ename,e.deptno,d.dname
FROM emp e, dept d
WHERE e.deptno = d.deptno
ORDER BY e.ename;



------------------------------------------------
----- SUB Query
------------------------------------------------
--  1. 목표 : 교수 테이블에서 ‘전은지’ 교수와 직급이 동일한 모든 교수의 이름 검색
--       1-1 교수 테이블에서 ‘전은지’ 교수의 직급 검색 SQL 명령문 실행
--       1-2 교수 테이블의 직급 칼럼에서 1 에서 얻은 결과 값과 동일한 직급을 가진 교수 검색 명령문 실행
-- 1-1
SELECT position
FROM professor
WHERE name = '전은지';
--1-2
SELECT name ,position
FROM professor
WHERE position = '전임강사';

-- 1. sub query
SELECT name ,position
FROM professor
WHERE position = (
                    SELECT position
                    FROM professor
                    WHERE name = '전은지'
                    );
                    
-- 단일 행 Sub Query
--사용자 아이디가 ‘jun123’인 학생과 같은 학년인 학생의 학번, 이름, 학년을 출력하여라
SELECT studno, name, grade
FROM student
WHERE grade = (
                SELECT grade
                FROM student
                WHERE userid = 'jun123'
                );



--101번 학과 학생들의 평균 몸무게보다 몸무게가 적은 학생의 이름, 학과번호, 몸무게를 출력하여라
SELECT name,grade,deptno,weight
FROM student
WHERE weight < (
                    SELECT avg(weight)
                    FROM student
                    WHERE deptno = 101
                    );

--20101번 학생과 학년이 같고, 키는 20101번 학생보다 큰 학생의 이름, 학년, 키를 출력하여라
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
                     


-------다중 행

--1.IN
--정보미디어학부(부서번호:100)에 소속된 모든 학생의 학번, 이름, 학과 번호를 출력하여라
SELECT name,grade,deptno
FROM student
WHERE deptno IN (
                    SELECT deptno
                    FROM department
                    WHERE college = 100
                );
                
--2.ANY 연산자를 이용한 다중 행 서브쿼리
SELECT studno,name,height
FROM student
WHERE height > any (
                        --175,176,177  any를 하면 최소 즉 175보다 큰 값을 찾는다
                        SELECT height
                        FROM student
                        WHERE grade = 4
                    );
  
--3.ALL 연산자를 이용한 다중 행 서브쿼리
SELECT studno,name,height
FROM student
WHERE height > all (
                        --175,176,177  any를 하면 최대 즉 177보다 큰 값을 찾는다
                        SELECT height
                        FROM student
                        WHERE grade = 4
                    );
                    
--4. EXISTS 연산자를 이용한 다중 행 서브쿼리
SELECT profno, name, sal, comm,position
FROM   professor
WHERE EXISTS (
                SELECT position
                FROM   professor
                WHERE  comm is not null
              );
              
--보직수당을 받는 교수가 한 명이라도 있으면 모든 교수의 교수 번호, 이름, 보직수당 그리고 급여와 보직수당의 합을 출력하여라
SELECT profno,name,comm,sal+nvl(comm,0)
FROM   professor
WHERE EXISTS (
                SELECT name
                FROM   professor
                WHERE  comm is not null
              );
                
--PAIRWISE 다중 칼럼 서브쿼리
--PAIRWISE 비교 방법에 의해 학년별로 몸무게가 최소인 학생의 이름, 학년, 몸무게를 출력하여라
SELECT name,grade,weight
FROM   student
WHERE  (grade,weight) IN ( 
                            SELECT grade,MIN(weight)
                            FROM   student
                            GROUP BY grade
                          );

--상호연관 서브쿼리
--메인쿼리절과 서브쿼리간에 검색 결과를 교환하는 서브쿼리
-- 각 학과 학생의 평균 키보다 키가 큰 학생의 이름, 학과 번호, 키를 출력하여라
SELECT deptno,name,grade,height
FROM   student s1
WHERE height > (
                    SELECT AVG(height)
                    FROM   student s2
                    WHERE  s2.deptno = s1.deptno
                )
ORDER BY deptno;        

--1. Blake와 같은 부서에 있는 모든 사원에 대해서 사원 이름과 입사일을 디스플레이하라
SELECT ename,hiredate
FROM emp
WHERE deptno = (
                    SELECT deptno
                    FROM emp
                    WHERE INITCAP(ename) = 'Blake'
                );
--2. 평균 급여 이상을 받는 모든 사원에 대해서 사원 번호와 이름을 디스플레이하는 질의문을 생성하라. 
--단 출력은 급여 내림차순 정렬하라
SELECT empno,ename
FROM emp
WHERE sal > (
                SELECT avg(sal)
                FROM emp
             )
ORDER BY   sal desc;           
--3. 부서 번호와 급여가 보너스를 받는 어떤 사원의 부서 번호와 급여에 일치하는 사원의 이름, 부서 번호 그리고 급여를 디스플레이하라.
SELECT ename,deptno,sal
FROM emp
WHERE (deptno,sal) IN (
                        SELECT deptno,sal
                        FROM emp
                        WHERE comm>0
                       );

             


















