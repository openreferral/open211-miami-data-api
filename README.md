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

## Deployment