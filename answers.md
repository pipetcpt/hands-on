# NONMEM Tutorial - 답안

---

## I. Dataset의 작성 및 확인

### I.1. '농도데이터' sheet는 총 몇 명의 대상자로부터 얻어진 데이터인가?

**답: 40명**

Solution 파일을 분석한 결과, ID 1부터 40까지 총 40명의 대상자 데이터가 포함되어 있다.

---

### I.2. '농도데이터' sheet의 각 대상자에서는 몇 번의 관측이 이루어졌는가?

**답: 14회**

각 대상자별로 TIME 0, 0.25, 0.5, 0.75, 1, 1.5, 2, 3, 4, 6, 8, 12, 18, 24시간에서 총 14개의 농도 관측값이 있다.

---

### I.3. 이 데이터를 NONMEM dataset으로 변환하고자 한다. 어떤 data item이 요구되겠는가?

**답:** NONMEM dataset에 필요한 기본 data items:

| Data Item | 설명 |
|-----------|------|
| **ID** | 대상자 식별 번호 |
| **TIME** | 투여 후 경과 시간 |
| **AMT** | 투여량 (투여 record에만 값 입력) |
| **DV** | 종속 변수 (관측된 농도) |
| **MDV** | Missing Dependent Variable (0: 관측값 있음, 1: 없음) |

추가적으로 공변량:
- SEX (성별)
- AGE (연령)
- WT (체중)
- HT (키)

---

### I.4. I.3에서 결정한 item을 이용하여 실제 NONMEM dataset을 구현하여 'CONC.csv'로 저장하시오.

**답:** CONC.csv 구조:

```
ID,TIME,AMT,DV,MDV
1,0,100000,0,0
1,0.25,100000,891.2,0
1,0.5,100000,1179.9,0
...
```

**특징:**
- 모든 row에 AMT가 포함됨 ($PRED 사용 시)
- DV에 관측된 농도값 입력
- TIME=0에서 DV=0 (투여 직전)

---

### I.5. 이 data는 모든 대상자에게 동일한 용량(100 mg)을 투여한 후 확인한 데이터이다. PREDPP를 이용하여 모델링을 하기에 적절한 형태로 용량 정보를 데이터셋에 반영하여 'PREDPP.csv'로 저장하시오.

**답:** PREDPP.csv 구조 (경구투여 기준):

```
ID,TIME,AMT,DV,MDV,SEX,AGE,WT,HT,CMT
1,0,100000,.,1,1,50,73.7,184.5,1
1,0,.,0,0,1,50,73.7,184.5,2
1,0.25,.,891.2,0,1,50,73.7,184.5,2
...
```

**핵심 차이점:**
- 투여 record와 관측 record가 **분리**됨
- 투여 record: AMT에 값, DV는 missing (.), MDV=1
- 관측 record: AMT는 missing (.), DV에 농도값, MDV=0
- CMT (구획 번호) 추가됨

---

### I.6. 용량 정보를 $PRED를 이용하여 모델링을 하기 위한 데이터셋으로 구현하여 'PRED.csv'로 저장하시오.

**답:** PRED.csv 구조:

```
ID,TIME,AMT,DV,MDV,SEX,AGE,WT,HT
1,0,100000,0,0,1,50,73.7,184.5
1,0.25,100000,891.2,0,1,50,73.7,184.5
...
```

**특징:**
- $PRED 사용 시에는 모든 row에 AMT가 포함됨
- 투여 record와 관측 record가 분리되지 않음
- CMT 불필요 (구획 지정은 control file에서 직접 처리)

---

### I.7. GI tract을 나타내는 구획을 1로, 중심구획을 2로 구획 번호를 지정하여 모델링하고자 한다. 경구 투여, 정맥 내 투여 등을 구분하기 위해 어떤 data item이 필요하겠는가?

**답: CMT (Compartment Number)**

