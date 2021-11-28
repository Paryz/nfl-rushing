defmodule RushHour.Repo.Migrations.CreateRushStatistics do
  use Ecto.Migration

  def change do
    create table(:rush_statistics) do
      add :player_id, references(:players)
      add :avg_att_per_game, :float
      add :total_attempts, :integer
      add :avg_yds_per_att, :float
      add :avg_yds_per_game, :float
      add :total_yards, :integer
      add :total_touchdowns, :integer
      add :longest_rush, :integer
      add :was_longest_touchdown, :boolean
      add :first_downs, :integer
      add :first_downs_percentage, :float
      add :more_than_twenty_yds, :integer
      add :more_than_forty_yds, :integer
      add :fumbles, :integer

      timestamps()
    end
  end
end
