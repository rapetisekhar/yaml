echo "Superset Connection"
PGPASSWORD=superpass psql -h localhost -U supersetuser -d supersetdb -c "SELECT user,'Connection Successful' Connection ;";


