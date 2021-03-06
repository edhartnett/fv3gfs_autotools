      SUBROUTINE RDCAR1(NVRBLS,DHVRBL,IVALRA,IERR1,
     1                  KNAM,NAME,KNUMB,NUMBS)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C                .      .    .                                       .
C SUBPROGRAM:    RDCAR1      SPECIALIZED CARD READER '1'
C   PRGMMR: LIN              ORG: W/NMC412   DATE: 97-01-29
C
C ABSTRACT: THIS SPECIALIZED CARD READER IS FOR READING CARD '1'
C   FORMAT WHICH MUST HAVE A '1' IN CARD COLUMN 1, AND EACH VRBL
C   ON THE CARD HAS AN '=' SIGN FOLLOWED BY A NUMERIC VALUE FOR
C   THAT VRBL.  AN EXCEPTION IS FOR THE VRBL NAMED KRUN WHICH IS
C   DEFINED AS A CHARACTER STRING WHICH WILL BE MATCHED IN THE
C   KHRUN TABLE AND THE VALUE RETURNED IS THE NUMERIC SUBSCRIPT.
C
C PROGRAM HISTORY LOG:
C   YY-MM-DD  ORIGINAL AUTHOR  UNKNOWN
C   88-07-25  GLORIA DENT  PUT IN DOCUMENTATION BLOCK
C   89-06-14  STEVE LILLY  UPDATE DOCUMENTATION BLOCK
C                  DEFINES THE STARTING LOCATION ON THE
C                  VARIAN FOR 1 AND 2 DOT FAX CHARTS.
C   97-01-29  LIN   CONVERT SUB. TO CFT-77.
C
C USAGE:    CALL RDCAR1(NVRBLS,DHVRBL,IVALRA,IERR1,
C          &            KNAM,NAME,KNUMB,NUMBS)
C
C   INPUT ARGUMENT LIST:
C     NVRBLS   - NUMBER OF VRBLS ON THE CARD
C     DHVRBL   - VRBLS TO LOOK FOR ON THE CARD
C              - MUST BE LEFT-JUSTIFIED IN REAL*8 WORDS
C
C   OUTPUT ARGUMENT LIST:
C     IVALRA   - THE VALUES OF THE RHS OF '=' SIGN AS INTEGERS
C     KNAM     - DEFINES AS SCRATCH ARRAY AS A FUNCTION OF NVRBLS
C     NAME     - DEFINES AS SCRATCH ARRAY AS A FUNCTION OF NVRBLS
C     KNUMB    - DEFINES AS SCRATCH ARRAY AS A FUNCTION OF NVRBLS
C     NUMBS    - DEFINES AS SCRATCH ARRAY AS A FUNCTION OF NVRBLS
C     IERR1    - = 0 IF NORMAL RETURN
C              - = -1  IF IT ENCOUNTERED A '9' IN COLUMN 1
C              - = +1  IF ERROR EXIT
C     COMMON/ISTART/ISTART
C
C REMARKS:
C
C ATTRIBUTES:
C   LANGUAGE: FORTRAN 77
C   MACHINE:  NAS
C
C$$$
C
      COMMON/ISTART/ISTART
C
      CHARACTER*1 LCARD(80)
      CHARACTER*80 JCARD
      EQUIVALENCE (LCARD(1),JCARD)
C
      CHARACTER*1 LIT1
      DATA        LIT1             /'1'/
      CHARACTER*1 LIT9
      DATA        LIT9            /'9'/
C
      CHARACTER*8  DBLWRD
      CHARACTEr*8  DHVRBL(NVRBLS)
C
      INTEGER    ICARD(10)
      INTEGER    INGLES(2)
      INTEGER    IVALRA(NVRBLS)
      INTEGER    JCOT
C
      INTEGER    KKHRUN(23)
      CHARACTER*8  KHRUN(23)
      DATA         KHRUN     /'RADAT   ', 'OPNL    ',
     1                        'OVR48OPN', 'FINAL   ',
     2                        'LFM     ', 'PFAX    ',
     3                        'BKUPPFAX', '1DOTFAX ',
     4                        '2DOTFAX ', 'SIRSPLOT',
     5                        'TROPIC1 ', 'TROPIC2 ',
     6                        'US1PLOT ', 'UABPLOT ',
     7                        'NHEMI20 ', 'WINDPLOT',
     8                        'NHEMI40 ', 'SHEMI40 ',
     9                        'NHEMI60 ', 'NH2501  ',
     A                        'NH2005  ', 'GH2601  ',
     B                        'GH2602  '/
      INTEGER    KNAM(NVRBLS)
      INTEGER    KNUMB(NVRBLS)
      CHARACTER*8  KRUN
      DATA         KRUN              /'KRUN    '/
      CHARACTER*12  NAME(NVRBLS)
      INTEGER       CNAME(2)
      INTEGER    NFRMT(2)
      CHARACTER*12  NUMBS(NVRBLS)
      CHARACTER*4   CNUM
