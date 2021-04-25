-----트리거
CREATE OR Replace TRIGGER triger_test
BEFORE
UPDATE ON dept
FOR EACH ROW -- old,new 사용하기 위해
BEGIN
  DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값 : '|| :old.dname);
  DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값 : '|| :new.dname);
END;

UPDATE dept 
SET dname='영업' 
WHERE deptno=11;
-----------------------------------
CREATE TABLE logtable(
	"DEPTNO" NUMBER(2,0), 
  "oldDNAME" VARCHAR2(20),
	"newDNAME" VARCHAR2(20));
  
CREATE OR Replace TRIGGER triger_test
BEFORE
UPDATE ON dept
FOR EACH ROW -- old,new 사용하기 위해
BEGIN
  DBMS_OUTPUT.PUT_LINE('변경 전 컬럼 값 : '|| :old.dname);
  DBMS_OUTPUT.PUT_LINE('변경 후 컬럼 값 : '|| :new.dname);
  INSERT INTO logtable values (:old.deptno,:old.dname,:new.dname);
END;

UPDATE dept 
SET dname='회계3' 
WHERE deptno=11;
----------------------------------------------------------
--문제 ) emp Table의 급여가 변화시
--       화면에 출력하는 Trigger 작성( emp_sal_change)
--       emp Table 수정전
--      조건 : 입력시는 empno가 0보다 커야함

--출력결과 예시
--     이전급여  : 10000
--     신  급여  : 15000
 --    급여 차액 :  5000
----------------------------------------------------------

CREATE OR REPLACE Trigger emp_sal_change
BEFORE DELETE OR INSERT OR UPDATE ON emp
FOR EACH ROW
  WHEN (new.empno>0)
  DECLARE 
        sal_diff  number;
BEGIN
  sal_diff := :new.sal - :old.sal;
  DBMS_OUTPUT.PUT_LINE('이전 급여 : '|| :old.sal);
  DBMS_OUTPUT.PUT_LINE('신  급여 : '|| :new.sal);
  DBMS_OUTPUT.PUT_LINE('급여 차액 : '|| sal_diff);
END;

UPDATE emp
SET sal = 1000
WHERE empno = 7369;
-----------------------------------------------------------
--  EMP 테이블에 INSERT,UPDATE,DELETE문장이 하루에 몇 건의 ROW가 발생되는지 조사
--  조사 내용은 EMP_ROW_AUDIT에 
--  ID ,사용자 이름, 작업 구분,작업 일자시간을 저장하는 
--  트리거를 작성
-----------------------------------------------------------
CREATE SEQUENCE emp_row_seq;

CREATE TABLE emp_row_audit(
  e_id    NUMBER(6)    CONSTRAINT emp_row_pk PRIMARY KEY,
  e_name  VARCHAR2(30),
  e_gubun VARCHAR2(10),
  e_date  DATE
  );

CREATE OR Replace Trigger emp_row_aud
AFTER insert OR update OR delete ON emp
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO emp_row_audit
           VALUES (emp_row_seq.nextval,:old.ename,'inserting',sysdate);
  ELSIF UPDATING THEN
    INSERT INTO emp_row_audit
           VALUES (emp_row_seq.nextval,:old.ename,'updating',sysdate);
  ELSIF DELETING THEN
    INSERT INTO emp_row_audit
           VALUES (emp_row_seq.nextval,:old.ename,'deleting',sysdate);
  END IF;
END;

UPDATE emp
SET ename = 'trigger1'
WHERE empno = 1200;

INSERT INTO emp(empno,ename,sal,deptno)
       VALUES (3000,'둘리',3500,50);

DELETE emp WHERE empno = 1200;

-------패키지
--- 1.Header -->  역할 : 선언 (Interface 역할)
--                여러 PROCEDURE 선언 가능

Create OR Replace PACKAGE emp_info AS
  Procedure all_emp_info; --모든 사원의 사원정보
  Procedure all_sal_info; --모든 사원의 급여정보
  Procedure dept_emp_info(p_deptno IN number); 
  Procedure dept_sal_info(p_deptno IN number); 
END emp_info;

