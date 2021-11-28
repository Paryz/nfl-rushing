defmodule RushHour.Factory do
  use ExMachina.Ecto, repo: RushHour.Repo

  alias RushHour.DataAccess.Schemas.{Player, RushStatistic, Team}

  def team_factory() do
    %Team{short_name: "TB"}
  end

  def player_factory() do
    %Player{position: "QB", first_name: "Tom", last_name: "Brady"}
  end

  def rush_statistic_factory() do
    %RushStatistic{
      avg_att_per_game: 0.5,
      total_attempts: 1,
      avg_yds_per_att: 0.5,
      avg_yds_per_game: 0.5,
      total_yards: 1,
      total_touchdowns: 1,
      longest_rush: 1,
      was_longest_touchdown: false,
      first_downs: 1,
      first_downs_percentage: 0.1,
      more_than_twenty_yds: 1,
      more_than_forty_yds: 1,
      fumbles: 1
    }
  end
end
