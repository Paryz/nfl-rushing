defmodule RushHour.DataAccess.PlayersTest do
  use RushHour.DataCase

  alias FE.{Maybe, Result}

  alias RushHour.DataAccess.Schemas.Player
  alias RushHour.DataAccess.Players

  describe "find_by/1" do
    test "finds a player by keyword" do
      %Player{first_name: "Antonio", last_name: "Brown", position: "WR"} |> Repo.insert!()

      assert {:just, %Player{first_name: "Antonio", last_name: "Brown", position: "WR"}} =
               Players.find_by(first_name: "Antonio", last_name: "Brown", position: "WR")
    end

    test "returns :nothing if no player is found" do
      assert Maybe.nothing() ==
               Players.find_by(first_name: "Antonio", last_name: "Brown", position: "WR")
    end
  end

  describe "insert/1" do
    test "inserts a player" do
      params = %{first_name: "Tom", last_name: "Brady", position: "QB"}

      assert {:ok, %Player{first_name: "Tom", last_name: "Brady", position: "QB"}} =
               Players.insert(params)
    end

    test "returns error when first_name, last_name or position is missing" do
      params = %{last_name: "Brady", position: "QB"}
      assert Result.error([[message: "first_name can't be blank"]]) == Players.insert(params)

      params = %{first_name: "Tom", position: "QB"}
      assert Result.error([[message: "last_name can't be blank"]]) == Players.insert(params)

      params = %{first_name: "Tom", last_name: "Brady"}
      assert Result.error([[message: "position can't be blank"]]) == Players.insert(params)
    end
  end
end
