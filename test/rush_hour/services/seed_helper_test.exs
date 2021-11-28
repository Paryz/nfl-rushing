defmodule RushHour.Services.SeedHelperTest do
  use RushHour.DataCase

  alias FE.Result

  alias RushHour.DataAccess.Schemas.{Player, RushStatistic, Team}
  alias RushHour.Services.SeedHelper

  describe "parsing" do
    test "parses properly fields" do
      "test/support/files/rushing.json"
      |> File.read()
      |> Result.and_then(&Jason.decode(&1, keys: :strings))
      |> Result.and_then(&SeedHelper.parse_and_save_teams/1)
      |> Result.and_then(&SeedHelper.parse_and_save_player_with_stats/1)

      assert [
               %{short_name: "BAL"},
               %{short_name: "CLE"},
               %{short_name: "DAL"},
               %{short_name: "JAX"},
               %{short_name: "MIN"},
               %{short_name: "NO"}
             ] = Repo.all(Team) |> Enum.sort_by(& &1.short_name)

      assert [
               %{first_name: "Joe", last_name: "Banyard", position: "RB"},
               %{first_name: "Lance", last_name: "Dunbar", position: "RB"},
               %{first_name: "Shaun", last_name: "Hill", position: "QB"},
               %{first_name: "Mark", last_name: "Ingram", position: "RB"},
               %{first_name: "Breshad", last_name: "Perriman", position: "WR"},
               %{first_name: "Charlie", last_name: "Whitehurst", position: "QB"}
             ] =
               Repo.all(Player)
               |> Enum.map(
                 &%{first_name: &1.first_name, last_name: &1.last_name, position: &1.position}
               )
               |> Enum.sort_by(& &1.last_name)

      assert [
               %{
                 avg_att_per_game: 0.1,
                 avg_yds_per_att: 2.0,
                 avg_yds_per_game: 0.1,
                 first_downs: 0,
                 first_downs_percentage: 0.0,
                 fumbles: 0,
                 longest_rush: 2,
                 more_than_forty_yds: 0,
                 more_than_twenty_yds: 0,
                 total_attempts: 1,
                 total_touchdowns: 0,
                 total_yards: 2,
                 was_longest_touchdown: false
               },
               %{
                 avg_att_per_game: 2.0,
                 avg_yds_per_att: 3.5,
                 avg_yds_per_game: 7.0,
                 first_downs: 0,
                 first_downs_percentage: 0.0,
                 fumbles: 0,
                 longest_rush: 7,
                 more_than_forty_yds: 0,
                 more_than_twenty_yds: 0,
                 total_attempts: 2,
                 total_touchdowns: 0,
                 total_yards: 7,
                 was_longest_touchdown: false
               },
               %{
                 avg_att_per_game: 2.0,
                 avg_yds_per_att: 0.5,
                 avg_yds_per_game: 1.0,
                 first_downs: 0,
                 first_downs_percentage: 0.0,
                 fumbles: 0,
                 longest_rush: 2,
                 more_than_forty_yds: 0,
                 more_than_twenty_yds: 0,
                 total_attempts: 2,
                 total_touchdowns: 0,
                 total_yards: 1,
                 was_longest_touchdown: false
               },
               %{
                 avg_att_per_game: 1.7,
                 avg_yds_per_att: 1.0,
                 avg_yds_per_game: 1.7,
                 first_downs: 0,
                 first_downs_percentage: 0.0,
                 fumbles: 0,
                 longest_rush: 9,
                 more_than_forty_yds: 0,
                 more_than_twenty_yds: 0,
                 total_attempts: 5,
                 total_touchdowns: 0,
                 total_yards: 5,
                 was_longest_touchdown: false
               },
               %{
                 avg_att_per_game: 0.7,
                 avg_yds_per_att: 3.4,
                 avg_yds_per_game: 2.4,
                 first_downs: 3,
                 first_downs_percentage: 33.3,
                 fumbles: 0,
                 longest_rush: 10,
                 more_than_forty_yds: 0,
                 more_than_twenty_yds: 0,
                 total_attempts: 9,
                 total_touchdowns: 1,
                 total_yards: 31,
                 was_longest_touchdown: false
               },
               %{
                 avg_att_per_game: 12.8,
                 avg_yds_per_att: 5.1,
                 avg_yds_per_game: 65.2,
                 first_downs: 49,
                 first_downs_percentage: 23.9,
                 fumbles: 2,
                 longest_rush: 75,
                 more_than_forty_yds: 2,
                 more_than_twenty_yds: 4,
                 total_attempts: 205,
                 total_touchdowns: 6,
                 total_yards: 1,
                 was_longest_touchdown: true
               }
             ] =
               Repo.all(RushStatistic)
               |> Enum.map(
                 &%{
                   avg_att_per_game: &1.avg_att_per_game,
                   total_attempts: &1.total_attempts,
                   avg_yds_per_att: &1.avg_yds_per_att,
                   avg_yds_per_game: &1.avg_yds_per_game,
                   total_yards: &1.total_yards,
                   total_touchdowns: &1.total_touchdowns,
                   longest_rush: &1.longest_rush,
                   was_longest_touchdown: &1.was_longest_touchdown,
                   first_downs: &1.first_downs,
                   first_downs_percentage: &1.first_downs_percentage,
                   more_than_twenty_yds: &1.more_than_twenty_yds,
                   more_than_forty_yds: &1.more_than_forty_yds,
                   fumbles: &1.fumbles
                 }
               )
               |> Enum.sort_by(& &1.total_attempts)
    end
  end
end
