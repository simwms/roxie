defmodule Roxie.UserSessionPlug do
  import Plug.Conn
  import Phoenix.Controller, only: [render: 4]
  import Roxie.UserSessionHelper

  def init(_), do: []

  def call(conn, _) do
    case conn |> has_user_session? do
      {true, user} -> 
        conn 
        |> affirm_user_session!(user)
      {false, _} ->
        conn
        |> put_status(:forbidden)
        |> render(Roxie.ErrorView, "forbidden.json", msg: "Not logged in")
        |> halt
    end
  end
end