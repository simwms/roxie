defmodule Roxie.TicketControllerTest do
  use Roxie.ConnCase

  setup do
    conn = conn()
    |> put_req_header("accept", "application/json")
    |> put_req_header("roxie-master-key", Roxie.MasterKeyPlug.master_key)
    {:ok, conn: conn}
  end

  @ticket_params %{"bucket" => "test-bucket", "filename" => "jax/dog.jpg"}
  test "it should properly render", %{conn: conn} do
    path = conn |> ticket_path(:show)
    response = conn
    |> get(path, @ticket_params)
    |> json_response(200)

    assert response["id"]
    assert response["signature"]
    assert response["access_key_id"]
  end
end