C
      LOGICAL    W3AI24
C
      EQUIVALENCE(ICARD(1),LCARD(1))
C     EQUIVALENCE(DBLWRD,INGLES)
      EQUIVALENCE(KKHRUN(1),KHRUN(1))
C
      DATA     MXRUNS             /23/
      DATA     KFINL              /4/
      DATA     KIQSY             /14/
C
C     ...INITIALIZATION...
C
      IERR1 = 0
C     PRINT *,' RDCAR1, NVRBLS=',NVRBLS
      DO 110 I=1,NVRBLS
      IVALRA(I) = 0
  110 CONTINUE
      MXITM = NVRBLS
      READ(15, 122) LCARD
  122 FORMAT(80A1)
      PRINT  124, LCARD
  124 FORMAT(1H , 80A1)
C
C    ...SETTING THE STARTING LOCATION TO PLOT THE OVERLAPPING
C       STATIONS (IF ANY) WHICH WILL BE MOVE ACCORDING TO
C       SUB B4PLOT, MOVEID, AND PLTDAT FOR 1 AND 2 DOT
C       FAX CHARTS.
C
C       FOR A ONE DOT FAX CHART...
      IF(W3AI24(LCARD(14),KHRUN(8),7)) ISTART = 460
C
C       FOR A TWO DOT FAX CHART...
      IF(W3AI24(LCARD(14),KHRUN(9),7)) ISTART = 460
C
      PRINT 120, ISTART
  120 FORMAT(1X,'ISTART INITIALIZE IN RDCAR1=',1X,I4)
C
      IF(LCARD(1) .EQ. LIT1) GO TO 135
      IF(LCARD(1) .NE. LIT9) GO TO 128
