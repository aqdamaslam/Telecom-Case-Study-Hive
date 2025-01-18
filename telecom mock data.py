import pandas as pd
import random
from faker import Faker

# Initialize Faker
fake = Faker()

# Define the number of records to generate
num_records = 10000

# Define possible values for categorical fields
genders = ['Male', 'Female']
yes_no = ['Yes', 'No']
internet_services = ['DSL', 'Fiber optic', 'No']
contract_types = ['Month-to-month', 'One year', 'Two year']
payment_methods = ['Electronic check', 'Mailed check', 'Bank transfer (automatic)', 'Credit card (automatic)']
churn_options = ['Yes', 'No']

# Generate mock data
data = {
    'customerID': [fake.uuid4() for _ in range(num_records)],
    'gender': [random.choice(genders) for _ in range(num_records)],
    'SeniorCitizen': [random.randint(0, 1) for _ in range(num_records)],
    'Partner': [random.choice(yes_no) for _ in range(num_records)],
    'Dependents': [random.choice(yes_no) for _ in range(num_records)],
    'tenure': [random.randint(0, 72) for _ in range(num_records)],
    'PhoneService': [random.choice(yes_no) for _ in range(num_records)],
    'MultipleLines': [random.choice(yes_no + ['No phone service']) for _ in range(num_records)],
    'InternetService': [random.choice(internet_services) for _ in range(num_records)],
    'OnlineSecurity': [random.choice(yes_no + ['No internet service']) for _ in range(num_records)],
    'OnlineBackup': [random.choice(yes_no + ['No internet service']) for _ in range(num_records)],
    'DeviceProtection': [random.choice(yes_no + ['No internet service']) for _ in range(num_records)],
    'TechSupport': [random.choice(yes_no + ['No internet service']) for _ in range(num_records)],
    'StreamingTV': [random.choice(yes_no + ['No internet service']) for _ in range(num_records)],
    'StreamingMovies': [random.choice(yes_no + ['No internet service']) for _ in range(num_records)],
    'Contract': [random.choice(contract_types) for _ in range(num_records)],
    'PaperlessBilling': [random.choice(yes_no) for _ in range(num_records)],
    'PaymentMethod': [random.choice(payment_methods) for _ in range(num_records)],
    'MonthlyCharges': [round(random.uniform(20.0, 120.0), 2) for _ in range(num_records)],
    'TotalCharges': [round(random.uniform(20.0, 10000.0), 2) for _ in range(num_records)],
    'Churn': [random.choice(churn_options) for _ in range(num_records)]
}

# Create a DataFrame
df = pd.DataFrame(data)

# Save DataFrame to CSV
df.to_csv('mock_customer_data.csv', index=False)

print("Mock data generated and saved to 'mock_telecom_customer_data.csv'.")
