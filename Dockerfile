FROM ruby:2.6.5-alpine

WORKDIR /app

ENV RAILS_LOG_TO_STDOUT=true \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

COPY Gemfile package.json yarn.lock /app/

RUN apk add --no-cache nodejs yarn ffmpeg build-base tzdata \
 && bundle install --without development test \
 && apk del build-base

COPY . /app/

RUN bin/rails assets:precompile

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]