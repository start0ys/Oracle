--- Admin ����� ���� / ���� �ο�
-- 1-1. USER ����
CREATE USER usertest01 IDENTIFIED BY tiger;
CREATE USER usertest02 IDENTIFIED BY tiger;
CREATE USER usertest03 IDENTIFIED BY tiger;
CREATE USER usertest04 IDENTIFIED BY tiger;
-- 2-1. sesstion ���� �ο�
GRANT CREATE session to usertest01;
GRANT CREATE session , CREATE table , CREATE VIEW to usertest02;
GRANT CREATE session , CREATE table , CREATE VIEW to usertest03;
-- 2-2. ���忡�� DBA�� �����ڿ��� ���Ѻο� (����)--��
GRANT CONNECT , RESOURCE to usertest04;
-- 2-3. �� SELECT ���� �ο� �����ڿ��� ���Ѻο�
GRANT SELECT on scott.emp TO usertest02 WITH GRANT OPTION;
-- 3.Table ���� ���� �ο�
GRANT CREATE table to usertest01;
-- 4.Table Space ���� �Ҵ� (�ڵ�ƴ� ������ �ٽ���)
ALTER USER usertest01 quota 2m on user;





-- Scott Emp ��ȸ
SELECT * FROM emp; --�ȵ�
SELECT * FROM scott.emp; --��




-------------------------------------------------------------
--- EXAM
------------------------------------------------
--  1. tiger/tiger ���� ����
CREATE USER tiger IDENTIFIED BY tiger;
-- 2.���� �ο� ROLE --> connect, Resource
GRANT connect, Resource TO tiger;
-- 3. scott�� �ִ� student TBL�� Read ���� tiger �ּ���
GRANT SELECT on scott.student TO tiger;

---- ���� ȸ��
REVOKE SELECT on scott.student FROM tiger;
--usertest02�� ���� �� �༮�鵵 �� ���� ȸ��
REVOKE SELECT on scott.emp FROM usertest02 CASCADE CONSTRAINTS;



-----------���Ǿ�
--���Ǿ�� ����(Alias) ������
--���Ǿ�� �����ͺ��̽� ��ü���� ����� �� �ִ� ��ü
--������ �ش� SQL ��ɹ������� ���

CREATE TABLE sampleTBL(
    meno VARCHAR2(50)
    );
INSERT INTO sampleTBL VALUES('���� Ǫ��');    
INSERT INTO sampleTBL VALUES('����� ��������');

GRANT SELECT on sampleTBL TO scott;










