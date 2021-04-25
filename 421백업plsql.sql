----Oracle 부분 Backup 
--(cmd에서 cd C:\orabackup 를 해서 백업할 폴더로가고 cmd 에서 명령어를 입력 디벨로퍼에서 하는거아님!!cmd에서)
exp scott/tiger file = student.dmp tables = student
-- Oracle 부분 Restore
--(cmd에서 cd C:\orabackup 를 해서 백업할 폴더로가고 cmd 에서 명령어를 입력 디벨로퍼에서 하는거아님!!cmd에서)
imp scott/tiger file = student.dmp tables = student
-- Oracle 전체 Backup
--(cmd에서 cd C:\orabackup 를 해서 백업할 폴더로가고 cmd 에서 명령어를 입력 디벨로퍼에서 하는거아님!!cmd에서)
EXPDP scott/tiger Directory = mdBackup7 DUMPFILE = scott.dmp
--Oracle 전체 Restore
--(cmd에서 cd C:\orabackup 를 해서 백업할 폴더로가고 cmd 에서 명령어를 입력 디벨로퍼에서 하는거아님!!cmd에서)
IMPDP scott/tiger Directory = mdBackup7 DUMPFILE = scott.dmp



----------PL/SQL
--- 1. 함수(Function)
--- 특정한 수에 세금을 7%로 계산하는 Function을 작성하면 
--                 FUNCTION FUNCTION명

CREATE OR REPLACE FUNCTION tax
    (v_num in number)           --Parameter
RETURN number                   --Return Value
IS
    v_tax   number;             --변수 선언
BEGIN                           --함수 시작
    v_tax := v_num * 0.07;
    RETURN(v_tax);
END;                            --함수 끝

--2. 함수 호출
SELECT tax(200) FROM dual;

--3.Procedure 생성
CREATE OR REPLACE PROCEDURE Emp_Info2
(p_empno IN emp.empno%TYPE,p_ename OUT emp.ename%TYPE,p_sal OUT emp.sal%TYPE)
IS
    --%TYPE 데이터형 변수 선언
    v_empno emp.empno%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    --%TYPE 데이터형 변수 사용
    SELECT empno,ename,sal
    INTO v_empno,p_ename,p_sal
    FROM emp
    WHERE empno = p_empno;
    --결과값 출력
    DBMS_OUTPUT.PUT_LINE('사원번호 : '||v_empno||CHR(10)||CHR(13)||'줄바뀜');
    DBMS_OUTPUT.PUT_LINE('사원이름 : '||p_ename);
    DBMS_OUTPUT.PUT_LINE('사원급여 : '||p_sal);
END;

------------------------------------------------
--1.파라메타 : (p_deptno,p_dname,p_loc)
--2. dept TBL에 Insert Procedure

CREATE OR Replace Procedure Dept_Insert
( p_deptno IN dept.deptno%TYPE , p_dname IN dept.dname%TYPE,p_loc IN dept.loc%TYPE)
IS
BEGIN

  INSERT INTO dept values ( p_deptno,p_dname,p_loc);
  commit;
END;

--1.파라메타 : (p_empno)
--2. emp TBL에 해당사번의 급여를 10% 인상 FUNCTION
--3.Return 인상된 급여
CREATE OR Replace FUNCTION FC_update_sal
( p_empno IN emp.empno%type)
Return emp.sal%type
IS 
  PRAGMA AUTONOMOUS_TRANSACTION; --
  v_sal  emp.sal%type;
BEGIN
  UPDATE emp
  SET sal = sal * 1.1
  WHERE empno =  p_empno;
  commit;
  
  SELECT sal
  INTO v_sal
  FROM emp
  WHERE empno = p_empno;
  Return v_sal;
END;

SELECT FC_update_sal(7369) FROM dual;

--1.파라메타 : (p_empno,p_ename,p_job,p_MGR,p_sal,p_deptno)
--2. emp TBL에 Insert_emp Procedure
--3. v_job = 'MANAGER' ->v_comm :=1000;
--            아니면                150;
--4. Insert ->emp
--5.입사일은 현재일자
CREATE OR Replace PROCEDURE Insert_emp
(p_empno IN emp.empno%type,p_ename  IN emp.ename%type,
 p_job   IN emp.job%type,p_MGR    IN emp.MGR%type,
 p_sal   IN emp.sal%type,p_deptno IN emp.deptno%type)
IS
  v_comm  emp.comm%type;
BEGIN
  IF p_job = 'MANAGER' THEN
     v_comm  := 1000;
  ELSE 
     v_comm  := 150;
  END IF; 
  INSERT INTO emp
  VALUES  (p_empno,p_ename,p_job,p_MGR,sysdate,p_sal,v_comm,p_deptno);
  COMMIT;
END;

--------------------
-- SQL> SET SERVEROUTPUT ON ;
-- 실행 결과
-- SQL> EXECUTE ename_deptno(1003);
-- 사원번호 : 1003
-- 사원이름 : brave
-- 사원부서 : 20
-- 부서명 : Research
-----------------------------------------------------
CREATE OR Replace Procedure ename_deptno
( p_empno IN emp.empno%type)
IS
  v_deptno emp.deptno%type;
  v_ename emp.ename%type;
  v_dname dept.dname%type;
BEGIN
  DBMS_OUTPUT.ENABLE;
    SELECT e.ename,e.deptno,d.dname
    INTO   v_ename,v_deptno,v_dname
    FROM emp e,dept d
    WHERE e.deptno = d.deptno AND e.empno = p_empno;
    DBMS_OUTPUT.PUT_LINE('---------------------');
    DBMS_OUTPUT.PUT_LINE('사원번호 : '||p_empno);
    DBMS_OUTPUT.PUT_LINE('사원이름 : '||v_ename);
    DBMS_OUTPUT.PUT_LINE('사원부서 : '||v_deptno);
    DBMS_OUTPUT.PUT_LINE('부서명 : '||v_dname);
    DBMS_OUTPUT.PUT_LINE('---------------------');
END;


  

























