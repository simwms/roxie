defmodule Aws.SigGen do
  
  def signature(key, policy) do
    Aws.hmac_sha256(key, policy)
    |> Base.encode64
    |> String.replace("\n", "")
  end

end