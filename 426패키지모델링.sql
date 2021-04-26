/*************************************************************************
*         Master Table   �ŷ�ó(Customer) ���̺� ���� (Package ����)
*************************************************************************/
CREATE TABLE Customer
        (CustomID               VARCHAR2(4) 
         CONSTRAINT PK_CustomID PRIMARY KEY,        -- �ŷ�ó ��ȣ
         CustomNM               VARCHAR2(20),       -- �ŷ�ó �̸�
         CustomOwner            VARCHAR2(20),       -- �ŷ�ó ��ǥ �̸�
         CustomBirthday         VARCHAR2(8),        -- �ŷ�ó ��ǥ ����
         CustomGender           VARCHAR2(1),        -- �ŷ�ó ��ǥ ����
         CustomAddr             VARCHAR2(50),       -- �ŷ�ó �ּ�
         CustomTel              VARCHAR2(20),       -- �ŷ�ó ��ȭ   
         MatchSawon             VARCHAR2(4),        -- �ŷ�ó �����   
         RegiDate               Date                -- ������� 
         );

/*************************************************************************
*             Master Table   �ŷ�ó(Customer) ���̺� ������ �Է�
*************************************************************************/
Insert Into Customer 
Values(1001,'��ȭ���','�迵ȭ','19760108','1','���� ���ʵ�','010-1111-2222','s001',sysdate);
INSERT INTO Customer   VALUES
        (1002, '������', '�ȿ���', '19961208', '2',
        '���� ������', '010-3333-5555', 'S002',SYSDATE);

INSERT INTO Customer   VALUES
        (1003, '����Į', '���ؼ�', '19981108', '1',
        '���� ������', '010-1234-5555', 'S003',SYSDATE);

INSERT INTO Customer   VALUES
        (1004, '������', '�����', '19970708', '1',
        '���� ������', '010-3333-5678', 'S001',SYSDATE);

commit;

/*************************************************************************
*         Master Table   ��ǰ(Product) ���̺� ���� (Package ����)
*************************************************************************/
CREATE TABLE Product
        (ITEM_CODE         VARCHAR2(4)
           CONSTRAINT PK_ITEM_CODE PRIMARY KEY,          -- ��ǰ ��ȣ
         ITEMNAME            VARCHAR2(20),               -- ��ǰ �̸�
         Danga                   NUMBER(8),              -- �ܰ� 
         Special                 VARCHAR2(100),          -- ��ǰ Ư¡
         RegiDate               Date                     -- ������� 
         );

INSERT INTO Product   VALUES
        ('A001', '����ũ', 15000, '���� ��ǰ', SYSDATE);

INSERT INTO Product   VALUES
        ('A002', '����Ŀ', 6000, '��� ��ǰ', SYSDATE);

INSERT INTO Product   VALUES
        ('B001', '�౸��',  25600, '����� ��ǰ', SYSDATE);

INSERT INTO Product   VALUES
        ('B002', '�౸��', 15800, '��ź��  ��ǰ', SYSDATE);

/*************************************************************************
*         Master Table   ���(Sawon) ���̺� ���� (Package ����)
*************************************************************************/
CREATE TABLE Sawon
        (SawonID             VARCHAR2(4)
        CONSTRAINT PK_SawonID  PRIMARY KEY,            -- ��� code
         SawonNM            VARCHAR2(20),              -- ��� �̸�
         SawonBirthday     VARCHAR2(8),                -- ��� ����
         SawonGender       VARCHAR2(1),                -- ��� ����
         SawonAddr          VARCHAR2(50),              -- ��� �ּ�
         SawonTel            VARCHAR2(20),             -- ��� ��ȭ   
         RegiDate               Date                   -- ������� 
         );

INSERT INTO Sawon   VALUES
        ('S001', '�迵��', '19760108', '1',
        '���� ���ʵ�', '010-1113-2222', SYSDATE);

INSERT INTO Sawon   VALUES
        ('S002', '����', '19860108', '1',
        '���� ȫ��', '010-1458-3456', SYSDATE);

INSERT INTO Sawon   VALUES
        ('S003', '�տ���', '19890708', '2',
        '���� �̴�', '010-1133-6677', SYSDATE);
        
-------------------
CREATE TABLE MMSUM30 (
  SUM_YYMM  VARCHAR2(6),
  ITEM_CODE VARCHAR2(4),
  ITEM_GUBN VARCHAR2(1),
  STCK_QTY NUMBER(8),
  SawonID VARCHAR2(4) 
  CONSTRAINT  FK_SawonID1 REFERENCES Sawon, --sawon���̺��� sawonid��(�Ȱ���)�����ҰŶ� ��������
  RegiDate Date, 
  CONSTRAINT FK_ITEM_CODE3 FOREIGN KEY(ITEM_CODE)  REFERENCES Product(ITEM_CODE));
  
