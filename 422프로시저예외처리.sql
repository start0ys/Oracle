-----------------------------------------------------
--  Procedure up_emp 실행 결과
-- SQL> EXECUTE up_emp(1200); --사번
-- 결과 : 급여 인상 저장
--               시작문자
-- 조건 1) job = SALE포함         v_pct : 10
--     2)           MAN         v_pct : 7  
--     3)                       v_pct : 5
--   job에 따른 급여 인상을 수행    sal = sal+sal*v_pct/100
-- 확인 : DB -> TBL
-----------------------------------------------------
CREATE OR REPLACE PROCEDURE up_emp
(p_empno IN emp.empno%type)
IS
  v_pct NUMBER(2);
  v_job emp.job%type;
BEGIN
  SELECT job
  INTO   v_job
  FROM emp
  WHERE empno = p_empno;
  
  IF v_job like 'SALE%' THEN
    v_pct := 10;
  ELSIF v_job like 'MAN%' THEN
    v_pct := 7;
  ELSE 
    v_pct := 5;
  END IF;
  UPDATE emp
  SET sal = sal+sal*v_pct/100
  WHERE empno = p_empno;
  commit;
END;

------------------------------------------------------------
--  EMP 테이블에서 사번을 입력받아 해당 사원의 급여에 따른 세금을 구함.
-- 급여가 1000 미만이면 급여의 5%, 
-- 급여가 2000 미만이면 7%, 
-- 3000 미만이면 9%, 
-- 그 이상은 12%로 세금
--- FUNCTION  emp_tax
-- 1) Parameter : 사번
-- 2) 사번을 가지고 급여를 구함
-- 3) 급여를 가지고 세율 계산 
-- 4) 계산 된 값 Return
-------------------------------------------------------------
CREATE OR REPLACE FUNCTION  emp_tax
( p_empno IN emp.empno%type)
RETURN NUMBER
IS
  v_sal emp.sal%type;
  v_tax emp.sal%type;
BEGIN
  SELECT sal
  INTO   v_sal
  FROM emp
  WHERE empno = p_empno;
  
  IF    v_sal < 1000 THEN
    v_tax := v_sal*0.05;
  ELSIF v_sal < 2000 THEN
    v_tax := v_sal*0.07;
  ELSIF v_sal < 3000 THEN
    v_tax := v_sal*0.09;
  ELSE
    v_tax := v_sal*0.12;
  END IF;

  RETURN (v_tax);
END;

SELECT ename,sal,EMP_TAX(empno) emp_rate
FROM emp;

----------------------------------------------------------
-- SQL> EXECUTE Delete_Test(7900);
-- 사원번호 : 7900
-- 사원이름 : JAMES
-- 입 사 일 : 81/12/03
-- 데이터 삭제 성공
--  1. Parameter : 사번 입력
--  2. 사번 이용해 사원번호 ,사원이름 , 입 사 일 출력
--  3. 사번 해당하는 데이터 삭제 
----------------------------------------------------------

CREATE OR REPLACE PROCEDURE Delete_Test
(p_empno IN emp.empno%type)
Is
  v_ename     emp.ename%type;
  v_hiredate emp.hiredate%type;
BEGIN
  DBMS_OUTPUT.ENABLE;
  SELECT ename,hiredate
  INTO   v_ename,v_hiredate
  FROM   emp
  WHERE  empno = p_empno;
  
  DBMS_OUTPUT.PUT_LINE('사원번호 : '|| p_empno);
  DBMS_OUTPUT.PUT_LINE('사원이름 : '|| v_ename);
  DBMS_OUTPUT.PUT_LINE('입사일 : '|| v_hiredate);
  
  DELETE FROM emp WHERE empno = p_empno;
  
  DBMS_OUTPUT.PUT_LINE('데이터 삭제 성공');
  COMMIT;
END;
  
---------------------------------------------------------
-- SQL> EXECUTE Dept_Search(7900);
-- Sales 부서 사원입니다.
-- SQL> EXECUTE Dept_Search(7566);
-- ACCOUNTING 부서 사원입니다.
---------------------------------------------------------
CREATE OR REPLACE  PROCEDURE Dept_Search
(p_empno IN emp.empno%TYPE )
IS
    v_dname     dept.dname%type ;
BEGIN
    DBMS_OUTPUT.ENABLE;
    SELECT    d.dname
    INTO      v_dname     
    FROM     emp e, dept d
    WHERE   empno = p_empno
    AND       e.deptno = d.deptno;
   
    DBMS_OUTPUT.PUT_LINE(v_dname||'  부서 사원입니다. ' );

  
END ;

---------------------------------------------------------
-- 행동강령 : 부서번호 입력 해당 emp 정보
-- SQL> EXECUTE DeptEmpSearch(50);
--  조회화면 :   사번  : 1000
--             이름  : 강감찬 
-- 예외처리
-- 두개의 Row가 나타날수 있음