| 투여 경로 | CMT 값 | 설명 |
|----------|--------|------|
| 경구 투여 (PO) | 1 | GI tract (Depot compartment)로 투여 |
| 정맥 내 투여 (IV) | 2 | Central compartment로 직접 투여 |

---

### I.8. PREDPP.csv를 이용하여, I.7의 item을 반영함으로써 경구 투여를 의미하는 데이터셋을 작성한 후 'PO.csv'로, 정맥 내 투여를 의미하는 데이터셋을 작성한 후 'IV.csv'로 저장하시오.

**답:**

**PO.csv (경구 투여):**
```
ID,TIME,AMT,DV,MDV,SEX,AGE,WT,HT,CMT
1,0,100000,.,1,1,50,73.7,184.5,1      <- CMT=1 (Depot)
1,0,.,0,0,1,50,73.7,184.5,2           <- CMT=2 (관측)
1,0.25,.,891.2,0,1,50,73.7,184.5,2
...
```

**IV.csv (정맥 내 투여):**
```
ID,TIME,AMT,DV,MDV,SEX,AGE,WT,HT,CMT
1,0,100000,.,1,1,50,73.7,184.5,2      <- CMT=2 (Central)
1,0.25,.,2587.9,0,1,50,73.7,184.5,2
...
```

---

### I.9. 만일, 이 약물이 30분 간 지속 정맥 주사되었다면, 이를 반영하기 위해 어떤 data item을 사용해야 하는가?

**답: RATE**

- RATE = AMT / 주입 시간
- 30분 = 0.5시간 지속 주입 시: RATE = 100000 / 0.5 = **200000 (ug/hr)**

---

### I.10. 'IV.csv'를 이용하여 I.9의 item을 통해 해당 정보를 반영하고, 'INF.csv'로 저장하시오.

**답:** INF.csv 구조:

```
ID,TIME,AMT,RATE,DV,MDV,SEX,AGE,WT,HT,CMT
1,0,100000,200000,.,1,1,50,73.7,184.5,2
1,0.25,.,,2587.9,0,1,50,73.7,184.5,2
...
```

**특징:**
- 투여 record에만 RATE 값 입력
- RATE = 200000 (= 100000 ug / 0.5 hr)
- 관측 record의 RATE는 공란

---

### I.11. 동일한 약물이 8시간 간격으로 5회 추가로 투여된다(총 투여 횟수는 6회)고 한다면, 이를 반영하기 위해 어떤 data item을 사용해야 하는가?

**답: ADDL (Additional Doses) 및 II (Interdose Interval)**

| Data Item | 값 | 설명 |
|-----------|---|------|
| ADDL | 5 | 추가 투여 횟수 (첫 투여 제외) |
| II | 8 | 투여 간격 (시간) |

---

### I.12. 'INF.csv' 이용하여, I.11의 item을 통해 해당 정보를 반영하고, 'ADD.csv'로 저장하시오.

**답:** ADD.csv 구조:

```
ID,TIME,AMT,RATE,ADDL,II,DV,MDV,SEX,AGE,WT,HT,CMT
1,0,100000,200000,5,8,.,1,1,50,73.7,184.5,2
1,0.25,.,,,,2587.9,0,1,50,73.7,184.5,2
...
```

**특징:**
- 투여 record에만 ADDL=5, II=8 입력
- 관측 record의 ADDL, II는 공란

---

### I.13. '인구학적 정보' sheet의 정보를 'ADD.csv'에 각 대상자 별로 반영하고 저장하시오.

**답:** 이미 ADD.csv에 인구학적 정보가 포함되어 있음:

| Column | 설명 | 예시 값 |
|--------|------|---------|
| SEX | 성별 (0: 여성, 1: 남성) | 0, 1 |
| AGE | 연령 (세) | 14~55 |
| WT | 체중 (kg) | 43.5~91.0 |
| HT | 키 (cm) | 146.1~210.4 |

---