ALTER TABLE MMSUM30
ADD Constraint PK_MMSUM30 PRIMARY KEY (SUM_YYMM,ITEM_CODE,ITEM_GUBN); --����Ű ����




-----------------------------------------------------
-----------*************************-----------------------------------------
-----------------------------
--**********************************************************************

create or replace PACKAGE KK_COLLECTION_PKG AS
  g_in_sawonid VARCHAR2(4) := 'S003'; --�տ��� (���� �Է� ��� ����)
  g_prod_cnt NUMBER(9) :=0;-------;
-----------------------------------------------------
--------------------------------------------------------------------------------------                                
  ------- �ൿ���� :    <<<  �� ���Ҹ��� PGM  >>>                       
  -------               1. ������� �԰� ������ �����Ѵ�.(MMSUM30  �⸻��� �Ϳ� �������� �̿� )
  -------               2. ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)������ ���� PGM                          
  -------               3. ���ں� ��ǰ�� �Ǹ���Ȳ(SMProd10)������ ���� PGM                               
  -------                  ������ ��쿡 ����, ��з���ȸ������ڵ带 Update[2021.04.26]
  --------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------                                
   -------        MAIN������(���ص��ȴ�)
   ---------------------------------------------------------------------------------------
  Procedure KK_COLLECTION_MAIN ( p_sum_yymm in VARCHAR2);
  
  ---------------------------------------------------------------------------------------                                
   -------         1. ������� �԰� ������ �����Ѵ�.(MMSUM30  �⸻��� �Ϳ� �������� �̿� )  
   ---------------------------------------------------------------------------------------

  Procedure KK_COLLECTION_PRC1 ( p_sum_yymm in VARCHAR2);
  ---------------------------------------------------------------------------------------                                
   -------         2. ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)������ ���� PGM    
   ---------------------------------------------------------------------------------------

  Procedure KK_COLLECTION_PRC2 ( p_sum_yymm in VARCHAR2);
  
  ---------------------------------------------------------------------------------------                                
   -------         3. ���ں� ��ǰ�� �Ǹ���Ȳ(SMProd10)������ ���� PGM                                
   ---------------------------------------------------------------------------------------

  Procedure KK_COLLECTION_PRC3 ( p_sum_yymm in VARCHAR2);
END KK_COLLECTION_PKG;