CREATE OR REPLACE PROCEDURE DeptEmpSearch
(p_deptno IN emp.deptno%type)
IS
  v_emp emp%ROWTYPE;
  --원래 밑에 처럼 하지만 자주변할때 위에처럼하면 다 사용할수있다 객체개념
--  v_empno emp.empno%type;
--  v_ename emp.ename%type;
BEGIN
  DBMS_OUTPUT.ENABLE;
  SELECT *
  INTO  v_emp
  FROM  emp
  WHERE deptno = p_deptno;
  
  DBMS_OUTPUT.PUT_LINE('사번 : ' || v_emp.empno);
  DBMS_OUTPUT.PUT_LINE('사번 : ' || v_emp.ename);
  
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERR CODE 1 : ' || TO_CHAR(SQLCODE));
    DBMS_OUTPUT.PUT_LINE('ERR CODE 2 : ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('ERR MESSAGE : ' || SQLERRM);
END;



------------Cursor
---------------------------------------------------------
-- EXECUTE 문을 이용해 함수를 실행합니다.
-- SQL>EXECUTE show_emp3(7900);
---------------------------------------------------------
CREATE OR REPLACE PROCEDURE show_emp3
(p_empno IN emp.empno%type)
IS
  --1.DECLARE(선언)
  CURSOR emp_cursor IS
  SELECT ename,job,sal
  FROM emp
  WHERE empno LIKE p_empno||'%';
  
  v_ename emp.ename%type;
  v_sal   emp.sal%type;
  v_job   emp.job%type;
BEGIN
  DBMS_OUTPUT.ENABLE;
  --2.OPEN
  OPEN emp_cursor;
    DBMS_OUTPUT.PUT_LINE('이름    '||' 업무   '||'  급여  ');
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
  LOOP
  --3.FETCH 
    FETCH emp_cursor INTO v_ename,v_job,v_sal;
    EXIT WHEN emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_ename||' '||v_job||' '||v_sal);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT||'개의 행 선택');
  CLOSE emp_cursor;
END;

-----
SELECT empno,ename,job,sal
FROM emp
WHERE empno LIKE '1'||'%';

-----------------------------------------------------
-- Fetch 문 
-- SQL> EXECUTE  Cur_sal_Hap (20);
-- 부서만큼 반복 
-- 	부서명 : ACCOUNTING
-- 	인원수 : 5
-- 	급여합 : 5000
-- 	데이터 입력 성공
-----------------------------------------------------
CREATE OR REPLACE PROCEDURE Cur_sal_Hap
(p_deptno IN emp.deptno%type)
IS
  CURSOR emp_cursor IS
  SELECT d.dname,count(*),sum(e.sal)
  FROM emp e ,dept d
  WHERE e.deptno = d.deptno
  AND   e.deptno = p_deptno
  GROUP BY d.dname;
  
  v_dname dept.dname%type;
  v_count number(2);
  v_sumSal emp.sal%type;
BEGIN
  DBMS_OUTPUT.ENABLE;
  OPEN emp_cursor;
  LOOP
    FETCH emp_cursor INTO v_dname,v_count,v_sumSal;
    EXIT WHEN emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('부서명 : '|| v_dname);
    DBMS_OUTPUT.PUT_LINE('인원수 : '|| v_count);
    DBMS_OUTPUT.PUT_LINE('급여합 : '|| v_sumSal);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('데이터 입력 성공');
  CLOSE emp_cursor;
END;

-----------------------------------------------------------
-- FOR문을 사용하면 커서의 OPEN, FETCH, CLOSE가 자동 발생하므로 따로 
-- 기술할 필요가 없고, 레코드 이름도 자동
--  선언되므로 따로 선언할 필요가 없다.
-----------------------------------------------------------
CREATE OR REPLACE PROCEDURE ForCursor_Test
IS
  CURSOR dept_sum IS
    SELECT b.dname,Count(a.empno) cnt , Sum(a.sal) salary
    FROM   emp a, dept b
    WHERE  a.deptno = b.deptno
    GROUP BY b.dname;
BEGIN
  DBMS_OUTPUT.ENABLE;
  FOR emp_list IN dept_sum LOOP
    DBMS_OUTPUT.PUT_LINE('부서명 : '|| emp_list.dname);
    DBMS_OUTPUT.PUT_LINE('사원수 : '|| emp_list.cnt);
    DBMS_OUTPUT.PUT_LINE('급여합계 : '|| emp_list.salary);
  END LOOP;
  
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM || '에러 발생');
END;


-----------------------------------------------------------
--오라클 PL/SQL은 자주 일어나는 몇가지 예외를 미리 정의해 놓았으며, 
--이러한 예외는 개발자가 따로 선언할 필요가 없다.
--미리 정의된 예외의 종류
-- NO_DATA_FOUND : SELECT문이 아무런 데이터 행을 반환하지 못할 때
-- DUP_VAL_ON_INDEX : UNIQUE 제약을 갖는 컬럼에 중복되는 데이터 INSERT 될 때
-- ZERO_DIVIDE : 0으로 나눌 때
-- INVALID_CURSOR : 잘못된 커서 연산

