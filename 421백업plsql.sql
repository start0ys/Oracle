----Oracle �κ� Backup 
--(cmd���� cd C:\orabackup �� �ؼ� ����� �����ΰ��� cmd ���� ��ɾ �Է� �𺧷��ۿ��� �ϴ°žƴ�!!cmd����)
exp scott/tiger file = student.dmp tables = student
-- Oracle �κ� Restore
--(cmd���� cd C:\orabackup �� �ؼ� ����� �����ΰ��� cmd ���� ��ɾ �Է� �𺧷��ۿ��� �ϴ°žƴ�!!cmd����)
imp scott/tiger file = student.dmp tables = student
-- Oracle ��ü Backup
--(cmd���� cd C:\orabackup �� �ؼ� ����� �����ΰ��� cmd ���� ��ɾ �Է� �𺧷��ۿ��� �ϴ°žƴ�!!cmd����)
EXPDP scott/tiger Directory = mdBackup7 DUMPFILE = scott.dmp
--Oracle ��ü Restore
--(cmd���� cd C:\orabackup �� �ؼ� ����� �����ΰ��� cmd ���� ��ɾ �Է� �𺧷��ۿ��� �ϴ°žƴ�!!cmd����)
IMPDP scott/tiger Directory = mdBackup7 DUMPFILE = scott.dmp



----------PL/SQL
--- 1. �Լ�(Function)
--- Ư���� ���� ������ 7%�� ����ϴ� Function�� �ۼ��ϸ� 
--                 FUNCTION FUNCTION��

CREATE OR REPLACE FUNCTION tax
    (v_num in number)           --Parameter
RETURN number                   --Return Value
IS
    v_tax   number;             --���� ����
BEGIN                           --�Լ� ����
    v_tax := v_num * 0.07;
    RETURN(v_tax);
END;                            --�Լ� ��

--2. �Լ� ȣ��
SELECT tax(200) FROM dual;

--3.Procedure ����
CREATE OR REPLACE PROCEDURE Emp_Info2
(p_empno IN emp.empno%TYPE,p_ename OUT emp.ename%TYPE,p_sal OUT emp.sal%TYPE)
IS
    --%TYPE �������� ���� ����
    v_empno emp.empno%TYPE;
BEGIN
    DBMS_OUTPUT.ENABLE;
    --%TYPE �������� ���� ���
    SELECT empno,ename,sal
    INTO v_empno,p_ename,p_sal
    FROM emp
    WHERE empno = p_empno;
    --����� ���
    DBMS_OUTPUT.PUT_LINE('�����ȣ : '||v_empno||CHR(10)||CHR(13)||'�ٹٲ�');
    DBMS_OUTPUT.PUT_LINE('����̸� : '||p_ename);
    DBMS_OUTPUT.PUT_LINE('����޿� : '||p_sal);
END;

------------------------------------------------
--1.�Ķ��Ÿ : (p_deptno,p_dname,p_loc)
--2. dept TBL�� Insert Procedure

CREATE OR Replace Procedure Dept_Insert
( p_deptno IN dept.deptno%TYPE , p_dname IN dept.dname%TYPE,p_loc IN dept.loc%TYPE)
IS
BEGIN

  INSERT INTO dept values ( p_deptno,p_dname,p_loc);
  commit;
END;

--1.�Ķ��Ÿ : (p_empno)
--2. emp TBL�� �ش����� �޿��� 10% �λ� FUNCTION
--3.Return �λ�� �޿�
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

--1.�Ķ��Ÿ : (p_empno,p_ename,p_job,p_MGR,p_sal,p_deptno)
--2. emp TBL�� Insert_emp Procedure
--3. v_job = 'MANAGER' ->v_comm :=1000;
--            �ƴϸ�                150;
--4. Insert ->emp
--5.�Ի����� ��������
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
-- ���� ���
-- SQL> EXECUTE ename_deptno(1003);
-- �����ȣ : 1003
-- ����̸� : brave
-- ����μ� : 20
-- �μ��� : Research
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
    DBMS_OUTPUT.PUT_LINE('�����ȣ : '||p_empno);
    DBMS_OUTPUT.PUT_LINE('����̸� : '||v_ename);
    DBMS_OUTPUT.PUT_LINE('����μ� : '||v_deptno);
    DBMS_OUTPUT.PUT_LINE('�μ��� : '||v_dname);
    DBMS_OUTPUT.PUT_LINE('---------------------');
END;


  

