### I.14. 'CONC.csv'를 이용하여 시간-농도 그래프를 그리고 모델링 전략을 제안하여 보시오.

**답:**

**시간-농도 프로파일 특징:**
1. **흡수상 (Absorption phase):** TIME 0~2시간에서 농도 상승
2. **Cmax:** 약 1~2시간에서 최고 농도 도달
3. **제거상 (Elimination phase):** 이후 지수적 감소

**모델링 전략 제안:**
1. **1-구획 경구 투여 모델** (1-compartment with first-order absorption)
   - Ka (흡수 속도 상수)
   - CL (청소율)
   - V (분포용적)

2. **잔차 오차 모델:** Combined error model (additive + proportional)

3. **개체간 변이 (BSV):** CL, V에 대해 ETA 추정

---

## II. 특수 ADVAN을 이용한 control file의 이해

### II.1. H0_IV_1comp.CTL과 H0_IV_2comp.CTL은 각각 어떤 투여 경로와 구획 모델을 구현하고 있는가?

| 항 목 | H0_IV_1comp.CTL | H0_IV_2comp.CTL |
|------|-----------------|-----------------|
| **투여 경로** | 정맥 내 투여 (IV bolus) | 정맥 내 투여 (IV bolus) |
| **구획 모델** | 1-구획 모델 | 2-구획 모델 |

---

### II.2. II.1의 특성은 control file의 어느 부분에서 확인할 수 있는가?

**답: $SUBROUTINE 블록**

| Control File | $SUBROUTINE | 설명 |
|--------------|-------------|------|
| H0_IV_1comp.CTL | `ADVAN1 TRANS2` | IV 1-구획, CL/V parameterization |
| H0_IV_2comp.CTL | `ADVAN3 TRANS4` | IV 2-구획, CL/V1/Q/V2 parameterization |

**ADVAN 설명:**
- **ADVAN1:** One compartment linear model (IV)
- **ADVAN3:** Two compartment linear model (IV)

**TRANS 설명:**
- **TRANS2:** CL, V parameterization
- **TRANS4:** CL, V1, Q, V2 parameterization

---

### II.3. H0_IV_1comp.CTL과 H0_PO_1comp.CTL은 각각 어떤 투여 경로와 구획 모델을 구현하고 있는가?

| 항 목 | H0_IV_1comp.CTL | H0_PO_1comp.CTL |
|------|-----------------|-----------------|
| **투여 경로** | 정맥 내 투여 (IV) | 경구 투여 (PO) |
| **구획 모델** | 1-구획 모델 | 1-구획 모델 + 흡수 구획 |

---

### II.4. II.3의 특성은 control file의 어느 부분에서 확인할 수 있는가?

**답: $SUBROUTINE 블록**

| Control File | $SUBROUTINE | 설명 |
|--------------|-------------|------|
| H0_IV_1comp.CTL | `ADVAN1 TRANS2` | IV 1-구획 |
| H0_PO_1comp.CTL | `ADVAN2 TRANS2` | PO 1-구획 (first-order absorption) |

**차이점:**
- **ADVAN1:** 흡수 구획 없음 (IV)
- **ADVAN2:** Depot compartment 포함 (PO) → KA parameter 추가

**PO 모델 추가 요소:**
- `TVKA = THETA(3)` - 흡수 속도 상수
- `S2 = V` - Compartment 2 (Central)의 scaling factor

---

### II.5. 데이터셋에 적합시키기 가장 적당한 모델 구조를 선택하고 그 이유를 제안해 보시오.

| 항 목 | 적합한 control file | 선택 이유 |
|------|-------------------|----------|
| **H0data_IV.csv** | H0_IV_1comp.CTL | TIME=0에서 최고 농도, 흡수상 없이 바로 제거상 시작. IV bolus 특성. 단상의 제거 패턴으로 1-구획 적합. |
| **H0data_PO.csv** | H0_PO_1comp.CTL | TIME=0에서 농도 0, 이후 흡수상 존재 (농도 증가). Tmax 약 1~1.5시간. 경구 투여 특성. |

