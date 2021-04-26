/*************************************************************************
*         Master Table   거래처(Customer) 테이블 생성 (Package 예제)
*************************************************************************/
CREATE TABLE Customer
        (CustomID               VARCHAR2(4) 
         CONSTRAINT PK_CustomID PRIMARY KEY,        -- 거래처 번호
         CustomNM               VARCHAR2(20),       -- 거래처 이름
         CustomOwner            VARCHAR2(20),       -- 거래처 대표 이름
         CustomBirthday         VARCHAR2(8),        -- 거래처 대표 생일
         CustomGender           VARCHAR2(1),        -- 거래처 대표 성별
         CustomAddr             VARCHAR2(50),       -- 거래처 주소
         CustomTel              VARCHAR2(20),       -- 거래처 전화   
         MatchSawon             VARCHAR2(4),        -- 거래처 담당사원   
         RegiDate               Date                -- 등록일자 
         );

/*************************************************************************
*             Master Table   거래처(Customer) 테이블 데이터 입력
*************************************************************************/
Insert Into Customer 
Values(1001,'영화상사','김영화','19760108','1','서울 서초동','010-1111-2222','s001',sysdate);
INSERT INTO Customer   VALUES
        (1002, '뮤즈컴', '안예은', '19961208', '2',
        '서울 강남구', '010-3333-5555', 'S002',SYSDATE);

INSERT INTO Customer   VALUES
        (1003, '뮤지칼', '김준수', '19981108', '1',
        '서울 강남구', '010-1234-5555', 'S003',SYSDATE);

INSERT INTO Customer   VALUES
        (1004, '뮤즈컴', '손흥민', '19970708', '1',
        '서울 강남구', '010-3333-5678', 'S001',SYSDATE);

commit;

/*************************************************************************
*         Master Table   제품(Product) 테이블 생성 (Package 예제)
*************************************************************************/
CREATE TABLE Product
        (ITEM_CODE         VARCHAR2(4)
           CONSTRAINT PK_ITEM_CODE PRIMARY KEY,          -- 제품 번호
         ITEMNAME            VARCHAR2(20),               -- 제품 이름
         Danga                   NUMBER(8),              -- 단가 
         Special                 VARCHAR2(100),          -- 제품 특징
         RegiDate               Date                     -- 등록일자 
         );

INSERT INTO Product   VALUES
        ('A001', '마이크', 15000, '고성능 제품', SYSDATE);

INSERT INTO Product   VALUES
        ('A002', '스피커', 6000, '우수 제품', SYSDATE);

INSERT INTO Product   VALUES
        ('B001', '축구복',  25600, '방수용 제품', SYSDATE);

INSERT INTO Product   VALUES
        ('B002', '축구공', 15800, '고탄력  제품', SYSDATE);

/*************************************************************************
*         Master Table   사원(Sawon) 테이블 생성 (Package 예제)
*************************************************************************/
CREATE TABLE Sawon
        (SawonID             VARCHAR2(4)
        CONSTRAINT PK_SawonID  PRIMARY KEY,            -- 사원 code
         SawonNM            VARCHAR2(20),              -- 사원 이름
         SawonBirthday     VARCHAR2(8),                -- 사원 생일
         SawonGender       VARCHAR2(1),                -- 사원 성별
         SawonAddr          VARCHAR2(50),              -- 사원 주소
         SawonTel            VARCHAR2(20),             -- 사원 전화   
         RegiDate               Date                   -- 등록일자 
         );

INSERT INTO Sawon   VALUES
        ('S001', '김영업', '19760108', '1',
        '서울 서초동', '010-1113-2222', SYSDATE);

INSERT INTO Sawon   VALUES
        ('S002', '현빈', '19860108', '1',
        '서울 홍대', '010-1458-3456', SYSDATE);

INSERT INTO Sawon   VALUES
        ('S003', '손예진', '19890708', '2',
        '서울 이대', '010-1133-6677', SYSDATE);
        
