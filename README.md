# Roxie

To start your Phoenix app:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](http://www.phoenixframework.org/docs/deployment).

## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: http://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

## How this works

First, you create an upload token:
```elixir
$ curl https://api.roxie.io/tokens \
  -u authorization_token \
  -d pictures=4
```

You'll get the response
```json
{
  id: "whatever",
  slug: "some-value"
}
```

On the client side JS, you use the token to make direct uploads to s3
```js
AWS.S3.Files.create(slug, {fileParams})
```