---

### II.6. 'H0data_PO.csv' file을 solution folder로 이동한 후, 적합한 control file을 실행하고 결과를 확인하시오.

**실행 방법:**
```
nmfe75 HO_PO_1comp.CTL HO_PO_1comp.res
```

**예상 결과 확인 사항:**
- MINIMIZATION SUCCESSFUL 여부
- Parameter estimates (THETA, OMEGA, SIGMA)
- Objective Function Value (OFV)

---

## III. 일반 ADVAN을 이용한 control file의 이해

### III.1. General linear model을 구현 가능한 일반 ADVAN을 통해 'ADpractice.CTL'을 완성하고자 한다. 어떤 ADVAN을 사용해야 하는가?

**답: ADVAN5**

- General linear model
- Rate constants (K) 직접 정의
- 미분 방정식 없이 행렬 지수 함수로 해석적 해 계산

---

### III.2. III.1의 ADVAN에 해당하는 control stream 작성 방법을 숙지하고, $SUBROUTINE 이후에 필요한 블록들을 열거하시오.

**답:** ADVAN5 사용 시 필요한 블록:

1. **$MODEL** - 구획 정의
   ```
   COMP(DEPOT, DEFDOSE)  ; 흡수 구획
   COMP(CENT, DEFOBS)    ; 중심 구획
   ```

2. **$PK** - Rate constants 정의
   ```
   K12 = KA              ; Depot → Central
   K20 = CL/V            ; Central → Out (elimination)
   S2 = V                ; Scaling factor
   ```

---

### III.3. H0_PO_1comp.CTL과 내용이 동일하도록 control stream을 완성하고 'GLM.ctl'로 저장하시오.

**답: GLM.ctl (ADVAN5 버전)**

```
$PROB HO_PO_1comp
$DATA ..//HOdata_PO.csv IGNORE=@
$INPUT ID TIME AMT DV MDV SEX AGE WT HT

$SUBROUTINE ADVAN5

$MODEL
 COMP(DEPOT, DEFDOSE)
 COMP(CENT, DEFOBS)

$PK
;---- FIXED EFFECT DEFINITION ----
 TVCL = THETA(1)
 TVV  = THETA(2)
 TVKA = THETA(3)

;---- RANDOM EFFECT DEFINITION ----

 CL   = TVCL * EXP(ETA(1))
 V    = TVV  * EXP(ETA(2))
 KA   = TVKA * EXP(ETA(3))

 S2 = V
 K12   = KA
 K20   = CL/V

$ERROR
 IPRED  = F
 W      = SQRT(THETA(4)**2 + THETA(5)**2 * IPRED**2)
 IRES   = DV - IPRED
 IWRES  = IRES / W
 Y      = IPRED + W * EPS(1)

$THETA
 (0, 10, 30)
 (0, 30, 100)
 (0, 1.5, 5)

 0.001 FIX
 (0, 0.3, 1)

$OMEGA
 0.04
 0.04
 0 FIX

$SIGMA
 1 FIX

$ESTIMATION NOABORT MAXEVAL=9999 METHOD=1 INTER PRINT=10 SIGDIGITS=3

$TABLE ID TIME AMT DV MDV IPRED CWRES IWRES  ONEHEADER NOPRINT FILE = sdtab2
$TABLE ID ETA(1) ETA(2)                      ONEHEADER NOPRINT NOAPPEND FILE = patab2
$TABLE ID SEX                                ONEHEADER NOPRINT NOAPPEND FILE = catab2
$TABLE ID AGE WT HT                          ONEHEADER NOPRINT NOAPPEND FILE = cotab2
```

---

### III.4. 'GLM.ctl'을 실행하고 결과를 확인하시오. 실행 결과는 II.6에서 실행한 결과와 동일한가?

