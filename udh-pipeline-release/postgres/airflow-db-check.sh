echo "Airflow Connection"
PGPASSWORD=airflowpass psql -h localhost -U airflowuser -d airflowdb -c "SELECT user,'Connection Successful' Connection ;";



