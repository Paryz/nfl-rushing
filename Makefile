all: db install
	mix ecto.setup && cd assets && npm install

install:
	mix deps.get

db:
	docker run --name some-postgres -p 5433:5432 -e POSTGRES_PASSWORD=mysecretpassword -d postgres

