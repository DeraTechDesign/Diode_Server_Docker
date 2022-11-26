# Diode Server
# Copyright 2021 Diode
# Licensed under the Diode License, Version 1.1
FROM elixir:1.11.4

RUN apt-get update && apt-get install -y libboost-dev libboost-system-dev git axel curl

ENV MIX_ENV=prod

RUN git clone https://github.com/diodechain/diode_server.git

WORKDIR /diode_server/

RUN mix local.hex --force && mix local.rebar && mix deps.get && mix deps.compile

RUN mix do compile, git_version

EXPOSE 8545 8443 41046 443 993 1723 10000 51054

# Download start script from github
RUN curl -L https://raw.githubusercontent.com/DeraTechDesign/Diode_Server_Docker/main/start.sh -o start.sh

# Start script
CMD ["sh", "start.sh"]