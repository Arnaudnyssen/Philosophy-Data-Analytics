# Philosophy DBT Project

This project performs data engineering and analysis on a dataset of philosophical texts using DBT (Data Build Tool) and DuckDB. It includes data ingestion, enrichment (sentiment analysis), transformation, and visualization readiness.


## Project Overview

[**View Live Power BI Demo**]<a href="https://app.powerbi.com/view?r=eyJrIjoiNDljMDQ0ZTEtYjc2YS00ZGI1LWE2NTktNDg0OTQ3NGNiYWVlIiwidCI6IjEyZDZjOWNhLWNmMzItNDRkMi04YmFlLWU2MTFjYmQ2OTQ1OCIsImMiOjl9" target="_blank">➜ Click here to explore the Dashboard</a>

The goal of this project is to analyze philosophical texts, extracting insights such as sentiment polarity, sentence structure, and author statistics across different schools of thought.

**Key Components:**
*   **Data Ingestion**: A Python script (`load_data.py`) loads raw CSV data, enriches it with sentiment scores and word counts using `TextBlob`, and stores it in a DuckDB database.
*   **Data Transformation**: DBT models transform the raw data into structured dimensional models (marts) suitable for analysis.
*   **Database**: DuckDB is used as the analytical database engine.
*   **Visualization**: Power BI files (`*.pbix`) are included for reporting and visualization.

## Data Source

The dataset used in this project is the **History of Philosophy** dataset, available on Kaggle. It contains over 300,000 sentences from 50+ texts across 10 major schools of philosophy.

*   [**Kaggle Dataset: History of Philosophy**](https://www.kaggle.com/datasets/kouroshalizadeh/history-of-philosophy)

## Prerequisites

*   **Python**: 3.8+
*   **DBT**: `dbt-core` and `dbt-duckdb` adapter.
*   **DuckDB**: (Managed via the dbt adapter and Python library).
## Power BI Setup & Visualization

To interpret the data visualized in `philosophy_project.pbix`, you must connect Power BI to the DuckDB database. Since Power BI does not support DuckDB natively out-of-the-box, we use an ODBC driver.

### 1. Install DuckDB ODBC Driver
This project includes the necessary ODBC driver files in the `duckdb_odbc-windows-amd64/` directory.

1.  Navigate to the `duckdb_odbc-windows-amd64/` folder.
2.  Right-click `odbc_install.exe` and run as **Administrator**.
    *   This registers the `duckdb_odbc.dll` on your system.
    *   *Note: If you encounter issues, verify that you are using the correct version for your system architecture (included version is AMD64).*

### 2. Configure the Connection
1.  Open **Power BI Desktop**.
2.  Open the project file: `philosophy_project.pbix`.
3.  If prompted for connection settings:
    *   **Data Source**: ODBC
    *   **Connection String / DSN**: `Driver={DuckDB Driver};Database=path\to\your\philosophy.duckdb`
    *   Replace `path\to\your\philosophy.duckdb` with the absolute path to the database created by `load_data.py` (e.g., `C:\Users\utente\PowerBI\Projet_cv\philosophy.duckdb`).
    *   **Authentication**: No credentials are usually required (Anonymous).

### 3. Visual Assets
The `PowerBI Images/` folder contains thematic assets (e.g., Greek temples, icons) used in the report to enhance the visual storytelling of the philosophical data.

## Setup

1.  **Environment Setup**:
    It is recommended to use a virtual environment.
    ```bash
    python -m venv venv
    source venv/bin/activate  # On Windows: venv\Scripts\activate
    ```

    Install dependencies:
    ```bash
    pip install pandas textblob duckdb dbt-duckdb
    ```

2.  **Data Ingestion**:
    Run the Python script to process the raw data and populate the DuckDB database. This expects `archive/philosophy_data.csv` to exist.
    ```bash
    python load_data.py
    ```
    This will create/update `philosophy.duckdb` with a `raw_philosophy` table.

3.  **DBT Setup**:
    Ensure your `profiles.yml` is configured correctly for the `philosophy_dbt` profile.
    
    Example `profiles.yml` (usually in `~/.dbt/` or the project root):
    ```yaml
    philosophy_dbt:
      target: dev
      outputs:
        dev:
          type: duckdb
          path: 'philosophy.duckdb'
    ```

## Usage

**Running DBT Models:**

To run the entire project:
```bash
dbt run
```

To run specific models (e.g., marts):
```bash
dbt run --select marts
```

**Testing:**
Run data quality tests defined in the project:
```bash
dbt test
```

## Project Structure

*   `load_data.py`: ETL script for raw data ingestion and enrichment.
*   `models/`: DBT SQL models.
    *   `staging/`: Initial cleanup and standardization of raw data.
    *   `intermediate/`: Complex transformations and logic.
    *   `marts/`: Final business-facing tables (Dimensions and Facts).
*   `philosophy.duckdb`: The DuckDB database file (created after running `load_data.py`).
*   `archive/`: Contains the source dataset `philosophy_data.csv`.
*   `*.pbix`: Power BI reports.
