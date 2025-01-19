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


-- b.	Load the data from the original table into the bucketed table.

insert overwrite table telecom_churn_data_bucketed select * from telecom_churn_data;


-- c.	Write a HiveQL query to find the average MonthlyCharges for customers in each bucket.

select avg(MonthlyCharges) from telecom_churn_data_bucketed where tenure between lower_range and upper_range;


-- d.	Find the highest TotalCharges in each tenure bucket.

select 'Bucket 1' as Bucket, max(TotalCharges) as MaxCharge from telecom_churn_data_bucketed where tenure between 1 and 10 union all
select 'Bucket 2' as Bucket, max(TotalCharges) as MaxCharge from telecom_churn_data_bucketed where tenure between 11 and 20 union all
select 'Bucket 3' as Bucket, max(TotalCharges) as MaxCharge from telecom_churn_data_bucketed where tenure between 21 and 30 union all
select 'Bucket 4' as Bucket, max(TotalCharges) as MaxCharge from telecom_churn_data_bucketed where tenure between 31 and 40 union all
select 'Bucket 5' as Bucket, max(TotalCharges) as MaxCharge from telecom_churn_data_bucketed where tenure between 41 and 50 union all
select 'Bucket 6' as Bucket, max(TotalCharges) as MaxCharge from telecom_churn_data_bucketed where tenure between 51 and 60;


-- 6.	Performance Optimization with Joins (Advanced)
-- Select another dataset, Customer_Demographic_data.csv, that contains the details of the demographic data of each customer.

a.	Load the demographics dataset into another Hive table.

create table if not exists custome_demographic_data (
  CustomerID int,
  City string,
  Latitude doube,
  Longitude double,
  Country String,
  ISO2 string,
  State string
);

load data inpath 'path/to/Customer_Demographic_data.csv' into table custome_demographic_data;


--  b.	Write HiveQL queries to join the customer churn table and the demographics table on customerID using different types of joins - common join, map join, bucket map join, and sorted merge bucket join.

-- 1. Common Join (Regular Join)
select cc.*, d.* from telecom_churn_data t
join custome_demographic_data d on t.customerID = d.customerID;


-- 2. Map Join
set hive.auto.convert.join=true;

select cc.*, d.* from telecom_churn_data cc
join custome_demographic_data d
on cc.customerID = d.customerID;


-- 3. Bucket Map Join
set hive.optimize.bucketmapjoin=true;

select cc.*, d.* from telecom_churn_data cc
join custome_demographic_data d
on cc.customerID = d.customerID;


-- 4. Sorted Merge Bucket Join
set hive.optimize.bucketmapjoin=true;
set hive.optimize.bucketmapjoin.sortedmerge=true;

select cc.*, d.* from telecom_churn_data cc
join custome_demographic_data d
on cc.customerID = d.customerID;


/*
To observe and document the performance of each join type in Hive, you can follow these steps:

### Steps to Observe Performance:

1. **Enable Logging and Metrics**:
   - Enable detailed logging and capture the performance metrics.
   ```sql
   SET hive.exec.dynamic.partition.mode=nonstrict;
   SET hive.execution.engine=tez;
   SET hive.cbo.enable=true;
   SET hive.compute.query.using.stats=true;
   SET hive.stats.fetch.column.stats=true;
   SET hive.stats.fetch.partition.stats=true;
   ```

2. **Run the Queries**:
   - Execute each join query individually.
   - Use `EXPLAIN` before running the query to get the query execution plan.
   ```sql
   explain select cc.*, d.* from telecom_churn_data t join custome_demographic_data d on t.customerID = d.customerID;
   ```
   ```sql
   explain select cc.*, d.* from telecom_churn_data cc join custome_demographic_data d on cc.customerID = d.customerID;
   ```
   ```sql
   explain select cc.*, d.* from telecom_churn_data cc join custome_demographic_data d on cc.customerID = d.customerID;
   ```
   ```sql
   explain select cc.*, d.* from telecom_churn_data cc join custome_demographic_data d on cc.customerID = d.customerID;
   ```

3. **Capture Execution Time**:
   - Note the total execution time for each query using `TIME` command.
   ```sql
   time select cc.*, d.* from telecom_churn_data t join custome_demographic_data d on t.customerID = d.customerID;
   ```
   ```sql
   time select cc.*, d.* from telecom_churn_data cc join custome_demographic_data d on cc.customerID = d.customerID;
   ```
   ```sql
   time select cc.*, d.* from telecom_churn_data cc join custome_demographic_data d on cc.customerID = d.customerID;
   ```
   ```sql
   time select cc.*, d.* from telecom_churn_data cc join custome_demographic_data d on cc.customerID = d.customerID;
   ```

4. **Monitor Resource Usage**:
   - Check the resource usage (CPU, memory, disk I/O) for each query execution through the Hadoop/YARN Resource Manager or Hive logs.

5. **Gather Query Metrics**:
   - After each query execution, capture metrics like number of map and reduce tasks, data shuffled, and any other relevant statistics.

6. **Document Results**:
   - Create a table or document to log the results for each join type.

### Sample Documentation Table:

| Join Type             | Execution Time | Map Tasks | Reduce Tasks | Data Shuffled | CPU Usage | Memory Usage | Observations                     |
|-----------------------|----------------|-----------|--------------|---------------|-----------|--------------|----------------------------------|
| Common Join           | 5 mins         | 20        | 10           | 500 MB        | 70%       | 4 GB         | Suitable for large datasets.     |
| Map Join              | 2 mins         | 10        | 0            | 100 MB        | 50%       | 2 GB         | Fast for small right-side table. |
| Bucket Map Join       | 3 mins         | 15        | 5            | 300 MB        | 60%       | 3 GB         | Effective for bucketed tables.   |
| Sorted Merge Bucket Join | 2.5 mins    | 10        | 3            | 200 MB        | 55%       | 2.5 GB       | Best for sorted, bucketed tables.|

### Conclusion:
- **Common Join**: Best for general cases but may have high resource usage for large datasets.
- **Map Join**: Optimized for scenarios where one table is small enough to fit into memory.
- **Bucket Map Join**: Useful when both tables are bucketed, reducing the data shuffled.
- **Sorted Merge Bucket Join**: Most efficient when tables are both bucketed and sorted, minimizing the data shuffled.

You can adjust the table to include additional metrics or details based on what is most relevant to your analysis.
*/


-- 7.	Advanced Analysis (Expert)
-- a.	Find the distribution of PaymentMethod among churned customers.

select PaymentMethod, count(*) from telecom_churn_data where Churn = 'Yes' group by PaymentMethod;


-- b.	Calculate the churn rate (percentage of customers who left) for each InternetService category.

select InternetService, count(*)*100.0/(select count(*) from telecom_churn_data where Churn = 'Yes') as churn_rate
from telecom_churn_data where Churn = 'Yes' group by InternetService;


-- c.	Find the number of customers who have no dependents and have churned, grouped by Contract type.

select Contract, count(*) from telecom_churn_data where Churn = 'Yes' and Dependents = 'No' group by Contract;


-- d.	Find the top 5 tenure lengths that have the highest churn rates.

select tenure, count(*)*100.0/(select count(*) from telecom_churn_data where Churn = 'Yes') as churn_rate from telecom_churn_data
where Churn = 'Yes' group by tenure order by churn_rate desc limit 5;


-- 
