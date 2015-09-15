defmodule Roxie.EasyTicketController do
  use Roxie.Web, :controller
  alias Roxie.EasyTicket

  def show(conn, %{"access_key_id" => k, "secret_access_key" => s, "filename" => f}=p) when is_binary(k) and is_binary(s) and is_binary(f) do
    ticket = p |> EasyTicket.generate
    conn
    |> render(Roxie.TicketView, "show.json", ticket: ticket)
  end

  @required_keys ~w(access_key_id secret_access_key filename)
  @optional_keys ~w(minutes_til_expiration hours_til_expiration bucket)
  def show(conn, _) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Roxie.ErrorView, "missing.json", keys: @required_keys, optional_keys: @optional_keys)
  end
end