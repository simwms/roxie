defmodule Aws do
  
  @type params :: %{
    bucket: String.t, 
    starts_with: String.t,
    date: String.t
  }

  @type output :: %{
    signature: String.t,
    policy64: String.t,
    policy: Map.t,
    access_key_id: String.t,
    bucket: String.t
  }
  
  @spec generate(params) :: output 
  def generate(params\\%{}) do
    params = params |> set_defaults

    policy = params |> Aws.PoliGen.policy

    policy64 = policy |> Aws.PoliGen.json64

    signature = params["secret_access_key"] |> Aws.SigGen.signature(policy64)

    %{
      signature: signature,
      policy64: policy64,
      policy: policy,
      key: params["filename"],
      bucket: params["bucket"],
      access_key_id: params["access_key_id"]
    }
  end

  def set_defaults(params) do
    params 
    |> Dict.put_new("date", short_date) 
    |> Dict.put_new("bucket", "roxie")
    |> Dict.put_new("access_key_id", access_key_id)
    |> Dict.put_new("secret_access_key", secret_access_key)
  end

  def defaults do
    Aws |> Application.get_env(:defaults)
  end

  def default_region, do: defaults[:region]
  def default_service, do: defaults[:service]
  def default_name, do: defaults[:name]

  def access_key_id, do: defaults[:access_key_id]
  def secret_access_key, do: defaults[:secret_access_key]

  def short_date do
    Timex.Date.now |> Timex.DateFormat.format!("%Y%m%d", :strftime)
  end

  def hmac_sha256(key, message) do
    :sha |> :crypto.hmac(key, message)
  end
end