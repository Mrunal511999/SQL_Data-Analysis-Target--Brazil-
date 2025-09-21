# 📊 E-Commerce SQL Exploratory Data Analysis (Brazil Region)

## 📝 Project Overview
This project performs **Exploratory Data Analysis (EDA)** on a Brazilian e-commerce dataset using **SQL queries**.  
The dataset consists of multiple interconnected tables (customers, orders, payments, products, sellers, etc.), and the objective is to uncover **business insights and customer behavior patterns**.

---

## 📂 Dataset Description
The project uses tables from the `SQL_Target` database:

- **customers** – customer demographics (city, state, ID mapping).  
- **geolocation** – geographical details (lat/long, cities, states).  
- **order_items** – details about purchased products, prices, freight values.  
- **order_reviews** – customer reviews and ratings.  
- **orders_1** – orders placed, timestamps, delivery details.  
- **payments** – payment methods and amounts.  
- **products** – product catalog with attributes.  
- **sellers** – seller details and locations.  

---

## 🔍 Analysis Performed
Key insights generated through SQL queries include:

1. **Data Profiling**
   - Data types of all columns in the `customers` table.
   - Order purchase time range.  

2. **Customer Insights**
   - Cities and states of customers ordering within specific periods.  
   - Customer distribution across Brazilian states.  

3. **Order Trends**
   - Yearly and monthly order volume.  
   - Growth trend of e-commerce orders.  
   - Orders placed by time of day (dawn, morning, afternoon, night).  

4. **Payments & Revenue**
   - % increase in order cost (2017 vs. 2018).  
   - Orders by payment type (monthly breakdown).  
   - Orders by number of installments.  

5. **Delivery & Logistics**
   - Average delivery time across states.  
   - Top 5 states with highest & lowest freight values.  
   - Gap between actual vs. estimated delivery times.  

6. **Price & Freight Analysis**
   - Mean and total values of product prices and freight charges by customer state.  

---

## ⚙️ Tech Stack
- **SQL** (Google BigQuery / any SQL engine)  
- **Dataset**: Brazilian e-commerce data  
- **Environment**: Jupyter Notebook, BigQuery console, or other SQL IDE  

