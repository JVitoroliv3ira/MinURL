#!/bin/bash

echo "Log: Definindo variáveis..."
MIGRATION_USER="M_MIN_URL"
APPLICATION_USER="A_MIN_URL"
DATABASE_PASSWORD="@myStrongPassword"
DATABASE_NAME="MIN_URL"
CONTAINER_NAME="min-url-database"
WAIT_TIME=10
MAX_RETRIES=30
SA_USER="sa"

echo "Log: Verificando estado do container..."
CONTAINER_STATUS=$(docker ps -a --filter "name=$CONTAINER_NAME" --format "{{.State}}")

if [[ "$CONTAINER_STATUS" == "running" ]]; then
  echo "Log: Container $CONTAINER_NAME já está em execução. Tentando conectar..."
  if docker exec "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd -S localhost -U "$SA_USER" -P "$DATABASE_PASSWORD" -Q "SELECT 1" &>/dev/null; then
    echo "Log: Conexão bem-sucedida. Encerrando script."
    exit 0
  else
    echo "Log: Banco não está pronto ainda."
  fi
elif [[ "$CONTAINER_STATUS" == "exited" ]]; then
  echo "Log: Container $CONTAINER_NAME está parado. Iniciando container..."
  docker start "$CONTAINER_NAME"
else
  echo "Log: Container $CONTAINER_NAME não existe. Criando container..."
  docker run -e ACCEPT_EULA=Y -e SA_PASSWORD="$DATABASE_PASSWORD" -p 1433:1433 --name "$CONTAINER_NAME" --user root -d mcr.microsoft.com/mssql/server:latest
  CONTAINER_CREATED=true
fi

echo "Log: Aguardando $WAIT_TIME segundos para inicialização..."
sleep "$WAIT_TIME"

attempt=0
echo "Log: Verificando logs até o SQL Server estar pronto..."
while ! docker logs "$CONTAINER_NAME" 2>&1 | grep -q "SQL Server is now ready for client connections"; do
  echo "Log: SQL Server ainda não está pronto. Tentando novamente em $WAIT_TIME segundos..."
  sleep "$WAIT_TIME"
  ((attempt++))
  if [[ $attempt -ge $MAX_RETRIES ]]; then
    echo "Log: Erro - Banco não ficou pronto após várias tentativas. Encerrando."
    exit 1
  fi
done

echo "Log: SQL Server está pronto para conexões."
echo "Log: Instalando sqlcmd e ODBC dentro do container (se necessário)..."
docker exec "$CONTAINER_NAME" bash -c "
  DEBIAN_FRONTEND=noninteractive apt-get remove -y -f libodbc2 libodbcinst2 unixodbc-common || true
  DEBIAN_FRONTEND=noninteractive apt-get update
  DEBIAN_FRONTEND=noninteractive apt-get install -y gnupg2 curl apt-transport-https
  curl -sSL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
  echo 'deb [arch=amd64] https://packages.microsoft.com/debian/10/prod buster main' > /etc/apt/sources.list.d/mssql-release.list
  DEBIAN_FRONTEND=noninteractive apt-get update
  ACCEPT_EULA=Y DEBIAN_FRONTEND=noninteractive apt-get install -y msodbcsql17 mssql-tools unixodbc-dev
"

if [[ "$CONTAINER_CREATED" == "true" ]]; then
  echo "Log: Criando banco de dados..."
  docker exec "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd -S localhost -U "$SA_USER" -P "$DATABASE_PASSWORD" -Q "CREATE DATABASE [$DATABASE_NAME]"
  echo "Log: Criando logins..."
  docker exec "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd -S localhost -U "$SA_USER" -P "$DATABASE_PASSWORD" -Q "
    CREATE LOGIN [$MIGRATION_USER] WITH PASSWORD = '$DATABASE_PASSWORD', CHECK_POLICY = OFF;
    CREATE LOGIN [$APPLICATION_USER] WITH PASSWORD = '$DATABASE_PASSWORD', CHECK_POLICY = OFF;
  "
  echo "Log: Criando usuários e definindo permissões..."
  docker exec "$CONTAINER_NAME" /opt/mssql-tools/bin/sqlcmd -S localhost -U "$SA_USER" -P "$DATABASE_PASSWORD" -d "$DATABASE_NAME" -Q "
    CREATE USER [$MIGRATION_USER] FOR LOGIN [$MIGRATION_USER];
    ALTER ROLE db_owner ADD MEMBER [$MIGRATION_USER];
    CREATE USER [$APPLICATION_USER] FOR LOGIN [$APPLICATION_USER];
    ALTER ROLE db_datareader ADD MEMBER [$APPLICATION_USER];
    ALTER ROLE db_datawriter ADD MEMBER [$APPLICATION_USER];
  "
  echo "Log: Banco e usuários criados."
else
  echo "Log: Container já existia. Não é necessário criar banco nem usuários."
fi

echo "Log: Script finalizado com sucesso."
