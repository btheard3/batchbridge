import sqlite3
from pathlib import Path

import pandas as pd


def main():
    project_root = Path(__file__).resolve().parents[1]
    csv_path = project_root / "data" / "processed" / "ecommerce_cleaned.csv"
    db_path = project_root / "db" / "batchbridge.db"

    df = pd.read_csv(csv_path)

    # Fix date format
    df["InvoiceDate"] = pd.to_datetime(df["InvoiceDate"], errors="coerce")
    df["InvoiceDate"] = df["InvoiceDate"].dt.strftime("%Y-%m-%d %H:%M:%S")

    conn = sqlite3.connect(db_path)

    df.to_sql("ecommerce_cleaned", conn, if_exists="replace", index=False)

    print(f"Loaded {len(df)} rows into {db_path}")

    conn.close()


if __name__ == "__main__":
    main()