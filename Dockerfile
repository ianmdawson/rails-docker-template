FROM ruby:2.6.6-alpine

# Install required linux tools/packages
RUN apk update \
&& apk upgrade \
&& apk add --update --no-cache \
build-base curl-dev git \
postgresql-dev postgresql-client \
yaml-dev zlib-dev tzdata \
nodejs npm bash
RUN npm install -g yarn
WORKDIR /usr/src/app

# Install dependencies (for ruby and node)
COPY package.json yarn.lock ./
RUN yarn install --check-files
COPY Gemfile* ./
RUN gem install bundler
RUN bundle check || bundle install

# Copy the project into the image
COPY . .

# Add docker-compose-wait tool
# docker-compose-wait will wait for conditions before starting the service
ENV WAIT_VERSION 2.7.2
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/$WAIT_VERSION/wait /wait
RUN chmod +x /wait

# Add a script to be executed every time the container starts.
ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]

# Expose port 3000 to the Docker host, so we can access it from the outside.
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]

