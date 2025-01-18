import pandas as pd
import random
from faker import Faker

# Initialize Faker
fake = Faker()

# Load existing customer data
customer_data = pd.read_csv('mock_telecom_customer_data.csv')
customer_ids = customer_data['customerID'].tolist()

# Define the number of records to generate (should match the number of customer IDs)
num_records = len(customer_ids)

# Define a list of Indian states and corresponding cities
indian_states_cities = {
    'Punjab': ['Abohar', 'Amritsar', 'Ludhiana', 'Patiala'],
    'Maharashtra': ['Mumbai', 'Pune', 'Nagpur', 'Nashik'],
    'Karnataka': ['Bangalore', 'Mysore', 'Mangalore', 'Hubli'],
    'Tamil Nadu': ['Chennai', 'Coimbatore', 'Madurai', 'Salem'],
    'Uttar Pradesh': ['Lucknow', 'Kanpur', 'Varanasi', 'Agra'],
    # Add more states and cities here...
}

# Flatten the dictionary into a list of (state, city) pairs
state_city_pairs = [(state, city) for state, cities in indian_states_cities.items() for city in cities]

# Generate mock data
data = {
    'customerID': customer_ids,
    'City': [],
    'Lat': [],
    'Long': [],
    'country': ['India'] * num_records,
    'iso2': ['IN'] * num_records,
    'State': []
}

# Populate city and state data
for _ in range(num_records):
    state, city = random.choice(state_city_pairs)
    data['City'].append(city)
    data['State'].append(state)
    data['Lat'].append(round(fake.latitude(), 6))
    data['Long'].append(round(fake.longitude(), 6))

# Create a DataFrame
df = pd.DataFrame(data)

# Save DataFrame to CSV
df.to_csv('Customer_Demographic_data.csv', index=False)

print("Mock data generated and saved to 'mock_indian_location_data.csv'.")
