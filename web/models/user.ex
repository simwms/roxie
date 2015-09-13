defmodule Roxie.User do
  use Roxie.Web, :model
  use Pipe
  schema "users" do
    field :email, :string
    field :remember_token, :string
    field :password_hash, :string
    field :recovery_hash, :string

    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    timestamps
  end

  @required_fields ~w(email)
  @virtual_fields ~w(password password_confirmation)
  @optional_fields ~w(password_hash recovery_hash remember_token)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @virtual_fields)
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase/1)
    |> unique_constraint(:email)
    |> validate_length(:password, min: 1)
    |> validate_confirmation(:password)
  end

  @password_hash_opts [min_length: 1, extra_chars: false]
  before_insert :punch_password
  def punch_password(changeset) do
    params = %{
      "email" => changeset |> get_field(:email),
      "password" => changeset |> get_field(:password)
    }
    case params |> Comeonin.create_user(@password_hash_opts) do
      {:ok, p} -> 
        changeset |> cast(p, @required_fields, @optional_fields)
      {:error, _} -> 
        changeset
    end
  end

  before_insert :punch_remember_token
  def punch_remember_token(changeset) do
    token = pipe_with &hash_together/2,
      get_field(changeset, :email)
      |> Fox.RandomExt.uniform
      |> Fox.StringExt.random

    changeset |> put_change(:remember_token, token)
  end

  def hash_together(key, salt_generator) do
    salt = salt_generator.(121) |> to_string
    :crypto.hmac(:sha256, key, salt)
    |> Base.encode64
  end
end