**답: 동일해야 함**

- ADVAN2와 ADVAN5는 동일한 수학적 모델을 구현
- Parameter estimates가 동일해야 함
- OFV (Objective Function Value)가 동일해야 함
- 약간의 수치적 차이는 발생할 수 있으나 실질적으로 동일

---

### III.5. General non-linear model을 구현 가능한 일반 ADVAN을 통해 'ADpractice.CTL'을 완성하고자 한다. 어떤 ADVAN을 사용해야 하는가?

**답: ADVAN6**

- General non-linear model
- 미분 방정식 (ODE)을 직접 정의
- 수치적 적분을 통해 해 계산 (Runge-Kutta 등)
- TOL (허용 오차) 지정 필요

---

### III.6. III.5의 ADVAN에 해당하는 control stream 작성 방법을 숙지하고, $SUBROUTINE 이후에 필요한 블록들을 열거하시오.

**답:** ADVAN6 사용 시 필요한 블록:

1. **$MODEL** - 구획 정의
   ```
   COMP(DEPOT, DEFDOSE)
   COMP(CENT, DEFOBS)
   ```

2. **$PK** - Parameter 정의
   ```
   S2 = V
   K20 = CL/V
   ```

3. **$DES** - 미분 방정식 정의
   ```
   DADT(1) = -KA*A(1)
   DADT(2) = KA*A(1) - K20*A(2)
   ```

---

### III.7. H0_PO_1comp.CTL과 내용이 동일하도록 control stream을 완성하고 'GNLM.ctl'로 저장하시오.

**답: GNLM.ctl (ADVAN6 버전)**

```
$PROB HO_PO_1comp
$DATA ..//HOdata_PO.csv IGNORE=@
$INPUT ID TIME AMT DV MDV SEX AGE WT HT

$SUBROUTINE ADVAN6 TOL=4

$MODEL
 COMP(DEPOT, DEFDOSE)
 COMP(CENT, DEFOBS)

$PK
;---- FIXED EFFECT DEFINITION ----
 TVCL = THETA(1)
 TVV  = THETA(2)
 TVKA = THETA(3)

;---- RANDOM EFFECT DEFINITION ----

 CL   = TVCL * EXP(ETA(1))
 V    = TVV  * EXP(ETA(2))
 KA   = TVKA * EXP(ETA(3))

 S2 = V
 K20   = CL/V

$DES
 DADT(1) = -KA*A(1)
 DADT(2) = KA*A(1) - K20*A(2)

$ERROR
 IPRED  = F
 W      = SQRT(THETA(4)**2 + THETA(5)**2 * IPRED**2)
 IRES   = DV - IPRED
 IWRES  = IRES / W
 Y      = IPRED + W * EPS(1)

$THETA
 (0, 10, 30)
 (0, 30, 100)
 (0, 1.5, 5)

 0.001 FIX
 (0, 0.3, 1)

$OMEGA
 0.04
 0.04
 0 FIX

$SIGMA
 1 FIX

$ESTIMATION NOABORT MAXEVAL=9999 METHOD=1 INTER PRINT=10 SIGDIGITS=3

$TABLE ID TIME AMT DV MDV IPRED CWRES IWRES  ONEHEADER NOPRINT FILE = sdtab2
$TABLE ID ETA(1) ETA(2)                      ONEHEADER NOPRINT NOAPPEND FILE = patab2
$TABLE ID SEX                                ONEHEADER NOPRINT NOAPPEND FILE = catab2
$TABLE ID AGE WT HT                          ONEHEADER NOPRINT NOAPPEND FILE = cotab2
```

---

### III.8. 'GNLM.ctl'을 실행하고 결과를 확인하시오. 실행 결과는 'GLM.ctl'을 실행한 결과와 동일한가?

**답: 실질적으로 동일해야 함**

