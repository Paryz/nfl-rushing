defmodule RushHour.Services.PlayersTest do
  use RushHour.DataCase

  alias RushHour.DataAccess.Schemas.{Player, Team}
  alias RushHour.Services.Players

  describe "find_or_create/3" do
    test "fails to save player when team is not there" do
      assert FE.Result.error(:team_not_found) == Players.find_or_create("Tom Brady", "QB", "TB")
    end

    test "player already in db" do
      %Team{short_name: "TB"} |> Repo.insert!()

      %{id: player_id} =
        %Player{first_name: "Tom", last_name: "Brady", position: "QB"} |> Repo.insert!()

      assert {:ok, %Player{first_name: "Tom", last_name: "Brady", position: "QB"}} =
               Players.find_or_create("Tom Brady", "QB", "TB")

      assert %Player{first_name: "Tom", team_id: team_id} = Repo.get(Player, player_id)
      assert not is_nil(team_id)
    end

    test "creates player when not found" do
      %Team{short_name: "TB"} |> Repo.insert!()

      assert [] == Repo.all(Player)

      assert {:ok, %Player{id: player_id, first_name: "Tom", last_name: "Brady", position: "QB"}} =
               Players.find_or_create("Tom Brady", "QB", "TB")

      assert %Player{first_name: "Tom", team_id: team_id} = Repo.get(Player, player_id)
      assert not is_nil(team_id)
    end
  end
end
