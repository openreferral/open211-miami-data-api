# README

This Rails application is an API that:

* connects to the remote 211 Miami SQL Server
* queries the data and saves them as CSVs
* utilizes the HSDS Transformer to transform those CSVs into HSDS-compliant CSVs, generates a datapackage.json file based on the output CSVs, and zip the json file and data files into one datapackage.zip
* exposes that zip via a web API

## Installation 
Clone this repo locally.

Run `bundle install`

### System dependencies
See the `.ruby-version` for the required ruby version.

You should have MS SQL Server installed (directly or via Docker), and a way to access that server (e.g. FreeTDS). See this tutorial if you are on a Mac: https://www.microsoft.com/en-us/sql-server/developer-get-started/ruby/mac/step/2.html

### Configuration

In development, copy `.env.example` and save as `.env`. Add the values for the given env variables in that file and save.

In production, look at the env variables in `.env.example`. Set those variables in production using whatever method you have set up for env var management.

### Database creation and initialization

Run:

`rails db:setup`

This creates and migrates the database. 

To migrate the database upon future changes:

`rails db:migrate`


### Starting the server

Locally:

`bundle exec rails s`

Then the server is running at `localhost:3000` 

## Running the tests

Run 

`rspec spec`

## Using the API

You must create an ApiAccount and get an api key before you can use the API. In Rails console:

```
a = ApiAccount.create
api_key = a.api_key
```

Use the value of api_key in a request header when making a request:

```
"HTTP_AUTHORIZATION"=>"Token token=#{api_key}"
```

## Deployment

You can deploy with Docker. Once you have the docker container up and running and connected to a running SQL Server container (see docker-compose.yml), open an interactive container shell and set up the DB:

```
docker exec -it open211-miami-data-api_etl_api_1 bash
root@455fb3fdc06f:/usr/app# rails db:create db:migrate
```

Note: `open211-miami-data-api_etl_api_1` is the container name. Your container name may be different.

For now, you will need to migrate the database with every release. Once you deploy your new release, open an interactive shell and migrate:

```
docker exec -it open211-miami-data-api_etl_api_1 bash
root@455fb3fdc06f:/usr/app# rails db:migrate
```
