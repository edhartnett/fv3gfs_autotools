      SUBROUTINE WNDIRT(IDOTS,JDOTS,NDIR,IDDGD,NSSS)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C                .      .    .                                       .
C SUBPROGRAM:    WNDIRT      PLOT WIND DIRECTION NEAR END OF WIND STAF
C   PRGMMR: HENRICHSEN       ORG: W/NMC41    DATE: 88-06-20
C
C ABSTRACT: FIND THE POSITION OF LITTLE WIND DIRECTION DIGIT NEAR END
C   OF WIND STAFF AND PLOTS THE 2ND DIGET OF NDIR AT THAT POSITION.
C
C PROGRAM HISTORY LOG:
C   YY-0M-DD  ORIGINAL AUTHOR(S)'S NAME(S) HERE
C   88-06-20  HENRICHSEN CONVERT TO FORTRAN 77 AND ADD DOCBLOCK.
C
C USAGE:    CALL WNDIRT(IDOTS,JDOTS,NDIR,IDDGD,NSSS)
C   INPUT ARGUMENT LIST:
C     IDOTS    - X COORIDNATE OF POINT IN DOTS.
C     JDOTS    - Y CORRIDNATE OF POINT IN DOTS.
C     NDIR     - TRUE WIND DIR IN TENS OF DEGREES (1 THRU 36, OR 99
C              - IF CALM WIND) IN CHARACTER FORMAT (A2).
C     IDDGD    - GRID ORIENTED WIND DIRECTION IN TENS OD DEGREES IN
C              - INTEGER FORMAT (I2).
C     NSSS     - INTEGER WIND SPEED IN KTS (I3) (=0 IF .LT. 5KTS).
C
C   OUTPUT ARGUMENT LIST:NONE
C
C
C   OUTPUT FILES:
C     FT06F001 - STANDARD PRINT FILE.
C
C REMARKS: CALLS PUTLAB WHICH WRITES TO A COMMON LABEL ARRAY OR
C   TAPE 55 (FT55F0001).
C
C ATTRIBUTES:
C   LANGUAGE: MVS FORTRAN 77.
C   MACHINE:  NAS
C
C$$$
      REAL   CONVTR
      dimension kvv(2)
      DATA   CONVTR          /0.174533/
C     ...CONVERTS TENS OF DEGREES TO RADIANS
      REAL   HYPKA
      DATA   HYPKA           /31.0/
      REAL   HYPKB
      DATA   HYPKB           /37.0/
      REAL   ADXLL
      DATA   ADXLL           /-3.5/
      REAL   ADYLL
      DATA   ADYLL           /-5.0/
      character*8 ctext
      equivalence  (itext, ctext)
CKUMAR
CKUMAR Don't have to change ctext since it is not used
CKUMAR
C     ...WHICH ARE INCREMENTS FORM CENTER OF FIGURE TO LL CORNER
C
      IF(NSSS.LE.0)GO TO 800
      HYPOT=HYPKA
      IF(NSSS.GE.48) HYPOT=HYPKB
      IDDA=45-IDDGD
      IF(IDDA.GE.36) IDDA=IDDA-36
      DDA=IDDA+1
C     ...PLOTTED DIGIT TEN DEGREES AWAY FROM STAFF
      DIRAD=DDA*CONVTR
      DELX=HYPOT*COS(DIRAD)
      DELY=HYPOT*SIN(DIRAD)
      ILLDIG=FLOAT(IDOTS)+DELX+ADXLL+0.5
          IF(ILLDIG.LE.0) GO TO 810
      JLLDIG=FLOAT(JDOTS)+DELY+ADYLL+0.5
          IF(JLLDIG.LE.0) GO TO 810
C     ...THAT FINISHES POSITIONING OF DIGIT
      ITEXT=ISHFT(NDIR,-8)
      print*,'In WNDIRT ITEXT =  ',itext
      IPRIOR=1
 1099  format(' putlab form gulftitl',i9)
      CALL lPUTLAB(ILLDIG,JLLDIG,19.0,ITEXT,0.0,1,IPRIOR,0)
C     ...WHICH IS NORMAL EXIT
      GO TO 800
C
  810 CONTINUE
C     ...COMES TO 810 FOR NEG VALUED I OR J, SO OFF GRID-EXIT
      WRITE(6,FMT='('' NEGATIVE VALUED I/J IN WNDIRT'',/)')
  800 CONTINUE
      RETURN
      END
