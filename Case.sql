-- 1. Data Loading
-- a.	Download the dataset and load it into a Hive table.

create table telecom_churn_data (
  customerID string,
  gender string,
  SeniorCitizen int,
  Partner string,
  Dependents string,
  tenure int,
  PhoneService string,
  MultipleLines string,
  InternetService string,
  OnlineSecurity string,
  OnlineBackup string,
  DeviceProtection string,
  TechSupport string,
  StreamingTV string,
  StreamingMovies string,
  Contract string,
  PaperlessBilling string,
  PaymentMethod string,
  MonthlyCharges double,
  TotalCharges double,
  Churn string
)
row format delimited
fields terminated by ','
stored as textfile;


-- b.	Write a query to display the top 10 rows of the table.

select * from telecom_churn_data limit 10;



