FROM gliderlabs/alpine:latest
MAINTAINER ash@the-rebellion.net

ENV APP_HOME /app
ENV BUNDLE_GEMFILE ./Gemfile.production

ADD ./config/repositories /etc/apk/repositories

RUN apk add --update-cache build-base bash openssl-dev ca-certificates tzdata wget ruby@edge ruby-dev@edge imagemagick@edge

RUN echo 'gem: --no-document' > /etc/gemrc
RUN gem install bundler foreman io-console

RUN mkdir -p ${APP_HOME}

WORKDIR /tmp
ADD src/Gemfile.production Gemfile.production
ADD src/Gemfile.production.lock Gemfile.production.lock
RUN bundle install -j4

COPY src ${APP_HOME}
WORKDIR ${APP_HOME}

ADD ./config/start /start
RUN chmod 755 /start

EXPOSE {{ userdata.app.port }}

CMD [ "/start" ]