- ADVAN5 (GLM)과 ADVAN6 (GNLM)은 동일한 모델을 다른 방법으로 구현
- **차이점:**
  - ADVAN5: 해석적 해 (정확한 계산)
  - ADVAN6: 수치적 적분 (근사 계산)
- TOL 값에 따라 약간의 수치적 차이 발생 가능
- Parameter estimates는 거의 동일해야 함
- ADVAN6이 계산 시간이 더 오래 걸림

---

## IV. NONMEM 실행 결과의 해석

### IV.1. 'dataset1.csv'를 실행하여 I.8에서 작성한 'PO.csv'과 비교하시오.

**차이점:**

| 항목 | PO.csv | dataset1.csv |
|------|--------|--------------|
| AMT 단위 | 100000 (ug) | 100 (mg) |
| DV (TIME=0) | 0 | . (missing) |
| 투여 기록 | TIME=0에 별도 row | TIME=0에 2개 row |

**처리 방법:**
1. **AMT 단위 차이:** $PK에서 S2 조정 필요
   - `S2 = V2/1000` (dataset1에서 사용된 방법)
2. **DV missing 처리:** MDV=1로 지정하여 likelihood 계산에서 제외

---

### IV.2. '1_ADVAN4.CTL'을 실행하시오. ETA의 추정을 허용해 가면서 최종적으로 어떤 ETA가 선택되는지 확인해 보시오.

**진행 과정:**

1. **초기 상태:** 모든 OMEGA가 0 FIX
   ```
   $OMEGA
    0 FIX  ; ETA1 (CL)
    0 FIX  ; ETA2 (V2)
    0 FIX  ; ETA3 (V3)
    0 FIX  ; ETA4 (Q)
    0 FIX  ; ETA5 (KA)
   ```

2. **ETA 추가 순서 (Forward selection):**
   - ETA on CL 추가 → OFV 감소 확인
   - ETA on V2 추가 → OFV 감소 확인
   - ETA on KA 추가 → OFV 감소 확인

3. **최종 선택:** 일반적으로 CL, V2에 대한 BSV가 유의미

**선택 기준:**
- OFV 감소량 > 3.84 (p < 0.05, df=1)
- 추정된 OMEGA 값이 0에 가깝지 않음
- Shrinkage < 30%

---

### IV.3. IV.2에서 수행한 결과를 반영하여 $TABLE을 적절히 변경하고, control file을 설명하시오.

**답:** $TABLE 수정

```
; 유의미한 ETA만 포함하도록 수정
$TABLE ID ETA1 ETA2 ONEHEADER NOPRINT NOAPPEND FILE = patab1
```

**Control file 설명:**

| 블록 | 내용 | 설명 |
|------|------|------|
| $PROB | 2 compartment advan4 | 문제 정의 |
| $DATA | dataset1.csv | 데이터 파일 |
| $INPUT | ID TIME AMT DV MDV SEX AGE WT HT | 입력 변수 |
| $SUBROUTINE | ADVAN4 TRANS4 | 2-구획 경구투여 모델 |
| $PK | CL, V2, V3, Q, KA 정의 | 약동학 파라미터 |
| $ERROR | Combined error model | 잔차 오차 모델 |
| $THETA | 초기값 및 경계 | 고정 효과 |
| $OMEGA | BSV 분산 | 개체간 변이 |
| $SIGMA | 잔차 분산 | 잔차 오차 |
| $TABLE | 출력 테이블 | 진단 플롯용 데이터 |

---

### IV.4. Output file을 실행하여 결과의 적절성을 평가하시오.

**평가 항목:**

1. **수렴 상태:**
   - "MINIMIZATION SUCCESSFUL" 확인
   - 0 MINIMIZATION 메시지 없음

2. **Parameter Estimates:**
   - RSE (Relative Standard Error) < 50%
   - OMEGA의 shrinkage < 30%
   - 경계값에 도달하지 않음

3. **Condition Number:**
   - < 1000 권장

