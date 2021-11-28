defmodule RushHour.Services.TeamsTest do
  use RushHour.DataCase

  alias RushHour.DataAccess.Schemas.Team
  alias RushHour.Services.Teams

  describe "find_or_create/1" do
    test "team already in db" do
      %{id: team_id} = insert(:team, short_name: "TEN")

      assert {:ok, %Team{short_name: "TEN"}} = Teams.find_or_create("TEN")
      assert %Team{} = Repo.get(Team, team_id)
    end

    test "creates team when not found" do
      assert [] == Repo.all(Team)
      assert {:ok, %Team{id: team_id, short_name: "TEN"}} = Teams.find_or_create("TEN")
      assert %Team{} = Repo.get(Team, team_id)
    end
  end
end
