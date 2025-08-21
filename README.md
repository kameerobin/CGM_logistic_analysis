# Logistic Regression Analysis on CGM Use in Pregnancy

This project demonstrates how SAS can be used to conduct a multivariable logistic regression analysis using real-world structured health data. The analysis explores factors associated with continuous glucose monitor (CGM) use during pregnancy, focusing on maternal and neonatal characteristics.

## 🔍 Objective

The goal was to identify predictors of CGM use during pregnancy using a series of univariate and multivariate analyses, including:

- Descriptive statistics (frequencies, means, medians)
- T-tests and nonparametric Wilcoxon tests
- Chi-square tests for categorical comparisons
- Multivariable logistic regression modeling using backward selection

## 🧪 Skills Demonstrated

- SAS data cleaning and formatting
- Date/time manipulation and age calculation
- Variable recoding and conditional logic
- Statistical analysis (PROC FREQ, PROC TTEST, PROC LOGISTIC, etc.)
- Output formatting for tables and summaries
- Generating median and interquartile range using PROC UNIVARIATE

## 📁 Project Structure

- `logistic_cgm_use_analysis.sas`: Clean, de-identified SAS code used for analysis
- `mock_CGM_data.csv`: A synthetic, anonymized dataset structurally identical to the original used in the analysis
- `README.md`: Project overview, goals, and structure

## ⚠️ Disclaimer

This project uses **no protected health information (PHI)** or real patient identifiers. The dataset included here (`mock_CGM_data.csv`) is entirely **synthetic and de-identified**. It was created strictly for **educational and portfolio purposes** to demonstrate coding proficiency in SAS. All data cleaning, transformation, and analysis steps reflect real-world workflows, but the sample data has been anonymized to fully comply with **HIPAA and institutional ethical standards**.

## 📊 Notes

- The dependent variable for all models is `cgm_prior` (indicator of CGM use)
- Predictors include sociodemographic, clinical, and pregnancy-related factors
- Logistic regression models were iterated with and without variables like `bmi_prepreg` and `pump` per PI request to explore multiple specifications

---

🛠 Built with SAS 9.4  
📍 Domain: Public Health / Maternal & Child Health Analytics  
👤 Author: Kameelah Robinson  
