# NONMEM Tutorial

## I. Dataset의 작성 및 확인

Hands-on/1_Dataset/1_Task의 'raw.xlsx' file을 실행하여 다음의 질문에 답하거나, 내용을 수행하시오.

### I.1. '농도데이터' sheet는 총 몇 명의 대상자로부터 얻어진 데이터인가?

### I.2. '농도데이터' sheet의 각 대상자에서는 몇 번의 관측이 이루어졌는가?

### I.3. 이 데이터를 NONMEM dataset으로 변환하고자 한다. 어떤 data item이 요구되겠는가?

### I.4. I.3에서 결정한 item을 이용하여 실제 NONMEM dataset을 구현하여 'CONC.csv'로 저장하시오.

### I.5. 이 data는 모든 대상자에게 동일한 용량(100 mg)을 투여한 후 확인한 데이터이다. PREDPP를 이용하여 모델링을 하기 에 적절한 형태로 용량 정보를 데이터셋에 반영하여 'PREDPP.csv'로 저장하시오. (단, 투여 시점은 0으로 함)

### I.6. 용량 정보를 $PRED를 이용하여 모델링을 하기 위한 데이터셋으로 구현하여 'PRED.csv'로 저장하시오.

### I.7. GI tract을 나타내는 구획을 1로, 중심구획을 2로 구획 번호를 지정하여 모델링하고자 한다. 경구 투여, 정맥 내 투여 등을 구분하기 위해 어떤 data item이 필요하겠는가?

### I.8. PREDPP.csv를 이용하여, I.7의 item을 반영함으로써 경구 투여를 의미하는 데이터셋을 작성한 후 'PO.csv'로, 정맥 내 투여를 의미하는 데이터셋을 작성한 후 'IV.csv'로 저장하시오.

### I.9. 만일, 이 약물이 30분 간 지속 정맥 주사되었다면, 이를 반영하기 위해 어떤 data item을 사용해야 하는가?

### I.10. 'IV.csv'를 이용하여 I.9의 item을 통해 해당 정보를 반영하고, 'INF.csv'로 저장하시오.

### I.11. 동일한 약물이 용량이 81시간 간격으로 5회 추가로 투여된다(총 투여 횟수는 6회)고 한다면, 이를 반영하기 위해 어떤 data item을 사용해야 하는가?

### I.12. 'INF.csv' 이용하여, I.11의 item을 통해 해당 정보를 반영하고, 'ADD.csv'로 저장하시오.

### I.13. '인구학적 정보' sheet의 정보를 'ADD.csv'에 각 대상자 별로 반영하고 저장하시오. (단, column name은 성별-SEX, 연령-AGE, 체중-WT, 키-HT로 함)

### I.14. 'CONC.csv'를 이용하여 시간-농도 그래프를 그리고 모델링 전략을 제안하여 보시오.

---

## II. 특수 ADVAN을 이용한 control file의 이해

Hands-on/2_Specific_ADVAN/2_Solution에 저장되어 있는 file들을 이용하여 다음의 질문에 답하거나, 내용을 수행하시오.

### II.1. H0_IV_1comp.CTL과 H0_IV_2comp.CTL은 각각 어떤 투여 경로와 구획 모델을 구현하고 있는가?

| 항 목 | H0_IV_1comp.CTL | H0_IV_2comp.CTL |
|------|-----------------|-----------------|
| 투여 경로 | | |
| 구획 모델 | | |

### II.2. II.1의 특성은 control file의 어느 부분에서 확인할 수 있는가? 해당 블록과 각각의 특성을 간단히 요약하시오.

### II.3. H0_IV_1comp.CTL과 H0_PO_1comp.CTL은 각각 어떤 투여 경로와 구획 모델을 구현하고 있는가?

| 항 목 | H0_IV_1comp.CTL | H0_PO_1comp.CTL |
|------|-----------------|-----------------|
| 투여 경로 | | |
| 구획 모델 | | |