4. **Objective Function Value:**
   - 모델 비교 시 사용

---

### IV.5. Xpose4를 이용하여 fitting의 적절성을 평가하시오.

**R에서 Xpose4 실행:**

```r
library(xpose4)
xpdb <- xpose.data(runno = 1)

# Basic goodness-of-fit plots
dv.vs.pred(xpdb)      # DV vs PRED
dv.vs.ipred(xpdb)     # DV vs IPRED
res.vs.pred(xpdb)     # CWRES vs PRED
res.vs.idv(xpdb)      # CWRES vs TIME

# Individual plots
ind.plots(xpdb)
```

**평가 기준:**
1. **DV vs PRED/IPRED:** Identity line 주변에 분포
2. **CWRES vs PRED/TIME:**
   - 평균 0 주변
   - 무작위 분포 (패턴 없음)
   - -2 ~ +2 범위 내
3. **QQ plot:** 정규 분포 따름

---

## V. Covariate Searching

### Step 1. Covariate evaluation and screening

#### 1. Check the distribution of variables which may be included as potential covariates.

**분포 평가:**

| 변수 | 유형 | 분포 특성 | 적절성 |
|------|------|----------|--------|
| AGE | 연속형 | 정규 또는 균등 분포 | 적절 |
| WT | 연속형 | 정규 분포 | 적절 |
| CLCR | 연속형 | 약간 치우침 가능 | 적절 |
| SEX | 범주형 | 이진 (0/1) | 적절 |
| CRRT | 범주형 | 이진 (0/1) | 적절 |
| TBSA | 연속형 | 우측 치우침 가능 | 주의 |
| DAI | 범주형 | 이진 (0/1) | 적절 |

**적절하지 않은 분포:**
- 극단적으로 치우친 분포
- 변이가 거의 없는 변수

---

#### 2. Check the co-linearity between potential covariates.

**상관관계 확인 필요 쌍:**

| 변수 1 | 변수 2 | 예상 상관관계 |
|--------|--------|--------------|
| WT | CLCR | 양의 상관 (Cockcroft-Gault 공식) |
| AGE | CLCR | 음의 상관 (노화에 따른 신기능 감소) |
| TBSA | DAI | 가능한 상관 |

**공선성 기준:**
- |r| > 0.7 → 함께 모델에 포함하지 않음
- VIF > 5 → 주의 필요

---

#### 3. Check the co-linearity between parameters.

**ETA 간 상관관계:**

실행 후 patab에서 ETA 확인:
- ETA1 (CL) vs ETA2 (V): 일반적으로 상관관계 있음
- 높은 상관관계 시 full OMEGA block 고려

---

#### 4. Perform visual covariate screening using Parameter vs Covariate plots.

**확인 방법 (Xpose4):**

```r
ranpar.vs.cov(xpdb)  # ETA vs Covariates
```

**확인할 관계:**
- ETA1 (CL) vs CLCR, CRRT, WT, AGE
- ETA2 (V) vs WT, AGE

**경향 해석:**
- 선형 경향: 해당 공변량 포함 고려
- 비선형 경향: 변환 (log, power) 고려

---

#### 5. Perform numerical covariate screening using GAM.

**R code:**

```r
library(xpose4)
xpdb <- xpose.data(runno = 100)
gam(xpdb)
```

**AIC 기반 선택:**
- AIC 감소가 유의미한 공변량 선택
- Stepwise selection

---

#### 6. Suggest your covariate modeling strategy.

**전략:**

1. **Base model 확립:**
   - CL, V에 대한 BSV 포함
   - 적절한 잔차 오차 모델

2. **명백한 공변량 우선:**
   - CRRT on CL (생리학적 타당성)
   - WT on V (용적 관련)

3. **Forward inclusion:**
   - p < 0.05 (ΔOFV > 3.84)

4. **Backward elimination:**
   - p < 0.01 (ΔOFV > 6.63)

