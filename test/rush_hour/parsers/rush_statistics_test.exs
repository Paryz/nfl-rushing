defmodule RushHour.Parsers.RushStatisticsTest do
  use RushHour.DataCase

  alias RushHour.SeedHelper

  describe "new/1" do
    test "parses properly fields" do
      "test/support/files/rushing.json"
      |> File.read()
      |> Result.and_then(&Jason.decode(&1, keys: :strings))
      |> Result.and_then(&SeedHelper.parse_and_save_teams/1)
      |> Result.and_then(&SeedHelper.parse_and_save_player_with_stats/1)

      assert [] == Repo.all(Team)
    end
  end
end
