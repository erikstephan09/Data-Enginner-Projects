import psycopg2

conn = psycopg2.connect(host = hsot, dbname = dbname, user = user,  password = password, port = port)

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
