-----------------------------------------------------
--  Procedure up_emp ���� ���
-- SQL> EXECUTE up_emp(1200); --���
-- ��� : �޿� �λ� ����
--               ���۹���
-- ���� 1) job = SALE����         v_pct : 10
--     2)           MAN         v_pct : 7  
--     3)                       v_pct : 5
--   job�� ���� �޿� �λ��� ����    sal = sal+sal*v_pct/100
-- Ȯ�� : DB -> TBL
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
--  EMP ���̺��� ����� �Է¹޾� �ش� ����� �޿��� ���� ������ ����.
-- �޿��� 1000 �̸��̸� �޿��� 5%, 
-- �޿��� 2000 �̸��̸� 7%, 
-- 3000 �̸��̸� 9%, 
-- �� �̻��� 12%�� ����
--- FUNCTION  emp_tax
-- 1) Parameter : ���
-- 2) ����� ������ �޿��� ����
-- 3) �޿��� ������ ���� ��� 
-- 4) ��� �� �� Return
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
-- �����ȣ : 7900
-- ����̸� : JAMES
-- �� �� �� : 81/12/03
-- ������ ���� ����
--  1. Parameter : ��� �Է�
--  2. ��� �̿��� �����ȣ ,����̸� , �� �� �� ���
--  3. ��� �ش��ϴ� ������ ���� 
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
  
  DBMS_OUTPUT.PUT_LINE('�����ȣ : '|| p_empno);
  DBMS_OUTPUT.PUT_LINE('����̸� : '|| v_ename);
  DBMS_OUTPUT.PUT_LINE('�Ի��� : '|| v_hiredate);
  
  DELETE FROM emp WHERE empno = p_empno;
  
  DBMS_OUTPUT.PUT_LINE('������ ���� ����');
  COMMIT;
END;
  
---------------------------------------------------------
-- SQL> EXECUTE Dept_Search(7900);
-- Sales �μ� ����Դϴ�.
-- SQL> EXECUTE Dept_Search(7566);
-- ACCOUNTING �μ� ����Դϴ�.
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
   
    DBMS_OUTPUT.PUT_LINE(v_dname||'  �μ� ����Դϴ�. ' );

  
END ;

---------------------------------------------------------
-- �ൿ���� : �μ���ȣ �Է� �ش� emp ����
-- SQL> EXECUTE DeptEmpSearch(50);
--  ��ȸȭ�� :   ���  : 1000
--             �̸�  : ������ 
-- ����ó��
-- �ΰ��� Row�� ��Ÿ���� ����

CREATE OR REPLACE PROCEDURE DeptEmpSearch
(p_deptno IN emp.deptno%type)
IS
  v_emp emp%ROWTYPE;
  --���� �ؿ� ó�� ������ ���ֺ��Ҷ� ����ó���ϸ� �� ����Ҽ��ִ� ��ü����
--  v_empno emp.empno%type;
--  v_ename emp.ename%type;
BEGIN
  DBMS_OUTPUT.ENABLE;
  SELECT *
  INTO  v_emp
  FROM  emp
  WHERE deptno = p_deptno;
  
  DBMS_OUTPUT.PUT_LINE('��� : ' || v_emp.empno);
  DBMS_OUTPUT.PUT_LINE('��� : ' || v_emp.ename);
  
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('ERR CODE 1 : ' || TO_CHAR(SQLCODE));
    DBMS_OUTPUT.PUT_LINE('ERR CODE 2 : ' || SQLCODE);
    DBMS_OUTPUT.PUT_LINE('ERR MESSAGE : ' || SQLERRM);
END;



------------Cursor
---------------------------------------------------------
-- EXECUTE ���� �̿��� �Լ��� �����մϴ�.
-- SQL>EXECUTE show_emp3(7900);
---------------------------------------------------------
CREATE OR REPLACE PROCEDURE show_emp3
(p_empno IN emp.empno%type)
IS
  --1.DECLARE(����)
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
    DBMS_OUTPUT.PUT_LINE('�̸�    '||' ����   '||'  �޿�  ');
    DBMS_OUTPUT.PUT_LINE('-------------------------------');
  LOOP
  --3.FETCH 
    FETCH emp_cursor INTO v_ename,v_job,v_sal;
    EXIT WHEN emp_cursor%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_ename||' '||v_job||' '||v_sal);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE(emp_cursor%ROWCOUNT||'���� �� ����');
  CLOSE emp_cursor;
END;

-----
SELECT empno,ename,job,sal
FROM emp
WHERE empno LIKE '1'||'%';

