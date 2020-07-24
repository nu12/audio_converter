FROM ruby:2.6.5-alpine as builder

ENV RAILS_ENV=production

WORKDIR /app

COPY Gemfile package.json yarn.lock /app/

RUN apk add --no-cache nodejs yarn build-base tzdata \
 && bundle install --without development test

COPY . /app/

RUN bin/rails assets:precompile

FROM ruby:2.6.5-alpine

WORKDIR /app

ENV RAILS_LOG_TO_STDOUT=true \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

RUN apk add --no-cache ffmpeg tzdata

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/ /app/

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]