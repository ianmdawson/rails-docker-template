FROM ruby:4-alpine

# Install required linux tools/packages
RUN apk update \
&& apk upgrade \
&& apk add --update --no-cache \
build-base curl-dev git \
postgresql-dev postgresql-client \
yaml-dev zlib-dev tzdata \
nodejs npm bash
WORKDIR /usr/src/app

# Install dependencies (for ruby)
COPY Gemfile* ./
RUN gem install bundler
RUN bundle check || bundle install

# Copy the project into the image
COPY . .

# Add a script to be executed every time the container starts.
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

# Expose port 3000 to the Docker host, so we can access it from the outside.
EXPOSE 3000 3035

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

