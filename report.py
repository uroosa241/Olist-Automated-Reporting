import os
import re
import time
import logging
import pandas as pd
import psycopg2

from config import DB_CONFIG

# ==========================================================
# CREATE FOLDERS
# ==========================================================

os.makedirs("output", exist_ok=True)
os.makedirs("logs", exist_ok=True)

logging.basicConfig(
    filename="logs/automation.log",
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s"
)

print("=" * 70)
print("        OLIST REPORT AUTOMATION")
print("=" * 70)

# ==========================================================
# DATABASE CONNECTION
# ==========================================================

try:
    conn = psycopg2.connect(**DB_CONFIG)
    print(" Database Connected")
except Exception as e:
    print(" Database Connection Failed")
    print(e)
    quit()

SQL_FOLDER = "sql"

# ==========================================================
# READ SQL FILE
# ==========================================================

def read_sql(filepath):

    with open(filepath, "r", encoding="utf-8") as f:
        text = f.read()

    # Remove block comments (/* .... */)
    text = re.sub(
        r"/\*.*?\*/",
        "",
        text,
        flags=re.DOTALL
    )

    parts = re.split(r"--\s*Sheet:\s*", text)

    queries = []

    for part in parts:

        part = part.strip()

        if not part:
            continue

        lines = part.splitlines()

        if len(lines) < 2:
            continue

        sheet = lines[0].strip()

        sql = "\n".join(lines[1:])

        # Remove separator lines
        sql = re.sub(
            r"^-{3,}$",
            "",
            sql,
            flags=re.MULTILINE
        ).strip()

        # Remove trailing semicolon
        sql = sql.rstrip(";").strip()

        if sql:
            queries.append((sheet, sql))

    return queries


# ==========================================================
# PROCESS SQL FILES
# ==========================================================

for file in sorted(os.listdir(SQL_FOLDER)):

    if not file.endswith(".sql"):
        continue

    print("\n" + "=" * 70)
    print(f"Processing : {file}")

    start = time.time()

    queries = read_sql(os.path.join(SQL_FOLDER, file))

    print(f"Queries Found : {len(queries)}")

    folder = os.path.join(
        "output",
        file.replace(".sql", "")
    )

    os.makedirs(folder, exist_ok=True)

    success = 0
    failed = 0

    for sheet, query in queries:

        print(f"\n Running : {sheet}")

        try:

            df = pd.read_sql_query(query, conn)

            filename = (
                sheet.replace("/", "-")
                     .replace("\\", "-")
                     .replace(":", "")
                     .replace("*", "")
                     .replace("?", "")
                     .replace('"', "")
                     .replace("<", "")
                     .replace(">", "")
                     .replace("|", "")
                     .strip()
            )

            csv_path = os.path.join(
                folder,
                filename + ".csv"
            )

            df.to_csv(
                csv_path,
                index=False,
                encoding="utf-8-sig"
            )

            print(f"✅ Saved : {filename} ({len(df)} rows)")

            logging.info(
                f"{file} | {sheet} | {len(df)} rows"
            )

            success += 1

        except Exception as e:

            conn.rollback()

            failed += 1

            print(f"❌ FAILED : {sheet}")
            print(e)

            logging.error(
                f"{file} | {sheet} | {e}"
            )

    print("\n" + "-" * 70)
    print(f"Completed : {file}")
    print(f"Successful Queries : {success}")
    print(f"Failed Queries     : {failed}")
    print(f"Time Taken         : {round(time.time()-start,2)} seconds")

conn.close()

print("\n" + "=" * 70)
print(" AUTOMATION FINISHED SUCCESSFULLY")
print("=" * 70)