---

### Step 2. Considerations for the obvious covariate

#### 7. Include CRRT as the covariate for CL.

**Control file 수정 (PK110):**

```
$PK
IF(CRRT.EQ.0) THEN
  CL = THETA(1) * EXP(ETA(1))
ELSE
  CL = THETA(2)  ; CRRT=1 group, no ETA
ENDIF

V = THETA(3) * EXP(ETA(2))
```

**특징:**
- CRRT=1 그룹에 별도 THETA 할당
- CRRT=1 그룹에 BSV 추정 안 함

---

#### 7-1. Suggest alternative way to separate CRRT groups.

**대안:**

```
CLCRRT = 1
IF(CRRT.EQ.1) CLCRRT = THETA(4)  ; Fractional change

CL = THETA(1) * CLCRRT * EXP(ETA(1))
```

---

#### 8. Allow BSV estimation for CRRT=1 group.

**PK111:**

```
IF(CRRT.EQ.0) THEN
  CL = THETA(1) * EXP(ETA(1))
ELSE
  CL = THETA(2) * EXP(ETA(2))  ; Separate ETA for CRRT=1
ENDIF
```

**문제점:**
- CRRT=1 그룹 표본 크기가 작으면 추정 불안정
- Boundary 문제 발생 가능 (OMEGA → 0)

---

#### 9. Repeat the procedure 4~6.

**Step 2 이후 재평가:**
- ETA vs Covariate plots 재생성
- 남은 공변량 효과 확인
- 추가 공변량 선택

---

### Step 3. Covariate modeling

#### 10. Include BW as the covariate for V.

**세 가지 구조 비교:**

**PK121: V = BW * THETA(3)**
```
V = WT * THETA(3)  ; THETA(3) = V/kg
$THETA (0, 0.5, 2)  ; L/kg
```

**PK122: V = BW/(mean BW) * THETA(3)**
```
V = (WT/62) * THETA(3)  ; 62 = mean WT
$THETA (0, 30, 100)  ; L
```

**PK123: V = BW/(mean BW) * THETA(3) + THETA(4)**
```
V = (WT/62) * THETA(3) + THETA(4)
$THETA (0, 30, 100)
$THETA (-50, 0, 50)  ; intercept
```

**평가 기준:**
1. OFV 비교
2. Parameter precision (RSE)
3. 해석 가능성

**최적 구조:** 일반적으로 **PK122** (centered, 해석 용이)

---

#### 11. Any other covariate for V?

**확인 방법:**
1. PK122 실행 후 ETA(V) vs 다른 공변량 플롯 확인
2. WT 효과 적용 후 남은 경향 확인
3. AGE, TBSA 등 추가 공변량 평가

---

#### 12. Perform backward elimination for full V covariate model.

**방법:**
1. Full model에서 각 공변량 하나씩 제거
2. OFV 증가량 확인
3. ΔOFV < 6.63 (p > 0.01) → 공변량 제거
4. 모든 공변량이 유의할 때까지 반복

---

#### 13. Proceed to covariate modeling for CL.

**CL 공변량 후보:**
- CLCR (신장 청소율)
- AGE
- WT
- CRRT (이미 포함)

**모델 구조 예:**
```
CL = THETA(1) * (CLCR/100)**THETA(5) * EXP(ETA(1))
```

**평가:**
- Forward inclusion → Backward elimination
- 최종 모델 선택

---

## 요약

| 섹션 | 주요 내용 |
|------|----------|
| I | NONMEM 데이터셋 구성 (ID, TIME, AMT, DV, MDV, CMT, RATE, ADDL, II) |
| II | Specific ADVAN (ADVAN1-4) - 특정 PK 모델에 최적화 |
| III | General ADVAN (ADVAN5-6) - 유연한 모델 구현 |
| IV | 결과 해석 및 진단 플롯 평가 |
| V | 공변량 탐색 및 모델링 전략 |
