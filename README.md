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

You can deploy with Docker to Azure Kubernetes Service. 

Create the image locally:

```
docker-compose up --build -d
```

Tag the latest image (replace v2 if you need to):

```
docker tag open211-miami-data-api_etl-api openreferralregistry.azurecr.io/etl-api:v2
```

Push to the container registry (change v2 if needed):

```
docker push openreferralregistry.azurecr.io/etl-api:v2
```

You may need to log in for that to work (`az acr login --name openreferralregistry`)

Once the image is pushed, deploy the updated application (change v2 if needed):

```
kubectl set image deployment etl-api etl-api=openreferralregistry.azurecr.io/etl-api:v2
```

This may take some time.

To get the external IP to test out the deployed app:

```
kubectl get service etl-api
```

Once you have the docker container up and running and connected to a running SQL Server container (see docker-compose.yml), open an interactive container shell and set up the DB:

```
kubectl get pods
#=> etl-api-8697b4858c-xsswk (or similar)
kubectl exec -it etl-api-8697b4858c-xsswk bash
root@455fb3fdc06f:/usr/app# rails db:setup
```

Note: `open211-miami-data-api_etl_api_1` is the container name. Your container name may be different.

For now, you will need to migrate the database with every release. Once you deploy your new release, open an interactive shell and migrate:

```
kubectl get pods
#=> etl-api-8697b4858c-xsswk (or similar)
kubectl exec -it etl-api-8697b4858c-xsswk bash
root@455fb3fdc06f:/usr/app# rails db:migrate
```

To get the API Account ID to use to authenticate with the API:

```
kubectl get pods
#=> etl-api-8697b4858c-xsswk (or similar)
kubectl exec -it etl-api-8697b4858c-xsswk rails c
irb$: ApiAccount.last.api_key
```

To update the azure config with things like env vars:

```
kubectl apply -f azure-kube-config.yaml 
```