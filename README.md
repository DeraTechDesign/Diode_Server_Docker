# Diode_Server_Docker
 
This is a docker image for the Diode Server.

## Usage
### With Docker Compose
You can use the docker-compose.yml file to start the server. You can edit the file to change worker mode (WORKER_MODE), blockchain snapshot url(BLOCKCHAIN_SQ3_URL) and your wallet private key(PRIVATE).

Run the following command to start the server:
```
docker-compose up -d
```
### With Akash SDL
You can use the deployToAkash.yml file to start the server on Akash. You can edit the file to change worker mode (WORKER_MODE), blockchain snapshot url(BLOCKCHAIN_SQ3_URL) and your wallet private key(PRIVATE).

Change the endpoint name to a unique name and deploy the server to Akash.