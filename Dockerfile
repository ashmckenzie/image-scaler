FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

ENV APP_HOME /app

ADD ./config/repositories /etc/apk/repositories

RUN apk add --update-cache build-base bash openssl-dev ca-certificates tzdata wget ruby@edge ruby-dev@edge

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman io-console

RUN mkdir -p ${APP_HOME}

WORKDIR /tmp
ADD src/Gemfile.production Gemfile.production
ADD src/Gemfile.production.lock Gemfile.production.lock
ENV BUNDLE_GEMFILE ./Gemfile.production
RUN bundle install -j4

COPY ./src .
ADD src /app
WORKDIR ${APP_HOME}

ADD ./config/start /start
RUN chmod 755 /start

EXPOSE 80

CMD [ "/start" ]
