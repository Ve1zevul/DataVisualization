import psycopg2

DB_CONFIG = {
    "dbname": "DataVisualization",
    "user": "postgres",
    "password": "0000",
    "host": "localhost",
    "port": "5432"
}

def run_query(query):
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()

        cur.execute(query)
        rows = cur.fetchall()

        for row in rows:
            print(row)

        cur.close()
        conn.close()
    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    queries = [
        """SELECT seller_city,
        COUNT(seller_id) AS no_sellers FROM sellers
        GROUP BY seller_city
        ORDER BY no_sellers DESC
        LIMIT 10;""",
        """SELECT payment_type, COUNT(*) AS total
        FROM order_payments
        GROUP BY payment_type
        ORDER BY total DESC;"""
    ]
    for q in queries:
        run_query(q)
        print()
