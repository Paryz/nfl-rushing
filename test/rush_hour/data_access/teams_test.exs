defmodule RushHour.DataAccess.TeamsTest do
  use RushHour.DataCase

  alias FE.{Maybe, Result}

  alias RushHour.DataAccess.Schemas.Team
  alias RushHour.DataAccess.Teams

  describe "find_by/1" do
    test "finds a team by keyword" do
      %Team{short_name: "TEN"} |> Repo.insert!()

      assert {:just, %Team{short_name: "TEN"}} = Teams.find_by(short_name: "TEN")
    end

    test "returns :nothing if no team is found" do
      assert Maybe.nothing() == Teams.find_by(short_name: "TEN")
    end
  end

  describe "insert/1" do
    test "inserts a team" do
      params = %{short_name: "TEN"}

      assert {:ok, %Team{short_name: "TEN"}} = Teams.insert(params)
    end

    test "returns error when short name missing" do
      params = %{}

      assert Result.error([[message: "short_name can't be blank"]]) == Teams.insert(params)
    end
  end
end
