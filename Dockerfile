FROM bitwalker/alpine-elixir:1.8.1
ARG HEX_TOKEN
COPY . /app
WORKDIR /app
RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix hex.organization auth smartcolumbus_os --key ${HEX_TOKEN} \
    && mix deps.get \
    && mix test \
    && mix format --check-formatted \
    && mix credo
