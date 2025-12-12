$PROB 2 compartment advan6
$DATA ..//dataset1.csv IGNORE=@
$INPUT ID TIME AMT DV MDV SEX AGE WT HT

$SUBROUTINE ADVAN6 TOL=4

$MODEL
 COMP(DEPOT, DEFDOSE)
 COMP(CENTRAL, DEFOBS)
 COMP(PERIPH)

$PK

 CL   = THETA(1) * EXP(ETA(1))
 V2   = THETA(2) * EXP(ETA(2))
 V3   = THETA(3) * EXP(ETA(3))
 Q    = THETA(4) * EXP(ETA(4))
 KA   = THETA(5) * EXP(ETA(5))
 
 S2 = V2/1000
 
 KE   = CL/V2
 K12  = Q/V2
 K21  = Q/V3
 
$DES
 
 DADT(1) = -KA*A(1)
 DADT(2) = KA*A(1) - KE*A(2) - K12*A(2) + K21*A(3)
 DADT(3) = K12*A(2) - K21*A(3)
 
$ERROR
 IPRED  = F
 W      = SQRT(THETA(6)**2 + THETA(7)**2 * IPRED**2)
 IRES   = DV - IPRED
 IWRES  = IRES / W
 Y      = IPRED + W * EPS(1)

$THETA
 (0, 10, 30)
 (0, 30, 100)
 (0, 50, 300)
 (0, 5, 20)
 (0, 1.5, 5)
 
 0.001 FIX
 (0, 0.3, 1)

$OMEGA
 0.04
 0.04
 0 FIX
 0 FIX
 0 FIX
 
$SIGMA
 1 FIX

$ESTIMATION NOABORT MAXEVAL=9999 METHOD=1 INTER PRINT=10 SIGDIGITS=3 
$TABLE ID TIME AMT DV MDV IPRED CWRES IWRES  ONEHEADER NOPRINT FILE = sdtab11
$TABLE ID ETA(1) ETA(2)                      ONEHEADER NOPRINT NOAPPEND FILE = patab11
$TABLE ID SEX                                ONEHEADER NOPRINT NOAPPEND FILE = catab11
$TABLE ID AGE WT HT                          ONEHEADER NOPRINT NOAPPEND FILE = cotab11




