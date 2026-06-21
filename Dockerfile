# Development dockerfile
FROM ruby:3.4.9

# Install nodejs on the default ruby 3 image for vite/ruby
RUN curl -sL https://deb.nodesource.com/setup_22.x | bash - && \
      apt-get install -y nodejs build-essential

WORKDIR /app

COPY Gemfile ./Gemfile
COPY Gemfile.lock ./Gemfile.lock
RUN bundle install

COPY package.json package-lock.json ./
RUN npm install

COPY . .

CMD ["bin/rails", "console"]