### II.4. II.3의 특성은 control file의 어느 부분에서 확인할 수 있는가? 해당 블록과 각각의 특성을 간단히 요약하시오.

### II.5. Hands-on/2_Specific_ADVAN/1_Task에 저장된 데이터셋 file을 각각 실행하여 데이터 특성을 확인한 후, 위 II.1 – II.4에서 확인한 control file 중 각 데이터셋에 적합시키기 가장 적당한 모델 구조를 선택하고 그 이유를 제안해 보시오.

| 항 목 | 적합한 control file | 선택 이유 |
|------|-------------------|----------|
| H0data_IV.csv | | |
| H0data_PO.csv | | |

### II.6. 'H0data_PO.csv' file을 solution folder로 이동한 후, 적합한 control file을 실행하고 결과를 확인하시오.

---

## III. 일반 ADVAN을 이용한 control file의 이해

Hands-on/3_General_ADVAN/1_Task에 저장되어 있는 'ADpractice.CTL'을 이용하여 다음의 질문에 답하거나, 내용을 수행하시오.

### III.1. General linear model을 구현 가능한 일반 ADVAN을 통해 'ADpractice.CTL'을 완성하고자 한다. 어떤 ADVAN을 사용해야 하는가?

### III.2. III.1의 ADVAN에 해당하는 control stream 작성 방법을 숙지하고, $SUBROUTINE 이후에 필요한 블록들을 열거하시오.

### III.3. III.1, III.2에서 계획한 내용을 바탕으로, II에서 사용했던 H0_PO_1comp.CTL과 내용이 동일하도록, control stream을 완성하고 이를 'GLM.ctl'로 저장하시오.

### III.4. 같은 folder에 저장된 'H0data_PO.csv' file을 이용하여 'GLM.ctl'을 실행하고 결과를 확인하시오. 실행 결과는 II.6에서 실행한 결과와 동일한가?

### III.5. 이번에는 general non-linear model을 구현 가능한 일반 ADVAN을 통해 'ADpractice.CTL'을 완성하고자 한다. 어떤 ADVAN을 사용해야 하는가?

### III.6. III.5의 ADVAN에 해당하는 control stream 작성 방법을 숙지하고, $SUBROUTINE 이후에 필요한 블록들을 열거하시오.

### III.7. III.5, III.6에서 계획한 내용을 바탕으로, II에서 사용했던 H0_PO_1comp.CTL과 내용이 동일하도록, control stream을 완성하고 이를 'GNLM.ctl'로 저장하시오.

### III.8. 같은 folder에 저장된 'H0data_PO.csv' file을 이용하여 'GNLM.ctl'을 실행하고 결과를 확인하시오. 실행 결과는 'GLM.ctl'을 실행한 결과와 동일한가?

---

## IV. NONMEM 실행 결과의 해석

Hands-on/4_Output에 저장되어 있는 file을 이용하여 다음의 질문에 답하거나, 내용을 수행하시오.

### IV.1. 'dataset1.csv'를 실행하여 I.8에서 작성한 'PO.csv'과 비교하시오. 두 file은 같은 data에 대한 NONMEM 데이터셋이다. 동일하지 않은 부분이 있다면, 이를 어떻게 지리하는 것이 좋을지 설명하시오.

### IV.2. '1_Task' folder로 이동하여 '1_ADVAN4.CTL'을 실행하시오. 이후 ETA의 추정을 허용해 가면서 최종적으로 어떤 ETA가 선택되는지 확인해 보시오.

### IV.3. IV.2에서 수행한 결과를 반영하여 $TABLE을 적절히 변경하고, control file을 설명하시오.

### IV.4. Output file을 실행하여 결과의 적절성을 평가하시오.

### IV.5. Xpose4를 이용하여 fitting의 적절성을 평가하시오.

---

## V. Covariate searching

Hands-on/5_Covariate model에 저장되어 있는 file을 이용하여 다음의 질문에 답하거나, 내용을 수행하시오.

