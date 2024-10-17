start-db:
	docker compose up -d

restart-db:
	docker compose down
	docker compose up -d

migrate:
	dotnet run --project src/

get-db-logs:
	docker container logs -f postgres_container
