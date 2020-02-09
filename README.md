# NanoCi

Simple selfhosted CI server built in Elixir and Phoenix.

## Local development
To start your Phoenix server:

  * Start postgres in docker-compose `docker-compose up -d`
  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Deployment

 * TODO

## TODO

 - [ ] Show logs in api while running
 - [ ] Simple frontend (create build, show output etc)
 - [ ] Api for listing builds
 - [ ] Api and frontend for creating repos
 - [ ] User management
 - [ ] Report status to github
 - [ ] Trigger build on github webhook
 - [ ] Document how to setup
 - [ ] Parse .nano.yaml and run steps in file
 - [ ] Support starting depending containers (from file, for example database)
