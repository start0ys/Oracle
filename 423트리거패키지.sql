-----Ʈ����
CREATE OR Replace TRIGGER triger_test
BEFORE
UPDATE ON dept
FOR EACH ROW -- old,new ����ϱ� ����
BEGIN
  DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : '|| :old.dname);
  DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : '|| :new.dname);
END;

UPDATE dept 
SET dname='����' 
WHERE deptno=11;
-----------------------------------
CREATE TABLE logtable(
	"DEPTNO" NUMBER(2,0), 
  "oldDNAME" VARCHAR2(20),
	"newDNAME" VARCHAR2(20));
  
CREATE OR Replace TRIGGER triger_test
BEFORE
UPDATE ON dept
FOR EACH ROW -- old,new ����ϱ� ����
BEGIN
  DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : '|| :old.dname);
  DBMS_OUTPUT.PUT_LINE('���� �� �÷� �� : '|| :new.dname);
  INSERT INTO logtable values (:old.deptno,:old.dname,:new.dname);
END;

UPDATE dept 
SET dname='ȸ��3' 
WHERE deptno=11;
----------------------------------------------------------
--���� ) emp Table�� �޿��� ��ȭ��
--       ȭ�鿡 ����ϴ� Trigger �ۼ�( emp_sal_change)
--       emp Table ������
--      ���� : �Է½ô� empno�� 0���� Ŀ����

--��°�� ����
--     �����޿�  : 10000
--     ��  �޿�  : 15000
 --    �޿� ���� :  5000
----------------------------------------------------------

CREATE OR REPLACE Trigger emp_sal_change
BEFORE DELETE OR INSERT OR UPDATE ON emp
FOR EACH ROW
  WHEN (new.empno>0)
  DECLARE 
        sal_diff  number;
BEGIN
  sal_diff := :new.sal - :old.sal;
  DBMS_OUTPUT.PUT_LINE('���� �޿� : '|| :old.sal);
  DBMS_OUTPUT.PUT_LINE('��  �޿� : '|| :new.sal);
  DBMS_OUTPUT.PUT_LINE('�޿� ���� : '|| sal_diff);
END;

UPDATE emp
SET sal = 1000
WHERE empno = 7369;
-----------------------------------------------------------
--  EMP ���̺� INSERT,UPDATE,DELETE������ �Ϸ翡 �� ���� ROW�� �߻��Ǵ��� ����
--  ���� ������ EMP_ROW_AUDIT�� 
--  ID ,����� �̸�, �۾� ����,�۾� ���ڽð��� �����ϴ� 
--  Ʈ���Ÿ� �ۼ�
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
       VALUES (3000,'�Ѹ�',3500,50);

DELETE emp WHERE empno = 1200;

-------��Ű��
--- 1.Header -->  ���� : ���� (Interface ����)
--                ���� PROCEDURE ���� ����

Create OR Replace PACKAGE emp_info AS
  Procedure all_emp_info; --��� ����� �������
  Procedure all_sal_info; --��� ����� �޿�����
  Procedure dept_emp_info(p_deptno IN number); 
  Procedure dept_sal_info(p_deptno IN number); 
END emp_info;

-- 2.Body ���� : ��������
-----------------------------------------------------------------
    -- ��� ����� ��� ����(���, �̸�, �Ի���)
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> ���� �� �ٲپ� ���,�̸�,�Ի��� 
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
      DBMS_OUTPUT.PUT_LINE('��� :'|| emp.empno);
      DBMS_OUTPUT.PUT_LINE('���� :'|| emp.ename);
      DBMS_OUTPUT.PUT_LINE('�Ի��� :'|| emp.hiredate);
    END LOOP;
    
    Exception
    When Others Then
      DBMS_OUTPUT.PUT_LINE(SQLERRM||'���� �߻�');
  END all_emp_info;
END emp_info;
-----------------------------------------------------------------
    -- ��� ����� �޿� ����
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> ���� �� �ٲپ� ��ü�޿���� , �ִ�޿��ݾ� , �ּұ޿��ݾ�
   -----------------------------------------------------------------
   Procedure all_sal_info
   IS
    Cursor emp_cursor IS
      Select round(avg(sal),3) avg_sal ,max(sal) max_sal ,min(sal) min_sal
      From emp;
   BEGIN
   DBMS_OUTPUT.ENABLE;
   For emp In emp_cursor LOOP
    DBMS_OUTPUT.PUT_LINE('��ü�޿���� :'|| emp.avg_sal);
    DBMS_OUTPUT.PUT_LINE('�ִ�޿��ݾ� :'|| emp.max_sal);
    DBMS_OUTPUT.PUT_LINE('�ּұ޿��ݾ� :'|| emp.min_sal);
   END LOOP;
   Exception
    When Others Then
      DBMS_OUTPUT.PUT_LINE(SQLERRM||'���� �߻�');
   END all_sal_info;
  --------�̰Ÿ� ��Ű���� ����..?
-----------------------------------------------------------------
    --Ư�� �μ��� �ش��ϴ� ��� ����
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS  -> Ư�� �μ��� �ش��ϴ� ��� ���,�̸�, �Ի��� 
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
      DBMS_OUTPUT.PUT_LINE('���'||emp.empno);
      DBMS_OUTPUT.PUT_LINE('�̸�'||emp.ename);
      DBMS_OUTPUT.PUT_LINE('�Ի���'||emp.hiredate);
    END LOOP;
  END dept_emp_info;
  --------�̰Ÿ� ��Ű���� ����..?   
-----------------------------------------------------------------
    --Ư�� �μ��� �޿� ����
    -- 1. CURSOR  : emp_cursor 
    -- 2. FOR  IN
    -- 3. DBMS ->Ư�� �μ��� �ش��ϴ� Ư���μ� �޿���� ,Ư���μ� �ִ�޿��ݾ�,Ư���μ� �ּұ޿��ݾ�
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
    DBMS_OUTPUT.PUT_LINE('�� �� �� :'|| emp.dname);
    DBMS_OUTPUT.PUT_LINE('��ü�޿���� :'|| emp.avg_sal);
    DBMS_OUTPUT.PUT_LINE('�ִ�޿��ݾ� :'|| emp.max_sal);
    DBMS_OUTPUT.PUT_LINE('�ּұ޿��ݾ� :'|| emp.min_sal);
    DBMS_OUTPUT.PUT_LINE('---------------------------------');
   END LOOP;
   Exception
    When Others Then
      DBMS_OUTPUT.PUT_LINE(SQLERRM||'���� �߻�');  
  END dept_sal_info;
 --------�̰Ÿ� ��Ű���� ����..?   

   
   
   
   
   
   



