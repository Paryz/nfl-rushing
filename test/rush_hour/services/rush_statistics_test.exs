defmodule RushHour.Services.RushStatisticsTest do
  use RushHour.DataCase

  alias RushHour.DataAccess.Schemas.RushStatistic
  alias RushHour.Services.RushStatistics

  describe "upsert/1" do
    test "insert stats when no stats found" do
      %{id: team_id} = insert(:team)
      %{id: player_id} = insert(:player, team_id: team_id)

      rush_stats_struct =
        params_for(:rush_statistic, player_id: player_id) |> then(&struct!(RushStatistic, &1))

      assert {:ok, %RushStatistic{id: id, player_id: ^player_id}} =
               RushStatistics.upsert(rush_stats_struct)

      assert %RushStatistic{} = Repo.get(RushStatistic, id)
    end

    test "insert stats when stats found" do
      %{id: team_id} = insert(:team)
      %{id: player_id} = insert(:player, team_id: team_id)
      %{id: stats_id} = insert(:rush_statistic, player_id: player_id)

      rush_stats_struct =
        params_for(:rush_statistic, player_id: player_id, total_touchdowns: 2)
        |> then(&struct!(RushStatistic, &1))

      assert %RushStatistic{total_touchdowns: 1} = Repo.get(RushStatistic, stats_id)

      assert {:ok, %RushStatistic{id: ^stats_id, player_id: ^player_id}} =
               RushStatistics.upsert(rush_stats_struct)

      assert %RushStatistic{total_touchdowns: 2} = Repo.get(RushStatistic, stats_id)
    end
  end

  describe "fetch_all_with_preloads/1" do
    setup do
      %{id: team_id} = insert(:team)
      %{id: player_id} = insert(:player, team_id: team_id)
      insert(:rush_statistic, player_id: player_id)

      %{id: team_id} = insert(:team, short_name: "TEN")

      %{id: player_id} =
        insert(:player,
          team_id: team_id,
          first_name: "Derrick",
          last_name: "Henry",
          position: "RB"
        )

      insert(:rush_statistic,
        player_id: player_id,
        total_yards: 100,
        longest_rush: 80,
        was_longest_touchdown: true,
        total_touchdowns: 30
      )

      %{id: team_id} = insert(:team, short_name: "KC")

      %{id: player_id} =
        insert(:player, team_id: team_id, first_name: "Travis", last_name: "Kelce", position: "TE")

      insert(:rush_statistic,
        player_id: player_id,
        total_yards: 30,
        longest_rush: 30,
        was_longest_touchdown: false,
        total_touchdowns: 2
      )

      %{id: team_id} = insert(:team, short_name: "LA")

      %{id: player_id} =
        insert(:player, team_id: team_id, first_name: "Jalen", last_name: "Ramsey", position: "CB")

      insert(:rush_statistic,
        player_id: player_id,
        total_yards: 80,
        longest_rush: 15,
        was_longest_touchdown: false,
        total_touchdowns: 3
      )

      {:ok, []}
    end

    test "sorted by total yards descending" do
      params = %{"sort_by" => [desc: :total_yards], "page" => 0, "per_page" => 15}

      assert {:ok,
              [
                %{total_yards: 100, player: %{last_name: "Henry", team: %{short_name: "TEN"}}},
                %{total_yards: 80, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}},
                %{total_yards: 30, player: %{last_name: "Kelce", team: %{short_name: "KC"}}},
                %{total_yards: 1, player: %{last_name: "Brady", team: %{short_name: "TB"}}}
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end

    test "sorted by total yards ascending" do
      params = %{"sort_by" => [asc: :total_yards], "page" => 0, "per_page" => 15}

      assert {:ok,
              [
                %{total_yards: 1, player: %{last_name: "Brady", team: %{short_name: "TB"}}},
                %{total_yards: 30, player: %{last_name: "Kelce", team: %{short_name: "KC"}}},
                %{total_yards: 80, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}},
                %{total_yards: 100, player: %{last_name: "Henry", team: %{short_name: "TEN"}}}
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end

    test "sorted by longest rush descending" do
      params = %{"sort_by" => [desc: :longest_rush], "page" => 0, "per_page" => 15}

      assert {:ok,
              [
                %{longest_rush: 80, player: %{last_name: "Henry", team: %{short_name: "TEN"}}},
                %{longest_rush: 30, player: %{last_name: "Kelce", team: %{short_name: "KC"}}},
                %{longest_rush: 15, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}},
                %{longest_rush: 1, player: %{last_name: "Brady", team: %{short_name: "TB"}}}
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end

    test "sorted by longest rush ascending" do
      params = %{"sort_by" => [asc: :longest_rush], "page" => 0, "per_page" => 15}

      assert {:ok,
              [
                %{total_yards: 1, player: %{last_name: "Brady", team: %{short_name: "TB"}}},
                %{longest_rush: 15, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}},
                %{longest_rush: 30, player: %{last_name: "Kelce", team: %{short_name: "KC"}}},
                %{longest_rush: 80, player: %{last_name: "Henry", team: %{short_name: "TEN"}}}
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end

    test "sorted by total touchdowns descending" do
      params = %{"sort_by" => [desc: :total_touchdowns], "page" => 0, "per_page" => 15}

      assert {:ok,
              [
                %{
                  total_touchdowns: 30,
                  player: %{last_name: "Henry", team: %{short_name: "TEN"}}
                },
                %{total_touchdowns: 3, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}},
                %{total_touchdowns: 2, player: %{last_name: "Kelce", team: %{short_name: "KC"}}},
                %{total_touchdowns: 1, player: %{last_name: "Brady", team: %{short_name: "TB"}}}
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end

    test "sorted by total touchdowns ascending" do
      params = %{"sort_by" => [asc: :total_touchdowns], "page" => 0, "per_page" => 15}

      assert {:ok,
              [
                %{total_touchdowns: 1, player: %{last_name: "Brady", team: %{short_name: "TB"}}},
                %{total_touchdowns: 2, player: %{last_name: "Kelce", team: %{short_name: "KC"}}},
                %{total_touchdowns: 3, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}},
                %{
                  total_touchdowns: 30,
                  player: %{last_name: "Henry", team: %{short_name: "TEN"}}
                }
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end

    test "filtered by name Tom" do
      params = %{"sort_by" => [], "search" => "Tom", "spage" => 0, "per_page" => 15}

      assert {:ok,
              [%{total_touchdowns: 1, player: %{last_name: "Brady", team: %{short_name: "TB"}}}]} =
               RushStatistics.fetch_all_with_preloads(params)
    end

    test "filtered by name ra" do
      params = %{"sort_by" => [], "search" => "ra", "spage" => 0, "per_page" => 15}

      assert {:ok,
              [
                %{total_touchdowns: 1, player: %{last_name: "Brady", team: %{short_name: "TB"}}},
                %{total_touchdowns: 2, player: %{last_name: "Kelce", team: %{short_name: "KC"}}},
                %{total_touchdowns: 3, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}}
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end

    test "filtered by name ra and sorted bo total_touchdowns descending" do
      params = %{
        "sort_by" => [desc: :total_touchdowns],
        "search" => "ra",
        "spage" => 0,
        "per_page" => 15
      }

      assert {:ok,
              [
                %{total_touchdowns: 3, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}},
                %{total_touchdowns: 2, player: %{last_name: "Kelce", team: %{short_name: "KC"}}},
                %{total_touchdowns: 1, player: %{last_name: "Brady", team: %{short_name: "TB"}}}
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end

    test "per page set to 2" do
      params = %{"sort_by" => [desc: :total_touchdowns], "page" => 0, "per_page" => 2}

      assert {:ok,
              [
                %{
                  total_touchdowns: 30,
                  player: %{last_name: "Henry", team: %{short_name: "TEN"}}
                },
                %{total_touchdowns: 3, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}}
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end

    test "page set to 1 and per page to 1" do
      params = %{"sort_by" => [desc: :total_touchdowns], "page" => 1, "per_page" => 1}

      assert {:ok,
              [
                %{total_touchdowns: 3, player: %{last_name: "Ramsey", team: %{short_name: "LA"}}}
              ]} = RushStatistics.fetch_all_with_preloads(params)
    end
  end

  describe "download_csv/1" do
    setup do
      %{id: team_id} = insert(:team)
      %{id: player_id} = insert(:player, team_id: team_id)
      insert(:rush_statistic, player_id: player_id)

      %{id: team_id} = insert(:team, short_name: "TEN")

      %{id: player_id} =
        insert(:player,
          team_id: team_id,
          first_name: "Derrick",
          last_name: "Henry",
          position: "RB"
        )

      insert(:rush_statistic,
        player_id: player_id,
        total_yards: 100,
        longest_rush: 80,
        was_longest_touchdown: true,
        total_touchdowns: 30
      )

      %{id: team_id} = insert(:team, short_name: "KC")

      %{id: player_id} =
        insert(:player, team_id: team_id, first_name: "Travis", last_name: "Kelce", position: "TE")

      insert(:rush_statistic,
        player_id: player_id,
        total_yards: 30,
        longest_rush: 30,
        was_longest_touchdown: false,
        total_touchdowns: 2
      )

      %{id: team_id} = insert(:team, short_name: "LA")

      %{id: player_id} =
        insert(:player, team_id: team_id, first_name: "Jalen", last_name: "Ramsey", position: "CB")

      insert(:rush_statistic,
        player_id: player_id,
        total_yards: 80,
        longest_rush: 15,
        was_longest_touchdown: false,
        total_touchdowns: 3
      )

      {:ok, []}
    end

    test "download a filtered csv" do
      params = %{"sort_by" => [desc: :total_touchdowns], "page" => 1, "per_page" => 1}

      assert {:ok,
              [
                "player,team,position,total rushing yards,longest rush,total rushing touchdowns,avg att/g,total attempts,avg yds/att,avg yds/g,first downs,first downs percentage,20+ yds rushes,40+ yds rushes,fumbles\r\n",
                "Jalen Ramsey,LA,CB,80,15,3,0.5,1,0.5,0.5,1,0.1,1,1,1\r\n"
              ]} == RushStatistics.download_csv(params) |> FE.Result.map(&Enum.to_list/1)
    end
  end
end