-- 2.Body 역할 : 실제구현
-----------------------------------------------------------------
    -- 모든 사원의 사원 정보(사번, 이름, 입사일)
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> 각각 줄 바꾸어 사번,이름,입사일 
-----------------------------------------------------------------
Create OR Replace PACKAGE BODY emp_info AS
  Procedure all_emp_info
  IS
    Cursor emp_cursor IS
      Select empno,ename,to_char(hiredate,'YYYY/MM/DD') hiredate
      From emp
      Order By hiredate;
  BEGIN
    DBMS_OUTPUT.ENABLE;
    For emp IN emp_cursor LOOP
      DBMS_OUTPUT.PUT_LINE('사번 :'|| emp.empno);
      DBMS_OUTPUT.PUT_LINE('성명 :'|| emp.ename);
      DBMS_OUTPUT.PUT_LINE('입사일 :'|| emp.hiredate);
    END LOOP;
    
    Exception
    When Others Then
      DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생');
  END all_emp_info;
END emp_info;
-----------------------------------------------------------------
    -- 모든 사원의 급여 정보
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> 각각 줄 바꾸어 전체급여평균 , 최대급여금액 , 최소급여금액
   -----------------------------------------------------------------
   Procedure all_sal_info
   IS
    Cursor emp_cursor IS
      Select round(avg(sal),3) avg_sal ,max(sal) max_sal ,min(sal) min_sal
      From emp;
   BEGIN
   DBMS_OUTPUT.ENABLE;
   For emp In emp_cursor LOOP
    DBMS_OUTPUT.PUT_LINE('전체급여평균 :'|| emp.avg_sal);
    DBMS_OUTPUT.PUT_LINE('최대급여금액 :'|| emp.max_sal);
    DBMS_OUTPUT.PUT_LINE('최소급여금액 :'|| emp.min_sal);
   END LOOP;
   Exception
    When Others Then
      DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생');
   END all_sal_info;
  --------이거를 패키지에 복붙..?
-----------------------------------------------------------------
    --특정 부서의 해당하는 사원 정보
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> 특정 부서의 해당하는 사원 사번,이름, 입사일 
   -----------------------------------------------------------------
  Procedure dept_emp_info (p_deptno IN NUMBER)
  IS
    Cursor emp_cursor IS
      Select empno,ename,to_char(hiredate,'YYYY/MM/DD') hiredate
      From emp
      Where deptno = p_deptno;
  BEGIN
    DBMS_OUTPUT.ENABLE;
    For emp In emp_cursor LOOP
      DBMS_OUTPUT.PUT_LINE('사번'||emp.empno);
      DBMS_OUTPUT.PUT_LINE('이름'||emp.ename);
      DBMS_OUTPUT.PUT_LINE('입사일'||emp.hiredate);
    END LOOP;
  END dept_emp_info;
  --------이거를 패키지에 복붙..?   
-----------------------------------------------------------------
    --특정 부서의 급여 정보
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS ->특정 부서의 해당하는 특정부서 급여평균 ,특정부서 최대급여금액,특정부서 최소급여금액
   -----------------------------------------------------------------
  Procedure dept_sal_info (v_deptno IN NUMBER)
  IS
    Cursor emp_cursor Is
    Select d.dname,round(avg(e.sal),3) avg_sal ,max(e.sal) max_sal ,min(e.sal) min_sal
    from emp e, dept d
    Where e.deptno = d.deptno 
    AND e.deptno Like v_deptno||'%'
    Group By d.dname;
  BEGIN
   DBMS_OUTPUT.ENABLE;
   For emp In emp_cursor LOOP
    DBMS_OUTPUT.PUT_LINE('부 서 명 :'|| emp.dname);
    DBMS_OUTPUT.PUT_LINE('전체급여평균 :'|| emp.avg_sal);
    DBMS_OUTPUT.PUT_LINE('최대급여금액 :'|| emp.max_sal);
    DBMS_OUTPUT.PUT_LINE('최소급여금액 :'|| emp.min_sal);
    DBMS_OUTPUT.PUT_LINE('---------------------------------');
   END LOOP;
   Exception
    When Others Then
      DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생');  
  END dept_sal_info;
 --------이거를 패키지에 복붙..?   

   
   
   
   
   
   



