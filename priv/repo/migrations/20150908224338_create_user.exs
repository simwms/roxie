defmodule Roxie.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :remember_token, :string
      add :password_hash, :string
      add :recovery_hash, :string

      timestamps
    end
    create unique_index(:users, [:email])
    create unique_index(:users, [:remember_token])
  end
end
