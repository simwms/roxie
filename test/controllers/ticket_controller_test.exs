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
    %{"ticket" => response} = conn
    |> get(path, @ticket_params)
    |> json_response(200)

    assert response["id"] =~ ~r/\d+/
    assert response["signature"] =~ ~r/.{4,}/
    assert response["policy64"] =~ ~r/.{4,}/
    assert response["key"] == "jax/dog.jpg"
    assert response["bucket"] == "test-bucket"
    assert response["access_key_id"] =~ ~r/.{4,}/
  end

  @ticket_params2 %{ 
    "bucket" => "cum-bucket", 
    "filename" => "jax/cat.jpg",
    "storage_class" => "REDUCED_REDUNDANCY"
  }
  test "it should handle reduce redundancy", %{conn: conn} do
    path = conn |> ticket_path(:show)
    %{"ticket" => ticket} = conn
    |> get(path, @ticket_params2)
    |> json_response(200)    

    assert %{"expiration" => _, "conditions" => _} = ticket["policy"]
    conditions = ticket |> Dict.get("policy") |> Dict.get("conditions")
    assert conditions
    assert Enum.count(conditions) == 4
    assert [key_con, acl_con, buc_con, sto_con] = conditions
    assert sto_con == %{"x-amz-storage-class" => "REDUCED_REDUNDANCY"}
    assert buc_con == %{"bucket" => "cum-bucket"}
    assert acl_con == %{"acl" => "public-read"}
    assert key_con == %{"key" => "jax/cat.jpg"}
  end
end
