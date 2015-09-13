defmodule Aws.PoliGen do
  alias Timex.Date
  alias Timex.DateFormat

  def policy_hash64(params) do
    params |> policy |> json64
  end

  def json64(p) do
    p 
    |> Poison.encode! 
    |> String.replace("\n", "") 
    |> Base.encode64
  end

  # %{"bucket" => bucket},
  # ["starts-with", "$Content-Type", "image/"],
  # %{"x-amz-meta-uuid" => "14365123651274"},
  # ["starts-with", "$x-amz-meta-tag", ""],
  # %{"x-amz-credential" => amazon_credentials(params)},
  # %{"x-amz-algorithm" => "AWS4-HMAC-SHA256"},
  def policy(%{"bucket" => bucket, "filename" => key}=p) do
    %{
      "expiration" => (p |> some_time |> from_now),
      "conditions" => [
        %{"key" => key},
        %{"acl" => "public-read"},
        %{"bucket" => bucket}
      ]
    }
  end

  def some_time(params) do
    []
    |> seconds_til_expire(params)
    |> minutes_til_expire(params)
    |> hours_til_expire(params)
    |> parse_times
    |> default_expire
  end

  def default_expire([]), do: [hours: 1]
  def default_expire(times), do: times

  def parse_times([]), do: []
  def parse_times(times), do: parse_times(times, [])
  defp parse_times([], times), do: times
  defp parse_times([{u, n}|times], parsed_times) when is_integer(n) do
    parse_times(times, [{u,n}|parsed_times])
  end
  defp parse_times([{u,s}|times], parsed_times) when is_binary(s) do
    case s |> Integer.parse do
      {n, _} -> parse_times(times, [{u, n}|parsed_times])
      _ -> parse_times(times, parsed_times)
    end
  end

  def seconds_til_expire(times, %{"seconds_til_expiration" => n}) do
    times ++ [secs: n]
  end
  def seconds_til_expire(times, _), do: times

  def minutes_til_expire(times, %{"minutes_til_expiration" => n}) do
    times ++ [mins: n]
  end
  def minutes_til_expire(times, _), do: times

  def hours_til_expire(times, %{"hours_til_expiration" => n}) do
    times ++ [hours: n]
  end
  def hours_til_expire(times, _), do: times

  def from_now(times) do
    Date.now |> Date.shift(times) |> DateFormat.format!("{ISOz}")
  end

  def amazon_credentials(%{date: date}=params) do
    region = params |> Dict.get(:region, Aws.default_region)
    service = params |> Dict.get(:service, Aws.default_service)
    name = params |> Dict.get(:name, Aws.default_name)

    [Aws.access_key_id, date, region, service, name]
    |> Enum.join("/")
  end

end