C     ...OTHERWISE, IT WAS A '9' CARD SO THERE IS NO MORE CARDS TO READ
      IERR1 = -1
      GO TO 999
  128 CONTINUE
      PRINT  130
  130 FORMAT(1H , 10X, '***ERROR RETURN FROM RDCAR1,  CARD 1 DOES NOT HA
     1VE A 1 IN COL 1 * * * ')
      IERR1 = 1
      GO TO 999
  135 CONTINUE
      PRINT *, ' GET A valid CARD'
      ITH = 2
      CALL SEPCAR(JCARD,ITH,MXITM,ITEM,KNAM,NAME,KNUMB,NUMBS,IERR)
      JCOT = ITEM
      IF(IERR .EQ. 0) GO TO 200
  137 CONTINUE
      PRINT  138
  138 FORMAT(1H , 10X, '***ERROR RETURN FROM SEPCAR WHEN CALLED BY RDCAR
     11.  FORMAT ERROR ON CARD 1 * * * ')
      IERR1 = 1
      GO TO 999
  200 CONTINUE
      IF(ITEM .LE. 0) GO TO 137
C     ...GIVEN VRBL NAMES ARE IN REAL*8 DHVRBL AND NVRBLS IS COUNT OF
C     ...   ITEMS IN DHVRBL
C     ...THE FOUND VRBL NAMES ARE IN NAME(1,X),(2,X),(3,X)
C     ...   AND ITEM HAS NO. OF ITEMS FOUND
      IF(ITEM .GE. NVRBLS) GO TO 266
      PRINT  262, ITEM,NVRBLS
  262 FORMAT(1H , 10X, '***ERROR RETURN FROM RDCAR1.  ITEM COUNT OF FOUN
     1D VRBLS = ', I5, 2X, 'WHICH IS LESS THAN THE EXPECTED ', I5)
      IERR1 = 1
      GO TO 999
  266 CONTINUE
      DO  477 IA = 1,NVRBLS
C         PRINT *,'IA=',IA
          DBLWRD = DHVRBL(IA)(1:8)
C         PRINT *, 'DBLWRD=',DBLWRD
C         PRINT *, 'DHVRBL(IA)=',DHVRBL(IA)
C??       CALL GBYTES(DBLWRD,INGLES,0,32,0,2)
C         PRINT *,' JCOT=', JCOT
          DO  311 IB = 1,JCOT
            ISAVIB = IB
C           print *,' name(IB)=',name(ib)
C??         CALL GBYTES(NAME(IB),CNAME,0,32,0,2)
C??         PRINT 317,INGLES(1),INGLES(2)
C??         PRINT 317,CNAME(1),CNAME(2)
C??         IF(INGLES(1) .NE. NAME(1,IB)) GO TO 311
C??         IF(INGLES(2) .EQ. NAME(2,IB)) GO TO 320
C??         IF(INGLES(1) .NE. CNAME(1)) GO TO 311
C??         IF(INGLES(2) .EQ. CNAME(2)) GO TO 320
            if(dblwrd .eq.name(ib)(1:8)) then 
              go to 320
            else
              go to 311
            endif
  311     CONTINUE
C         ...IF IT FALLS THRU HERE, NO MATCH FOUND FOR THIS DESIRED VRBL
C         PRINT  315, INGLES(1),INGLES(2)
  315 FORMAT(1H , 10X, '***ERROR RETURN FROM RDCAR1.  REQUESTED VRBL NAM
     1    ED ...', 2A4, ' ... WAS NOT FOUND ON CARD1')
          IERR1 = 1
C          PRINT 317,INGLES(1),INGLES(2)
C          PRINT 317,CNAME(1),CNAME(2)
  317      FORMAT ( 1X,Z16,1X,Z16)
          GO TO 999
  320     CONTINUE
C         ...COMES HERE WHEN MATCHING VRBL NAME WAS FOUND AT  NAME(1,IB)
C???      IF(INGLES(1) .NE. JKRUN(1)) GO TO 350
C???      IF(INGLES(2) .NE. JKRUN(2)) GO TO 350
          IF(DBLWRD    .NE. KRUN) GO TO 350
C         ...OTHERWISE, THIS WAS KRUN =
          DBLWRD(1:8) = NUMBS(ISAVIB)(1:8)
C???      INGLES(1) = NUMBS(1,ISAVIB)
C???      INGLES(2) = NUMBS(2,ISAVIB)
c         CALL GBYTES(DBLWRD,INGLES,0,32,0,2)
C         ...NOW INGLES SHUD CONTAIN '1DOTFAX ', OR SOMETHING LIKE THAT
          DO  333 IC = 1,MXRUNS
              IF(DBLWRD .NE. KHRUN(IC)) GO TO 333
C             ...FOUND MATCHING RUN TYPE IN KHRUN TABLE...
              KRUN1 = IC
              GO TO 340
  333     CONTINUE
C         ...IF IT FALLS THRU HERE, CAN,T FIND RUN TYPE...
c         PRINT  336, INGLES(1),INGLES(2)
  336     FORMAT(1H , 10X, '***ERROR RETURN FROM RDCAR1.  LOOK FOR MISSPELLE
     1D RUN TYPE ON CARD1 IN THE FOLLOWING STRING ... ', 2A4)
          IERR1 = 1
          GO TO 999
  340     CONTINUE
C         ...FOUND KRUN1 ...
          IF(KRUN1 .EQ. KIQSY) KRUN1 = KFINL
C         ...WHICH CHGD KRUN1 TO AGREE W/ RGS USAGE
          IVALRA(IA) = KRUN1
          GO TO 477
  350     CONTINUE
C         ...COMES HERE AFTER MATCHING VRBL NAME WAS FOUND AT NAME(1,IB)
C         ...   AND IT WAS NOT KRUN SO ASSUME IT IS NUMERIC AND DECODE
          NCHAR = KNUMB(IB)
          IF(NCHAR .LT. 1) GO TO 355
          IF(NCHAR .GT. 4) GO TO 355
C         ...CAUTION...ASSUMES ALL NUMERIC VALUES TAKE 4 CARD COLUMNS OR LES
          GO TO 360
  355     CONTINUE
          PRINT  358, DHVRBL(IA)
  358 FORMAT(1H , 10X, '***ERROR RETURN FROM RDCAR1.  NUMERIC VALUE OF V
     1RBL ...', A8, ' ... IS OUT OF RANGE')
          IERR1 = 1
          GO TO 999
  360     CONTINUE
C??/      NUM = NUMBS(1,IB)
C??/      CALL FFA2I(NUM,1,NCHAR,4,IRESLT,IERR)
C         print *,'nchar=',nchar
          CNUM(1:4) = NUMBS(IB)(1:4)
C         PRINT *, ' CNUM=',CNUM
          CALL  ASC2INT(nchar,CNUM,IRESLT,IERR)
C         PRINT *,' IRESLT=',IRESLT
          IVALRA(IA) = IRESLT
          GO TO 477
  477 CONTINUE
C     ...ALL REQUESTED VRBLS HAVE BEEN TRANSLATED...
C
      GO TO 999
  999 CONTINUE
      RETURN
      END