-------------------
CREATE TABLE MMSUM30 (
  SUM_YYMM  VARCHAR2(6),
  ITEM_CODE VARCHAR2(4),
  ITEM_GUBN VARCHAR2(1),
  STCK_QTY NUMBER(8),
  SawonID VARCHAR2(4) 
  CONSTRAINT  FK_SawonID1 REFERENCES Sawon, --sawon테이블의 sawonid를(똑같은)참조할거라 생략가능
  RegiDate Date, 
  CONSTRAINT FK_ITEM_CODE3 FOREIGN KEY(ITEM_CODE)  REFERENCES Product(ITEM_CODE));
  
ALTER TABLE MMSUM30
ADD Constraint PK_MMSUM30 PRIMARY KEY (SUM_YYMM,ITEM_CODE,ITEM_GUBN); --복합키 설정




-----------------------------------------------------
-----------*************************-----------------------------------------
-----------------------------
--**********************************************************************

create or replace PACKAGE KK_COLLECTION_PKG AS
  g_in_sawonid VARCHAR2(4) := 'S003'; --손예진 (임의 입력 사원 지정)
  g_prod_cnt NUMBER(9) :=0;-------;
-----------------------------------------------------
--------------------------------------------------------------------------------------                                
  ------- 행동강령 :    <<<  월 수불마감 PGM  >>>                       
  -------               1. 당월기초 입고 수량을 생성한다.(MMSUM30  기말재고를 익월 기초재고로 이월 )
  -------               2. 일자별 거래처 제품별 판매현황(SMCP10)정보를 생성 PGM                          
  -------               3. 일자별 제품별 판매현황(SMProd10)정보를 생성 PGM                               
  -------                  각각의 경우에 대해, 대분류별회계계정코드를 Update[2021.04.26]
  --------------------------------------------------------------------------------------
  ---------------------------------------------------------------------------------------                                
   -------        MAIN만들어보기(안해도된다)
   ---------------------------------------------------------------------------------------
  Procedure KK_COLLECTION_MAIN ( p_sum_yymm in VARCHAR2);
  
  ---------------------------------------------------------------------------------------                                
   -------         1. 당월기초 입고 수량을 생성한다.(MMSUM30  기말재고를 익월 기초재고로 이월 )  
   ---------------------------------------------------------------------------------------

  Procedure KK_COLLECTION_PRC1 ( p_sum_yymm in VARCHAR2);
  ---------------------------------------------------------------------------------------                                
   -------         2. 일자별 거래처 제품별 판매현황(SMCP10)정보를 생성 PGM    
   ---------------------------------------------------------------------------------------

  Procedure KK_COLLECTION_PRC2 ( p_sum_yymm in VARCHAR2);
  
  ---------------------------------------------------------------------------------------                                
   -------         3. 일자별 제품별 판매현황(SMProd10)정보를 생성 PGM                                
   ---------------------------------------------------------------------------------------

  Procedure KK_COLLECTION_PRC3 ( p_sum_yymm in VARCHAR2);
END KK_COLLECTION_PKG;



