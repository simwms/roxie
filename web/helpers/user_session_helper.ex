defmodule Roxie.UserSessionHelper do
  import Plug.Conn
  alias Roxie.Repo
  alias Roxie.User

  def has_user_session?(conn) do
    case current_user(conn) do
      nil -> {false, nil}
      user -> {true, user}
    end
  end

  def current_user(conn) do
    user_via_session(conn) || user_via_header(conn)
  end

  defp user_via_session(conn) do
    conn
    |> get_session(:current_user)
    |> find_user_by_id
  end

  defp user_via_header(conn) do
    conn
    |> get_req_header("roxie-remember-token")
    |> List.first
    |> find_user_by_remember_token
  end

  defp find_user_by_id(nil), do: nil
  defp find_user_by_id(id) do
    Repo.get(User, id)
  end

  defp find_user_by_remember_token(nil), do: nil
  defp find_user_by_remember_token(remember_token) do
    Repo.get_by(User, remember_token: remember_token)
  end

  def affirm_user_session!(conn, %{id: id}) when not is_nil id do
    conn
    |> put_session(:current_user, id)
  end
  def affirm_user_session!(conn, _), do: conn
end