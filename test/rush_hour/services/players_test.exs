defmodule RushHour.Services.PlayersTest do
  use RushHour.DataCase

  alias RushHour.DataAccess.Schemas.Player
  alias RushHour.Services.Players

  describe "find_or_create/3" do
    test "fails to save player when team is not there" do
      assert FE.Result.error(:team_not_found) == Players.find_or_create("Tom Brady", "QB", "TB")
    end

    test "player already in db" do
      %{id: team_id} = insert(:team)
      %{id: player_id} = insert(:player, team_id: team_id)

      assert {:ok, %Player{first_name: "Tom", last_name: "Brady", position: "QB"}} =
               Players.find_or_create("Tom Brady", "QB", "TB")

      assert %Player{first_name: "Tom", team_id: ^team_id} = Repo.get(Player, player_id)
    end

    test "creates player when not found" do
      %{id: team_id} = insert(:team)

      assert [] == Repo.all(Player)

      assert {:ok, %Player{id: player_id, first_name: "Tom", last_name: "Brady", position: "QB"}} =
               Players.find_or_create("Tom Brady", "QB", "TB")

      assert %Player{first_name: "Tom", team_id: ^team_id} = Repo.get(Player, player_id)
    end
  end
end
