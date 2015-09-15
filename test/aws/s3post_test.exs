defmodule Roxie.S3postTest do
  use Roxie.ModelCase

  test "whatever" do
    assert 1+1 == 2
  end

  @aws_params %{ "bucket" => "test", "filename" => "dog/test.txt"}
  test "aws generate" do
    %{signature: signature, policy: policy} = @aws_params |> Aws.generate 
    assert signature
    assert policy
  end

  test "hmac_sha256 parameter ordering" do
    a = "dog"
    b = "this is a big string"
    forward = Aws.hmac_sha256(a, b) |> Base.encode64
    reverse = Aws.hmac_sha256(b, a) |> Base.encode64
    refute forward == reverse
  end

#   @amazon_policy %{ 
#     "expiration" => "2007-12-01T12:00:00.000Z",
#     "conditions" => [
#       %{"bucket" => "johnsmith"},
#       ["starts-with", "$key", "user/eric/"],
#       %{"acl" => "public-read"},
#       %{"success_action_redirect" => "http://johnsmith.s3.amazonaws.com/new_post.html"},
#       ["eq", "$Content-Type", "text/html"],
#       %{"x-amz-meta-uuid" => "14365123651274"},
#       ["starts-with", "$x-amz-meta-tag", ""]
#     ]
#   }

#   @amazon_policy64 "eyAiZXhwaXJhdGlvbiI6ICIyMDA3LTEyLTAxVDEyOjAwOjAwLjAwMFoiLAogICJjb25kaXR
# pb25zIjogWwogICAgeyJidWNrZXQiOiAiam9obnNtaXRoIn0sCiAgICBbInN0YXJ0cy13aXRoIiwgIiRrZXkiLCAidXNlci9lcmljLyJd
# LAogICAgeyJhY2wiOiAicHVibGljLXJlYWQifSwKICAgIHsic3VjY2Vzc19hY3Rpb25fcmVkaXJlY3QiOiAiaHR0cDovL2pvaG5zbWl0a
# C5zMy5hbWF6b25hd3MuY29tL25ld19wb3N0Lmh0bWwifSwKICAgIFsiZXEiLCAiJENvbnRlbnQtVHlwZSIsICJ0ZXh0L2h0bWwiXSwKI
# CAgIHsieC1hbXotbWV0YS11dWlkIjogIjE0MzY1MTIzNjUxMjc0In0sCiAgICBbInN0YXJ0cy13aXRoIiwgIiR4LWFtei1tZXRhLXRhZy
# IsICIiXQogIF0KfQo="

#   @amazon_signature "qA7FWXKq6VvU68lI9KdveT1cWgF="
  
#   test "it should properly encode64" do
#     actual = @amazon_policy |> Aws.PoliGen.json64
#     assert actual == @amazon_policy64
#   end

end
