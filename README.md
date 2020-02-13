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

 * Start phoenix app expose behind https server
 * Add github webhook for push events on your repo `https://your-url.com/api/github` (json)
 * Connect to database and add urls and private deploy key in database and public key on github
 * Add `.nano.yaml` with `steps` key for every step to run during the build
