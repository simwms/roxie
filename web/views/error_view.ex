defmodule Roxie.ErrorView do
  use Roxie.Web, :view

  def render("missing.json", %{keys: keys, optional_keys: okeys}) when is_list(keys) do
    %{"message" => "Your request could not be processed because you were missing the following query params",
    "required_keys" => Enum.join(keys, ","),
    "optional_keys" => Enum.join(keys, ","),
    "example_request" => "/api/tickets?access_key_id=Akainu&secret_access_key=If4ceth3nkill&filename=mydir%2Fmyfile.jpg&bucket=roxie"}
  end

  def render("forbidden.json", %{msg: msg}) do
    %{"error" => msg}
  end
  def render("forbidden.json", _assigns) do
    %{"error" => "yo, seriously not authorized"}
  end
  
  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Server internal error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
