defmodule RushHour.Repo.Migrations.CreatePlayers do
  use Ecto.Migration

  def change do
    create table(:players) do
      add :first_name, :string
      add :last_name, :string
      add :team_id, references(:teams)
      add :position, :string

      timestamps()
    end
  end
end