---------------------*********************------------------------
create or replace PACKAGE BODY KK_COLLECTION_PKG AS 
   /***************************************************************************
   Procedure Name : KK_COLLECTION_MAIN
   Description    : 수불관리 총괄 
   ***************************************************************************/
   PROCEDURE   KK_COLLECTION_MAIN(  p_sum_yymm in	VARCHAR2) 
   IS
   BEGIN
      DELETE   MMSUM30
      WHERE    SUM_YYMM    =  p_sum_yymm;
      
       -- 일자별 거래처 제품별 판매현황(SMCP10)정보 해당월 삭제 
      DELETE   SMCP10
      WHERE    SUBSTR(YYMMDD,1,6)    =  p_sum_yymm;
      
      DELETE   SMProd10
      WHERE    SUBSTR(YYMMDD,1,6)    =  p_sum_yymm;
      
      dbms_output.put_line(' KK_COLLECTION_PRC1 Before  p_sum_yymm => ' ||p_sum_yymm );
      --   1. 당월기초 입고 수량을 생성한다.
      KK_COLLECTION_PRC1(  p_sum_yymm );
      -- 2. 일자별 거래처 제품별 판매현황(SMCP10)정보를 생성 PGM    
      KK_COLLECTION_PRC2(   p_sum_yymm => p_sum_yymm);
      -- 3. 일자별 제품별 판매현황(SMProd10)정보를 생성 PGM   
      KK_COLLECTION_PRC3(   p_sum_yymm => p_sum_yymm);
   END   KK_COLLECTION_MAIN;    
   /***************************************************************************
   Procedure Name : KK_COLLECTION_PRC1
   Description    : 당월기초 입고 수량을 생성한다.
   ***************************************************************************/
   PROCEDURE   KK_COLLECTION_PRC1( p_sum_yymm   in	VARCHAR2  )   
   IS
   
   BEGIN
   DBMS_OUTPUT.ENABLE;
   dbms_output.put_line(' KK_COLLECTION_PRC1 p_sum_yymm => ' ||p_sum_yymm );

      ---     1) 당월 기초 입고 수량을 생성한다.
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
                    ,  '0'        -- 기초
                    ,  STCK_QTY
                     ,  SawonID
                    ,  SYSDATE
      FROM     MMSUM30   
      WHERE    SUM_YYMM  = TO_CHAR(ADD_MONTHS (TO_DATE(p_sum_yymm,'YYYYMM'),-1),'YYYYMM')
      AND      ITEM_GUBN = '1'    -- 기말
      );

   END  KK_COLLECTION_PRC1;

   /**************************************************************************************
   Project        : KK 영업매출현황
   Module         : 수불관리
   Procedure Name : KK_COLLECTION_PRC2 
   Description    : 일자별 거래처 제품별 판매현황(SMCP10)정보를 생성한다.
                   - 일별 판매실적 현황(SMSALE)을 읽어 일자별 거래처 제품별 판매현황(SMCP10)정보를 생성
                   - 일별 판매실적 현황 , 제품(Product) 테이블 JOIN
                   - 사원은 global 변수인 g_in_sawonid 으로 입력
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2021.04.26 강태광            1.0      최초작성
  *************************************************************************************/
   PROCEDURE   KK_COLLECTION_PRC2(  p_sum_yymm     in	VARCHAR2)   
   IS  
   --- 일별 판매실적 현황(SMSALE)을 읽음 
   CURSOR  CSR_SMSALE  IS
                  SELECT     S.YYMMDD     YYMMDD
                            ,S.CustomID    CustomID 
                            ,S.ITEM_CODE  ITEM_CODE   
                            ,S.STCK_QTY   STCK_QTY 
                            , P.Danga         Danga 
                  FROM      SMSALE   S ,  Product P   --- 일별 판매실적 현황 , 제품(Product) 테이블
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
              DBMS_OUTPUT.PUT_LINE(SQLERRM||'에러 발생 ');
   END  KK_COLLECTION_PRC2;
   
   
   /**************************************************************************************************
   Project        : KK 영업매출현황
   Module         : 수불관리
   Procedure Name : KK_COLLECTION_PRC3 
   Description    :  일자별 제품별 판매현황(SMProd10)정보를 생성한다.
                   - 일별 판매실적 현황(SMSALE)을 읽어 일자별  제품별 판매현황(SMProd10)정보를 생성
                 
   Program History
   --------------------------------------------------------------------------
   Date       In Charge        Version   Description
   --------------------------------------------------------------------------
   2021.04.26 강태광            1.0      최초작성
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
        dbms_output.put_line(sqlerrm||'에러발생');
  
  END KK_COLLECTION_PRC3 ;
   
   
END KK_COLLECTION_PKG;



