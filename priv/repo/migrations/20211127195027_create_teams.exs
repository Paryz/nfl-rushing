defmodule RushHour.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :short_name, :string

      timestamps()
    end
  end
end