---------------------*********************------------------------
create or replace PACKAGE BODY KK_COLLECTION_PKG AS 
   /***************************************************************************
   Procedure Name : KK_COLLECTION_MAIN
   Description    : ���Ұ��� �Ѱ� 
   ***************************************************************************/
   PROCEDURE   KK_COLLECTION_MAIN(  p_sum_yymm in	VARCHAR2) 
   IS
   BEGIN
      DELETE   MMSUM30
      WHERE    SUM_YYMM    =  p_sum_yymm;
      
       -- ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)���� �ش�� ���� 
      DELETE   SMCP10
      WHERE    SUBSTR(YYMMDD,1,6)    =  p_sum_yymm;
      
      DELETE   SMProd10
      WHERE    SUBSTR(YYMMDD,1,6)    =  p_sum_yymm;
      
      dbms_output.put_line(' KK_COLLECTION_PRC1 Before  p_sum_yymm => ' ||p_sum_yymm );
      --   1. ������� �԰� ������ �����Ѵ�.
      KK_COLLECTION_PRC1(  p_sum_yymm );
      -- 2. ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)������ ���� PGM    
      KK_COLLECTION_PRC2(   p_sum_yymm => p_sum_yymm);
      -- 3. ���ں� ��ǰ�� �Ǹ���Ȳ(SMProd10)������ ���� PGM   
      KK_COLLECTION_PRC3(   p_sum_yymm => p_sum_yymm);
   END   KK_COLLECTION_MAIN;    
   /***************************************************************************
   Procedure Name : KK_COLLECTION_PRC1
   Description    : ������� �԰� ������ �����Ѵ�.
   ***************************************************************************/
   PROCEDURE   KK_COLLECTION_PRC1( p_sum_yymm   in	VARCHAR2  )   
   IS
   
   BEGIN
   DBMS_OUTPUT.ENABLE;
   dbms_output.put_line(' KK_COLLECTION_PRC1 p_sum_yymm => ' ||p_sum_yymm );

      ---     1) ��� ���� �԰� ������ �����Ѵ�.
     INSERT INTO MMSUM30
          (    SUM_YYMM       
           ,   ITEM_CODE       
           ,   ITEM_GUBN       
           ,   STCK_QTY
           ,   SawonID
           ,   RegiDate
           )
     ( SELECT   p_sum_yymm
                    ,  ITEM_CODE
                    ,  '0'        -- ����
                    ,  STCK_QTY
                     ,  SawonID
                    ,  SYSDATE
      FROM     MMSUM30   
      WHERE    SUM_YYMM  = TO_CHAR(ADD_MONTHS (TO_DATE(p_sum_yymm,'YYYYMM'),-1),'YYYYMM')
      AND      ITEM_GUBN = '1'    -- �⸻
      );

   END  KK_COLLECTION_PRC1;

   /**************************************************************************************
   Project        : KK ����������Ȳ
   Module         : ���Ұ���
   Procedure Name : KK_COLLECTION_PRC2 
   Description    : ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)������ �����Ѵ�.
                   - �Ϻ� �ǸŽ��� ��Ȳ(SMSALE)�� �о� ���ں� �ŷ�ó ��ǰ�� �Ǹ���Ȳ(SMCP10)������ ����
                   - �Ϻ� �ǸŽ��� ��Ȳ , ��ǰ(Product) ���̺� JOIN
                   - ����� global ������ g_in_sawonid ���� �Է�
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2021.04.26 ���±�            1.0      �����ۼ�
  *************************************************************************************/
   PROCEDURE   KK_COLLECTION_PRC2(  p_sum_yymm     in	VARCHAR2)   
   IS  
   --- �Ϻ� �ǸŽ��� ��Ȳ(SMSALE)�� ���� 
   CURSOR  CSR_SMSALE  IS
                  SELECT     S.YYMMDD     YYMMDD
                            ,S.CustomID    CustomID 
                            ,S.ITEM_CODE  ITEM_CODE   
                            ,S.STCK_QTY   STCK_QTY 
                            , P.Danga         Danga 
                  FROM      SMSALE   S ,  Product P   --- �Ϻ� �ǸŽ��� ��Ȳ , ��ǰ(Product) ���̺�
                  WHERE     S.ITEM_CODE  = P.ITEM_CODE 
                  AND       SUBSTR(S.YYMMDD,1,6)  = p_sum_yymm 
               ;         
   BEGIN
   DBMS_OUTPUT.ENABLE;
      FOR 	rec_smsale IN CSR_SMSALE LOOP
         ------------------------------------------------------------------
         --     Initialize
         ------------------------------------------------------------------
          --  g_goods_trans_qty	:=	0;		---  
    	    INSERT INTO SMCP10   
	          (          YYMMDD       
                   ,   CustomID       
                   ,   ITEM_CODE       
                   ,   STCK_QTY
                   ,   Danga
                   ,   SawonID
                   ,   RegiDate
	           )
	        VALUES(     rec_smsale.YYMMDD 
                    , rec_smsale.CustomID            
                    , rec_smsale.ITEM_CODE   
                    , rec_smsale.STCK_QTY   
                    , rec_smsale.Danga                  
                    , g_in_sawonid                               
                    ,  SYSDATE
	      );
       
      END LOOP;
      EXCEPTION
        WHEN OTHERS THEN
              DBMS_OUTPUT.PUT_LINE(SQLERRM||'���� �߻� ');
   END  KK_COLLECTION_PRC2;
   
   
   /**************************************************************************************************
   Project        : KK ����������Ȳ
   Module         : ���Ұ���
   Procedure Name : KK_COLLECTION_PRC3 
   Description    :  ���ں� ��ǰ�� �Ǹ���Ȳ(SMProd10)������ �����Ѵ�.
                   - �Ϻ� �ǸŽ��� ��Ȳ(SMSALE)�� �о� ���ں�  ��ǰ�� �Ǹ���Ȳ(SMProd10)������ ����
                 
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2021.04.26 ���±�            1.0      �����ۼ�
  ************************************************************************************************/
  Procedure KK_COLLECTION_PRC3 ( p_sum_yymm in VARCHAR2)
  IS
    Cursor smcp_Cursor IS
    Select s.YYMMDD YYMMDD, 
           s.ITEM_CODE ITEM_CODE,
           SUM(s.STCK_QTY) STCK_QTY,
           AVG(p.Danga) Danga
    From SMSALE s, Product p
    Where s.ITEM_CODE = p.ITEM_CODE
    and  Substr(s.yymmdd,1,6) = p_sum_yymm
    Group By s.YYMMDD, s.ITEM_CODE;
  BEGIN
    DBMS_OUTPUT.ENABLE;
   
    For smcp IN smcp_Cursor LOOP
      Insert Into SMProd10
              (          YYMMDD            
                     ,   ITEM_CODE       
                     ,   STCK_QTY
                     ,   Danga
                     ,   SawonID
                     ,   RegiDate
               )
      values (smcp.YYMMDD, 
              smcp.ITEM_CODE,
              smcp.STCK_QTY,
              smcp.Danga,
              g_in_sawonid,
              SYSDATE);
    END LOOP;
    EXCEPTION
      WHEN OTHERS THEN
        dbms_output.put_line(sqlerrm||'�����߻�');
  
  END KK_COLLECTION_PRC3 ;
   
   
END KK_COLLECTION_PKG;



