FROM ruby:3.1.3

RUN apt-get update -qq && apt-get install -y postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock ./
COPY . .

RUN bundle install

RUN gem install rake

ENV DBHOST=postgresql
ENV DBUSER=postgres
ENV DBPASS=password
ENV DBURL="postgresql://${DBUSER}:${DBPASS}@${DBHOST}"

ENV DBTEST=true

ENTRYPOINT ["./bin/start"]
EXPOSE 3000
EXPOSE 9876

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
