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

-- 2.	Data Exploration (Beginner)
-- a.	Write a HiveQL query to find the total number of customers in the dataset.

select count(*) from telecom_churn_data;


-- b.	Write a HiveQL query to find the number of customers who have churned.

select count(*) from telecom_churn_data where churn = 'Yes';


-- c.	Analyze the distribution of customers based on gender and SeniorCitizen status.

select gender, SeniorCitizen, count(*) from telecom_churn_data group by gender, SeniorCitizen;


-- d.	Determine the total charge to the company due to churned customers.

select count(TotalCharges) from telecom_churn_data where churn = 'Yes';


-- 3.	Data Analysis (Intermediate)
-- a.	Write a HiveQL query to find the number of customers who have churned, grouped by their Contract type.

select Contract, count(*) from telecom_churn_data where Churn = 'Yes' group by Contract;


-- b.	Write a HiveQL query to find the average MonthlyCharges for customers who have churned vs those who have not.

select Churn, avg(MonthlyCharges) from telecom_churn_data group by Churn;


-- c.	Determine the maximum, minimum, and average tenure of the customers.

select max(tenure) as Max_tenure, min(tenure) as Min_Tenure, avg(tenure) as Avg_Tenure from telecom_churn_data;

-- d.	Find out which PaymentMethod is most popular among customers.
 
select PaymentMethod, count(*) from telecom_churn_data
group by PaymentMethod
order by count(*) desc limit 1;


-- e.	Analyze the relationship between PaperlessBilling and churn rate.

select PaperlessBilling, count(*) from telecom_churn_data where Churn = 'Yes' group by PaperlessBilling;


-- 4.	Partitioning (Intermediate)
-- a.	Create a partitioned table by Contract and load the data from the original table.

create telecom_churn_data_partitioned (
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
  PaperlessBilling string,
  PaymentMethod string,
  MonthlyCharges double,
  TotalCharges double,
  Churn string
)

partitioned by (Contract STRING);

-- Loading Data from original table

insert overwrite telecom_churn_data_partitioned partition(Contract)
select * from telecom_churn_data;


-- b.	Write a HiveQL query to find the number of customers who have churned in each Contract type using the partitioned table.

select Contract, count(*) from telecom_churn_data_partitioned where Churn = 'Yes' group by Contract;


-- c.	Find the average MonthlyCharges for each type of Contract using the partitioned table.

select Contract, avg(MonthlyCharges) from telecom_churn_data_partitioned group by Contract;


-- d.	Determine the maximum tenure in each Contract type partition.

select Contract, max(tenure) from telecom_churn_data_partitioned group by Contract;


-- 5.	Bucketing (Advanced)
-- a.	Create a bucketed table by tenure into 6 buckets.

create table if not exists telecom_churn_data_bucketed ( 
  customerID string,
  gender string,
  SeniorCitizen int,
  Partner string,
  Dependents string,
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
clustered by (tenure) into 6 buckets;


-- 