-----------------------------------------------------
-- Fetch �� 
-- SQL> EXECUTE  Cur_sal_Hap (20);
-- �μ���ŭ �ݺ� 
-- 	�μ��� : ACCOUNTING
-- 	�ο��� : 5
-- 	�޿��� : 5000
-- 	������ �Է� ����
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
    DBMS_OUTPUT.PUT_LINE('�μ��� : '|| v_dname);
    DBMS_OUTPUT.PUT_LINE('�ο��� : '|| v_count);
    DBMS_OUTPUT.PUT_LINE('�޿��� : '|| v_sumSal);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('������ �Է� ����');
  CLOSE emp_cursor;
END;

-----------------------------------------------------------
-- FOR���� ����ϸ� Ŀ���� OPEN, FETCH, CLOSE�� �ڵ� �߻��ϹǷ� ���� 
-- ����� �ʿ䰡 ����, ���ڵ� �̸��� �ڵ�
--  ����ǹǷ� ���� ������ �ʿ䰡 ����.
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
    DBMS_OUTPUT.PUT_LINE('�μ��� : '|| emp_list.dname);
    DBMS_OUTPUT.PUT_LINE('����� : '|| emp_list.cnt);
    DBMS_OUTPUT.PUT_LINE('�޿��հ� : '|| emp_list.salary);
  END LOOP;
  
  EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE(SQLERRM || '���� �߻�');
END;


-----------------------------------------------------------
--����Ŭ PL/SQL�� ���� �Ͼ�� ��� ���ܸ� �̸� ������ ��������, 
--�̷��� ���ܴ� �����ڰ� ���� ������ �ʿ䰡 ����.
--�̸� ���ǵ� ������ ����
-- NO_DATA_FOUND : SELECT���� �ƹ��� ������ ���� ��ȯ���� ���� ��
-- DUP_VAL_ON_INDEX : UNIQUE ������ ���� �÷��� �ߺ��Ǵ� ������ INSERT �� ��
-- ZERO_DIVIDE : 0���� ���� ��
-- INVALID_CURSOR : �߸��� Ŀ�� ����

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
  
  DBMS_OUTPUT.PUT_LINE('��� : '|| v_emp.empno);
  DBMS_OUTPUT.PUT_LINE('�̸� : '|| v_emp.ename);
  DBMS_OUTPUT.PUT_LINE('�μ���ȣ : '|| v_emp.deptno);
  
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('�ߺ� �����Ͱ� ���� �մϴ�.');
      DBMS_OUTPUT.PUT_LINE('DUP_VAL_ON_INDEX ���� �߻�');
    WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('TOO_MANY_ROWS ���� �߻�');
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('NO_DATA_FOUND ���� �߻�');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('��Ÿ ���� �߻�');
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
    DBMS_OUTPUT.PUT_LINE('ERROR ������ �޿��� �ʹ� �����ϴ� 1000�̻����� �ٽ��Է��ϼ���.');
END;

----------------------------------------------------------
-- ����Ŭ �����Լ� RAISE_APPLICATION_ERROR�� ����Ͽ� 
-- �����ڵ� -20000���� -20999�� ���� ������ �����
-- ���� ���ܸ� ����� �ִ�.
-- STEP 1 : ������ �̸��� ���� (������)
-- STEP 2 : RAISE���� ����Ͽ� ���������� ���ܸ� �߻���Ų��(������)
-- STEP 3 : ���ܰ� �߻��� ��� �ش� ���ܸ� �����Ѵ�(������)
----------------------------------------------------------


CREATE OR REPLACE PROCEDURE User_Exception
(v_deptno IN emp.deptno%type )
IS
  --������ �̸��� ����
  user_define_error EXCEPTION;
  cnt NUMBER;
BEGIN
  DBMS_OUTPUT.ENABLE;
  SELECT COUNT(empno)
  INTO cnt
  FROM emp
  WHERE deptno = v_deptno;
  IF cnt < 5 THEN
    --RAISE���� ����Ͽ� ���������� ���ܸ� �߻���Ų��
    RAISE user_define_error;
  ELSE
    DBMS_OUTPUT.PUT_LINE('������ ������� �ϼ�');
  END IF;
  
  EXCEPTION
  --���ܰ� �߻��� ��� �ش� ���ܸ� �����Ѵ�.
  WHEN user_define_error THEN
    RAISE_APPLICATION_ERROR(-20001, '�μ��� �ο� ������ּ���');
END;


-- 1. parameter : p_deptno(5)
-- 2. ������ 
--      �μ��� : proc1
--      ����� : 1
--      ��ձ޿� : 3000
--      �μ��� : ȸ��
--      ����� : 2
--      ��ձ޿� : 5250
--      ��ȸCount1 : 2
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
    DBMS_OUTPUT.PUT_LINE('�μ��� : '|| v_dname);
    DBMS_OUTPUT.PUT_LINE('�ο��� : '|| v_cnt);
    DBMS_OUTPUT.PUT_LINE('�޿��� : '|| v_avg_sal);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('��ȸCount :'||dept_avg%ROWCOUNT);
  CLOSE dept_avg;
  EXCEPTION 
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM||'�����߻�');
END;













  