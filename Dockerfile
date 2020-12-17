FROM ruby:2.6.5-alpine as builder

ENV RAILS_ENV=production

WORKDIR /app

COPY . /app/

RUN apk add --no-cache nodejs yarn build-base tzdata \
 && bundle install --without development test \
 && yarn install --production \
 && bin/rails webpacker:compile \
 && bin/rails assets:precompile

 # Remove unneeded files (cached *.gem, *.o, *.c)
RUN rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete \
 # Remove folders not needed in resulting image
 && rm -rf node_modules tmp/cache vendor/assets spec

FROM ruby:2.6.5-alpine

WORKDIR /app

ENV RAILS_LOG_TO_STDOUT=true \
    RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true

RUN apk add --no-cache ffmpeg tzdata

COPY --from=builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=builder /app/ /app/

EXPOSE 3000

ENTRYPOINT ["sh", "entrypoint.sh"]