CREATE OR REPLACE PROCEDURE PreException_test
(v_deptno IN emp.deptno%type)
IS
  v_emp emp%ROWTYPE;
BEGIN
  DBMS_OUTPUT.ENABLE;
  
  SELECT empno,ename,deptno
  INTO v_emp.empno,v_emp.ename,v_emp.deptno
  FROM emp
  WHERE deptno = v_deptno;
  
  DBMS_OUTPUT.PUT_LINE('사번 : '|| v_emp.empno);
  DBMS_OUTPUT.PUT_LINE('이름 : '|| v_emp.ename);
  DBMS_OUTPUT.PUT_LINE('부서번호 : '|| v_emp.deptno);
  
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('중복 데이터가 존재 합니다.');
      DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX 에러 발생');
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS 에러 발생');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND 에러 발생');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('기타 에러 발생');
END;


CREATE OR Replace Procedure in_emp
(v_name In emp.ename%type,v_sal In emp.sal%type,v_job In emp.job%type)
IS
  V_empno emp.empno%type;
  lowsal_err EXCEPTION;
BEGIN
  DBMS_OUTPUT.ENABLE;
  SELECT MAX(empno)+1
  INTO v_empno
  FROM emp;
  
  IF v_sal >= 1000 THEN
    INSERT INTO emp(empno,ename,sal,job,deptno,hiredate)
    VALUES (v_empno,v_name,v_sal,v_job,10,sysdate);
  ELSE
    RAISE lowsal_err;
  END IF;
  EXCEPTION
    WHEN lowsal_err THEN
    DBMS_OUTPUT.PUT_LINE('ERROR 지정한 급여가 너무 적습니다 1000이상으로 다시입력하세요.');
END;

----------------------------------------------------------
-- 오라클 저장함수 RAISE_APPLICATION_ERROR를 사용하여 
-- 오류코드 -20000부터 -20999의 범위 내에서 사용자
-- 정의 예외를 만들수 있다.
-- STEP 1 : 예외의 이름을 선언 (선언절)
-- STEP 2 : RAISE문을 사용하여 직접적으로 예외를 발생시킨다(실행절)
-- STEP 3 : 예외가 발생할 경우 해당 예외를 참조한다(예외절)
----------------------------------------------------------


CREATE OR REPLACE PROCEDURE User_Exception
(v_deptno IN emp.deptno%type )
IS
  --예외의 이름을 선언
  user_define_error EXCEPTION;
  cnt NUMBER;
BEGIN
  DBMS_OUTPUT.ENABLE;
  SELECT COUNT(empno)
  INTO cnt
  FROM emp
  WHERE deptno = v_deptno;
  IF cnt < 5 THEN
    --RAISE문을 사용하여 직접적으로 예외를 발생시킨다
    RAISE user_define_error;
  ELSE
    DBMS_OUTPUT.PUT_LINE('조직의 직무향상 하셈');
  END IF;
  
  EXCEPTION
  --예외가 발생할 경우 해당 예외를 참조한다.
  WHEN user_define_error THEN
    RAISE_APPLICATION_ERROR(-20001, '부서에 인원 충당해주세요');
END;


-- 1. parameter : p_deptno(5)
-- 2. 실행결과 
--      부서명 : proc1
--      사원수 : 1
--      평균급여 : 3000
--      부서명 : 회계
--      사원수 : 2
--      평균급여 : 5250
--      조회Count1 : 2
-- 3. CURSOR dept_avg
CREATE OR REPLACE  PROCEDURE Cursor_EMPDept2
(p_deptno emp.deptno%type)
IS
  CURSOR dept_avg IS
  SELECT d.dname,count(*) cnt ,avg(e.sal) avg_sal
  FROM emp e, dept d
  WHERE e.deptno = d.deptno
  AND   e.deptno LIKE p_deptno||'%'
  GROUP BY d.dname;
  
  v_dname dept.dname%type;
  v_cnt   NUMBER;
  v_avg_sal emp.sal%type;
BEGIN
  DBMS_OUTPUT.ENABLE;
  OPEN dept_avg;
  LOOP
    FETCH dept_avg INTO v_dname,v_cnt,v_avg_sal;
    EXIT WHEN dept_avg%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('부서명 : '|| v_dname);
    DBMS_OUTPUT.PUT_LINE('인원수 : '|| v_cnt);
    DBMS_OUTPUT.PUT_LINE('급여합 : '|| v_avg_sal);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('조회Count :'||dept_avg%ROWCOUNT);
  CLOSE dept_avg;
  EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러발생');
END;













  