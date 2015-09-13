defmodule Roxie.TicketController do
  use Roxie.Web, :controller

  def show(conn, params) do
    params = params
    |> Dict.put_new("access_key_id", Aws.access_key_id)
    |> Dict.put_new("secret_access_key", Aws.secret_access_key)

    conn |> Roxie.EasyTicketController.show(params)
  end
  
end
