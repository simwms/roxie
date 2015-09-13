defmodule Roxie.EasyTicket do

  @type t :: %Roxie.EasyTicket{
    signature: String.t,
    acl: String.t,
    bucket: String.t,
    policy64: String.t,
    policy: Map.t,
    access_key_id: String.t,
    post_url: String.t,
    show_url: String.t,
    expires_at: String.t
  }
  defstruct acl: "public-read",
    bucket: "",
    policy64: "",
    policy: %{},
    signature: "",
    access_key_id: "", 
    post_url: "",
    show_url: "",
    expires_at: ""


  def generate(params) do
    aws = params |> Aws.generate

    %__MODULE__{
      signature: aws.signature,
      policy64: aws.policy64,
      policy: aws.policy,
      access_key_id: aws.access_key_id,
      bucket: aws.bucket,
      expires_at: aws.policy["expiration"],
      post_url: infer_post_url(aws),
      show_url: infer_post_url(aws) |> Path.join(params["filename"])
    }
  end

  def infer_post_url(%{bucket: bucket}) do
    bucket |> S3post.process_url
  end

end