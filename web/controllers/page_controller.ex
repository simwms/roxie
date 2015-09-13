defmodule Roxie.PageController do
  use Roxie.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