### A Population Pharmacokinetic Analysis of Fluconazole to Predict Therapeutic Outcome in Burn Patients with Candida Infection

**Antimicrob Agents Chemother 2013;57(2):1006-11**

#### Introduction

**Subjects**

60 major burn patients with burn injury ranging from 11% to 95% of total body surface area

**Fluconazole administration and blood sampling**

Patients were intravenously infused with 100 to 400 mg of fluconazole for 10 to 40 min every 24 h for the treatment of suspected (47 cases) or confirmed (13 cases) fungal infection. They had received 5 to 17 days (mean 6.5 days) of fluconazole treatment prior to the PK sampling. Eight venous blood samples were obtained via central venous catheter at 0 (just before dosing), 3, 5, 9, 24, 27, 48, and 51 h after the initiation of infusion. Fluconazole dosing was maintained every 24 h regardless of sampling.

**Dataset**

The data set consisted of a total of 409 fluconazole concentration observations from 60 subjects. Demographic and clinical variables such as age, sex (ISM, 0 for female, 1 for male), weight (WT), sepsis condition (SEPS), edema status (EDEM), APACHE II score (AP), creatinine CL calculated by the Cockcroft-Gault equation (CLCR), application of continuous renal replacement therapy (CRRT), total body surface areas burned (TBSA), and time after burn injury (DAI) were included as potential covariates. Because the post-burn hypermetabolic response is maximized between day 7 and day 17 after injury (it decreases thereafter) and varies by subjects, we considered TBI to be a potential covariate explaining the physiological difference. DAI was included as a categorical variable (1 for patients whose time from burn injury was within 30 days and 0 for others), and the cutoff point was determined by consideration of the time course of physiological change.

---

### Step 1. Covariate evaluation and screening

1. Check the distribution of variables which may be included as potential covariates (potential covariates). Which of those have appropriate distributional characteristics?

2. Check the co-linearity between potential covariates. Which of those have correlation to each other?

3. Check the co-linearity between parameters.
   - Add ETAs to the patab
   - Change run number to 101
   
   Which parameters are correlated? Explain the relationship between parameters and ETAs.

4. Perform visual covariate screening using Parameter vs Covariate plots.
   - Only check the ETA vs Covariate plots
   
   Which variables have correlative tendency to which parameter?

5. Perform numerical covariate screening using GAM.
   
   Which variables produce significant AIC decrease for ETA1?
   
   Which variables produce significant AIC decrease for ETA2?

6. Suggest your covariate modeling strategy.

---

### Step 2. Considerations for the obvious covariate

7. Include CRRT as the covariate for CL.
   - Use IF statement in the control file.
   - Change the run number to 110
   - Allocated appropriate number to each THETA
   - Do not estimate BSV for CRRT=1 group
   - Only include ETA for CL of CRRT=0 group and V in the patab
   - Remove CRRT from catab
   - Compare the result to that of PK100

**7-1. Suggest alternative way to separate CRRT groups**

8. Allow BSV estimation for CRRT=1 group.
   - Change the run number to 111
   - What happens?

9. Now, repeat the procedure 4~6

---

### Step 3. Covariate modeling

Remove parameters having no potential covatriate in the screening step from patab

Remove variables not selected in the screening step from cotab or catab

10. Include BW as the covariate for V.
    - Compare 3 structures
      - V = BW * THETA(3); adjust initial estimate for THETA(3); run number = 121
      - V = BW/(mean BW) * THETA(3); run number = 122
      - V = BW/(mean BW) * THETA(3) + THETA(4); run number = 123
    
    Is BW meaningful covariate? Why?
    
    Which structure is the best?

11. Any other covariate for V? How can you find that?
    - Use the best model obtained so far
    - Check whether the relationship between ETA~covariate disappeared for included parameter-covariate structure in the model
    - Repeat the procedure 4~6 & 10
    
    (when using linear model, always check for the significance of intercept)

12. Perform backward elimination for full V covariate model.

13. Proceed to covariate modeling for CL
