# **NYC FHV Trip Analysis Project**

This project enables the analysis of NYC ride-sharing trip data using **dbt** for data transformations and **Power BI** for visualization.

---

## **1. Project Overview**

This project is structured using the **Medallion Architecture** to transform and analyze ride data:
1. **Bronze Layer**: Raw data ingestion and minimal transformations.
2. **Silver Layer**: Data cleaning, validation, and enrichment.
3. **Gold Layer**: Aggregated metrics and star schema for analytics.

The final insights are visualized in **Power BI**, connected to the **PostgreSQL database**.

---

## **2. How to Use the Project**


### **Step 1: Load Raw Data**

#### **Upload Parquet Files**
1. Save your Parquet files (e.g., trip data) as tables under the **`raw` schema**.

#### **Seed Reference Data**
1. Populate static reference data (e.g., taxi zone lookup) using dbt's seed functionality:
   ```bash
   dbt seed
This command will upload the reference CSV files in the seeds/ folder to the schema.

### **3: Transform Data**
Run the dbt pipeline to transform data across all layers:

dbt build 
This command will:

Transform raw trip and zone data in the Bronze Layer.
Clean and validate data in the Silver Layer.
Create aggregated metrics and dimensions in the Gold Layer within the staging database.

For production, use dbt build --target prod ( define the connection to your database in the profiles.yml)
### **Step 4: Connect Power BI to the Database**
Open the provided (.pbix) file in Power BI Desktop.

Connect to your PostgreSQL database:
Use Direct Query mode for real-time updates.

Select tables from gold layer
### **Step 5: Check the Dashboard**
The dashboard contains 2 pages, the second page contains slicers you can use to filter out the data.