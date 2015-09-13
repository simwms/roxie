defmodule Aws.KeyGen do

  def date_key(date) do
    secret_access_key |> Aws.hmac_sha256(date)
  end

  def date_region_key(date) do
    date |> date_key |> Aws.hmac_sha256(Aws.default_region)
  end

  def date_region_service_key(date) do
    date |> date_region_key |> Aws.hmac_sha256(Aws.default_service)
  end

  def signing_key(date) do
    date |> date_region_service_key |> Aws.hmac_sha256(Aws.default_name)
  end

  def secret_access_key do
    "AWS4" <> Aws.secret_access_key
  end

end