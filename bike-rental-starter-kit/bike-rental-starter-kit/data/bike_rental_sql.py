import psycopg2

conn = psycopg2.connect(host = "localhost", dbname = "biker_rental", user = "postgres",  password = "Muskalink123", port = 5432)

cur = conn.cursor()
cur.execute("""
    CREATE TABLE biker(
            id INT PRIMARY KEY,
            person VARCHAR(30)
            );
""")

conn.commit()
cur.close()
conn.close()