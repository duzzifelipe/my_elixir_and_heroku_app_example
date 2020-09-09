FROM elixir:1.9.4-alpine as build

ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

# IMPORTANT: Replace with your own timezone
RUN apk add -U --no-cache bash git build-base gcc make tzdata ca-certificates nodejs npm \
    && cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime \
    && echo "America/Sao_Paulo" > /etc/timezone

ARG HOME="/app"

RUN mkdir -p ${HOME}/src
WORKDIR ${HOME}/src

COPY mix.exs mix.lock ${HOME}/src/
COPY config/ ${HOME}/src/config

RUN mix local.hex --force && mix local.rebar --force

RUN mix deps.get && \
    mix deps.compile

COPY assets/ ${HOME}/src/assets

RUN cd assets && \
    npm install && \
    npm rebuild node-sass && \
    cd -

ENV PATH=./node_modules/.bin:$PATH

RUN cd assets/ && \
    npm run deploy && cd -

COPY lib/ ${HOME}/src/lib
COPY priv/ ${HOME}/src/priv

RUN mix compile && \
    mix phx.digest && \
    mix release

# ---------------------------------------------------------
# Run Release
# ---------------------------------------------------------
FROM alpine:3.11.6

ARG HOME="/app"

RUN apk add -U --no-cache bash ncurses-libs openssl tzdata

# IMPORTANT: Replace with your own timezone
RUN cp /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    echo "America/Sao_Paulo" > /etc/timezone

# IMPORTANT: Replace "my_app" with your application's name
COPY --from=build /app/src/_build/prod/rel/my_app /app/.

ENV MIX_ENV=${MIX_ENV}

CMD /app/bin/my_app start