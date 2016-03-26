defmodule Agare.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :image, :string
      add :provider, :string
      add :uid, :string

      timestamps
    end

  end
end
