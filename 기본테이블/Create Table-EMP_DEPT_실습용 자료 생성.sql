rem  �ǽ� ��ũ��Ʈ
rem  CONNECT hr/hr

DROP TABLE EMP;
DROP TABLE DEPT;
DROP TABLE BONUS;
DROP TABLE SALGRADE;

CREATE TABLE DEPT
        (DEPTNO NUMBER(2) CONSTRAINT PK_DEPT PRIMARY KEY,
         DNAME VARCHAR2(14),
	     LOC   VARCHAR2(13) ) ;
CREATE TABLE EMP
    (EMPNO NUMBER(4) CONSTRAINT PK_EMP PRIMARY KEY,
	 ENAME VARCHAR2(10),
 	 JOB   VARCHAR2(9),
	 MGR   NUMBER(4),
	 HIREDATE DATE,
	 SAL   NUMBER(7,2),
	 COMM  NUMBER(7,2),
	 DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);

CREATE TABLE EMP3
    (         EMPNO    NUMBER(4)    CONSTRAINT PK_EMP3 PRIMARY KEY,
	 ENAME     VARCHAR2(10),
 	 JOBNo     VARCHAR2(2),
	 FamilyNo   NUMBER(4),
	 HIREDATE DATE,
	 SAL   NUMBER(7,2),
	 COMM  NUMBER(7,2),
	 DEPTNO NUMBER(2) CONSTRAINT FK_DEPTNO REFERENCES DEPT);

CREATE TABLE JOB
	(JOBNo      VARCHAR2(2) CONSTRAINT PK_JOB3 PRIMARY KEY,
	 JOBNM     VARCHAR2(20),
            ) ;
CREATE TABLE Family
	(FamiyNo         VARCHAR2(2) CONSTRAINT FamilyNo3 PRIMARY KEY,
	 FamiyNM        VARCHAR2(20),
            ) ;

CREATE TABLE BONUS
	(ENAME VARCHAR2(10),
	 JOB   VARCHAR2(9),
	 SAL   NUMBER,
	 COMM  NUMBER) ;    

CREATE TABLE SALGRADE
    (GRADE NUMBER,
	 LOSAL NUMBER,
	 HISAL NUMBER );

INSERT INTO DEPT VALUES (10,'ACCOUNTING','NEW YORK');
INSERT INTO DEPT VALUES (20,'RESEARCH','DALLAS');
INSERT INTO DEPT VALUES (30,'SALES','CHICAGO');
INSERT INTO DEPT VALUES (40,'OPERATIONS','BOSTON');

