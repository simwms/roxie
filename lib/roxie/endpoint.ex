defmodule Roxie.Endpoint do
  use Phoenix.Endpoint, otp_app: :roxie

  socket "/socket", Roxie.UserSocket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :roxie, gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug CORSPlug, 
    headers: ["Authorization", "Content-Type", "Accept", "Origin",
              "User-Agent", "DNT","Cache-Control", "X-Mx-ReqToken",
              "Keep-Alive", "X-Requested-With", "If-Modified-Since",
              "X-CSRF-Token", "roxie-remember-token", "roxie-master-key"]

  plug Plug.Session,
    store: :cookie,
    key: "_roxie_key",
    signing_salt: "3QDVavaz"

  plug Roxie.Router
end
