# Running

I threw this together on a machine running Fedora. YMMV on any other system.

First, pull a PostgreSQL image via `podman`:

```bash
podman pull postgres
```

Start the container:

```bash
podman run \
       --rm \
       --name pg \
       -p 5432:5432 \
       -e POSTGRES_USER=postgres \
       -e POSTGRES_PASSWORD=password \
       -e POSTGRES_DB=offertorium \
       -d \
       postgres
```

Run migrations:

```
DBURL=postgresql://postgres:password@localhost rake db:migrate
```

Install dependencies with `bundle install` and finally run tests:

```
bundle exec rspec
```

## Via `curl`

Run the app:

```bash
DBURL=postgresql://postgres:password@localhost rails server -b 0.0.0.0
```

Add a demographic:

```bash
$ curl -H "Content-Type: application/json" localhost:3000/api/v1/demographics -d '{"name":"zoomers","start_date":"1997-01-01","end_date":"2010-12-31","gender":"male"}'
{"date_range":{"lower":"1997-01-01","upper":"2011-01-01","bounds":"[)"},"id":612,"name":"zoomers","gender":"male"}
```

Add an offer:

```bash
$ curl -H "Content-Type: application/json" localhost:3000/api/v1/offers -d '{"name":"frobs","target_demographic":{"date_range":{"from":"2000-01-01","to":"2010-01-01"}}}'
{"id":446,"name":"frobs"}
```

Add a user matching both of the above:

```bash
$ curl -H "Content-Type: application/json" localhost:3000/api/v1/users -d '{"username":"foobar", "first_name":"foo", "last_name":"bar", "birth_date":"2005-01-01", "password":"password", "gender":"male"}'
{"id":1,"username":"foobar","birth_date":"2005-01-01","first_name":"foo","gender":"male","last_name":"bar","password":"password"}
```

Finally, query for offers associated with the user created previously:

```bash
$ curl 'localhost:3000/api/v1/users/offers?username=foobar'
{"id":1,"username":"foobar","birth_date":"2005-01-01","first_name":"foo","gender":"male","last_name":"bar","password":"password","offers":[{"id":1,"name":"widgets","user_id":1}]}
```