INSERT INTO EMP VALUES
(7369,'SMITH','CLERK',    7902,to_date('17-12-1980','dd-mm-yyyy'),800,NULL,20);
INSERT INTO EMP VALUES
(7499,'ALLEN','SALESMAN', 7698,to_date('20-02-1981', 'dd-mm-yyyy'),1600,300,30);
INSERT INTO EMP VALUES
(7521,'WARD','SALESMAN',  7698,to_date('22-02-1981', 'dd-mm-yyyy'),1250,500,30);
INSERT INTO EMP VALUES
(7566,'JONES','MANAGER',  7839,to_date('02-04-1981',  'dd-mm-yyyy'),2975,NULL,20);
INSERT INTO EMP VALUES
(7654,'MARTIN','SALESMAN',7698,to_date('28-09-1981', 'dd-mm-yyyy'),1250,1400,30);
INSERT INTO EMP VALUES
(7698,'BLAKE','MANAGER',  7839,to_date('01-05-1981',  'dd-mm-yyyy'),2850,NULL,30);
INSERT INTO EMP VALUES
(7782,'CLARK','MANAGER',  7839,to_date('09-06-1981',  'dd-mm-yyyy'),2450,NULL,10);
INSERT INTO EMP VALUES
(7788,'SCOTT','ANALYST',  7566,to_date('13-07-1987', 'dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7839,'KING','PRESIDENT', NULL,to_date('17-11-1981','dd-mm-yyyy'),5000,NULL,10);
INSERT INTO EMP VALUES
(7844,'TURNER','SALESMAN',7698,to_date('08-09-1981',  'dd-mm-yyyy'),1500,0,30);
INSERT INTO EMP VALUES
(7876,'ADAMS','CLERK',    7788,to_date('13-07-1987', 'dd-mm-yyyy'),1100,NULL,20);
INSERT INTO EMP VALUES
(7900,'JAMES','CLERK',    7698,to_date('03-12-1981', 'dd-mm-yyyy'),950,NULL,30);
INSERT INTO EMP VALUES
(7902,'FORD','ANALYST',   7566,to_date('03-12-1981', 'dd-mm-yyyy'),3000,NULL,20);
INSERT INTO EMP VALUES
(7934,'MILLER','CLERK',   7782,to_date('23-01-1982', 'dd-mm-yyyy'),1300,NULL,10);

INSERT INTO SALGRADE VALUES (1, 700,1200);
INSERT INTO SALGRADE VALUES (2,1201,1400);
INSERT INTO SALGRADE VALUES (3,1401,2000);
INSERT INTO SALGRADE VALUES (4,2001,3000);
INSERT INTO SALGRADE VALUES (5,3001,9999);

COMMIT;
rem EXIT






alter session set nls_language='AMERICAN'; 

/*************************************************************************
* ������ ����� �ִ� STUDENT, PROFESSOR, DEPARTMENT, SALGRADE ���̺� ����
*************************************************************************/

DROP TABLE STUDENT;
DROP TABLE PROFESSOR;
DROP TABLE DEPARTMENT;
DROP TABLE SALGRADE;


/*************************************************************************
*                         STUDNET ���̺� ����
*************************************************************************/
CREATE TABLE STUDENT
        (STUDNO NUMBER(5)  CONSTRAINT PK_STUDNO PRIMARY KEY,
         NAME VARCHAR2(20),
         USERID varchar2(10),
         GRADE VARCHAR2(1),
         IDNUM VARCHAR2(13),
         BIRTHDATE DATE,
         TEL VARCHAR2(13),
         HEIGHT NUMBER(5,2),
         WEIGHT NUMBER(5,2),
         DEPTNO NUMBER(4),
         PROFNO NUMBER(4));


/*************************************************************************
*                        STUDNET ���̺� ������ �Է�
*************************************************************************/
INSERT INTO STUDENT VALUES
        (10101, '������', 'jun123', '4', '7907021369824',
        TO_DATE('02-JUL-1979','DD-MON-YYYY'), '051)781-2158', 176, 72, '101',9903);

INSERT INTO STUDENT VALUES
        (20101, '�̵���', 'Dals', '1', '8312101128467',
         TO_DATE('10-DEC-1983','DD-MON-YYYY'), '055)426-1752', 172, 64, '201',NULL);

INSERT INTO STUDENT VALUES
        (10102, '�ڹ̰�', 'ansel414', '1', '8405162123648',
        TO_DATE('16-MAY-1984','DD-MON-YYYY'), '055)261-8947', 168, 52, '101',NULL);

INSERT INTO STUDENT VALUES
        (10103, '�迵��', 'mandu', '3', '8103211063421',
        TO_DATE('11-JAN-1981','DD-MON-YYYY'), '051)824-9637', 170, 88 ,'101',9906);

INSERT INTO STUDENT VALUES
        (20102, '�ڵ���', 'Ping2', '1', '8511241639826',
        TO_DATE('24-NOV-1985','DD-MON-YYYY'), '051)742-6384', 182, 70, '201',NULL);

INSERT INTO STUDENT VALUES
        (10201, '������', 'simply', '2', '8206062186327',
        TO_DATE('06-JUN-1982','DD-MON-YYYY'), '055)419-6328', 164, 48, '102',9905);
INSERT INTO STUDENT VALUES
        (10104, '������', 'Gomo00', '2', '8004122298371',
        TO_DATE('12-APR-1980','DD-MON-YYYY'), '055)418-9627', 161, 42, '101',9907);

INSERT INTO STUDENT VALUES
        (10202, '������', 'yousuk', '4', '7709121128379',
        TO_DATE('12-OCT-1977','DD-MON-YYYY'), '051)724-9618', 177, 92, '102',9905);

INSERT INTO STUDENT VALUES
        (10203, '�ϳ���', 'hanal', '1', '8501092378641',
        TO_DATE('18-DEC-1984','DD-MON-YYYY'), '055)296-3784', 160, 68, '102',NULL);

INSERT INTO STUDENT VALUES
        (10105, '������', 'YouJin12', '2', '8301212196482',
        TO_DATE('21-JAN-1983','DD-MON-YYYY'), '02)312-9838', 171, 54, '101',9907);

INSERT INTO STUDENT VALUES
        (10106, '������', 'seolly', '1', '8511291186273',
        TO_DATE('29-NOV-1985','DD-MON-YYYY'), '051)239-4861', 186, 72, '101',NULL);

INSERT INTO STUDENT VALUES
        (10204, '������', 'Samba7', '3', '7904021358671',
        TO_DATE('02-APR-1979','DD-MON-YYYY'), '053)487-2698', 171, 70, '102',9905);
 
INSERT INTO STUDENT VALUES
        (10107, '�̱���', 'huriky', '4', '8109131276431',
        TO_DATE('13-OCT-1981','DD-MON-YYYY'), '055)736-4981', 175, 92, '101',9903);

INSERT INTO STUDENT VALUES
        (20103, '������', 'lovely', '2', '8302282169387',
        TO_DATE('28-FEB-1983','DD-MON-YYYY'), '052)175-3941', 166, 51, '201',9902);

INSERT INTO STUDENT VALUES
        (20104, '������', 'Rader214', '1', '8412141254963',
        TO_DATE('16-SEP-1984','DD-MON-YYYY'), '02)785-6984', 184, 62, '201',NULL);

INSERT INTO STUDENT VALUES
        (10108, '������', 'cleanSky', '2', '8108192157498',
        TO_DATE('19-AUG-1981','DD-MON-YYYY'), '055)248-3679', 162, 72, '101',9907);

 

/*************************************************************************
*                         PROFESSOR ���̺� ����
*************************************************************************/
CREATE TABLE PROFESSOR
        (PROFNO NUMBER(4)  CONSTRAINT PK_PROFNO PRIMARY KEY,
         NAME VARCHAR2(10),
         USERID VARCHAR2(10),
         POSITION VARCHAR2(20),
         SAL NUMBER(10),
         HIREDATE DATE,
         COMM NUMBER(2),
         DEPTNO NUMBER(4));


/*************************************************************************
*                        ROFESSOR ���̺� ������ �Է�
*************************************************************************/
INSERT INTO PROFESSOR VALUES
        (9901, '�赵��', 'capool', '����', 500,
        TO_DATE('24-01-1982','DD-MM-YYYY'), 20, 101);

INSERT INTO PROFESSOR VALUES
        (9902, '�����', 'sweat413', '������', 320,
        TO_DATE('12-04-1995','DD-MM-YYYY'), NULL, 201);

INSERT INTO PROFESSOR VALUES
        (9903, '������', 'Pascal', '������', 360,
        TO_DATE('17-05-1993','DD-MM-YYYY'), 15, 101);

INSERT INTO PROFESSOR VALUES
        (9904, '���Ͽ�', 'Blue77', '���Ӱ���', 240,
        TO_DATE('02-12-1998','DD-MM-YYYY'), NULL, 102);

INSERT INTO PROFESSOR VALUES
        (9905, '������', 'refresh', '����', 450,
        TO_DATE('08-01-1986','DD-MM-YYYY'), 25, 102);

INSERT INTO PROFESSOR VALUES
        (9906, '�̸���', 'Pocari', '�α���', 420,
        TO_DATE('13-09-1988','DD-MM-YYYY'), NULL, 101);

INSERT INTO PROFESSOR VALUES
        (9907, '������', 'totoro', '���Ӱ���', 210,
        TO_DATE('01-01-2001','DD-MM-YYYY'), NULL, 101);

INSERT INTO PROFESSOR VALUES
        (9908, '������', 'Bird13', '�α���', 400,
        TO_DATE('18-11-1990','DD-MM-YYYY'), 17, 202);


/*************************************************************************
*                          DEPARTMENT ���̺� ����
*************************************************************************/
CREATE TABLE DEPARTMENT
        (DEPTNO NUMBER(4)  CONSTRAINT PK_DEPTNO PRIMARY KEY,
         DNAME VARCHAR2(30),
         COLLEGE NUMBER(4),
         LOC VARCHAR2(10));

/*************************************************************************
*                        DEPARTMENT ���̺� ������ �Է�
*************************************************************************/
INSERT INTO DEPARTMENT VALUES
        (101, '��ǻ�Ͱ��а�', 100, '1ȣ��');

INSERT INTO DEPARTMENT VALUES
        (102, '��Ƽ�̵���а�', 100, '2ȣ��');

INSERT INTO DEPARTMENT VALUES
        (201, '���ڰ��а�', 200, '3ȣ��');

INSERT INTO DEPARTMENT VALUES
        (202, '�����а�', 200, '4ȣ��');

INSERT INTO DEPARTMENT VALUES
        (100, '�����̵���к�', 10, NULL);

INSERT INTO DEPARTMENT VALUES
        (200, '��īƮ�δн��к�', 10, NULL);

INSERT INTO DEPARTMENT VALUES
        (10, '��������', NULL, NULL);


/*************************************************************************
*                          SALGRADE ���̺� ����
*************************************************************************/
CREATE TABLE SALGRADE
        (GRADE NUMBER(2)  CONSTRAINT PK_GRADE  PRIMARY KEY,
         LOSAL NUMBER(5),
         HISAL NUMBER(5));

/*************************************************************************
*                         SALGRADE ���̺� ������ �Է�
*************************************************************************/
INSERT INTO SALGRADE VALUES (1, 100, 300);
INSERT INTO SALGRADE VALUES (2, 301, 400);
INSERT INTO SALGRADE VALUES (3, 401, 500);


COMMIT;

