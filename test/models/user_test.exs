defmodule Roxie.UserTest do
  use Roxie.ModelCase

  alias Roxie.User

  @valid_attrs %{email: "some@content", password: "password", password_confirmation: "password"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.errors == []
    assert changeset.valid?
  end

  test "insertion" do
    {:ok, user} = %User{} |> User.changeset(@valid_attrs) |> Repo.insert
    assert user.id
    assert user.password_hash
    assert user.remember_token
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
