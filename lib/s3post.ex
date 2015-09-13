defmodule S3post do
  use HTTPoison.Base

  def process_url(bucket) do
    "https://#{bucket}.s3.amazonaws.com"
  end
end