defmodule RushHour.Services.SeedHelper do
  alias RushHour.Repo

  alias FE.Result

  alias RushHour.Parsers

  def parse_and_save_teams(data) do
    data
    |> Enum.uniq_by(fn %{"Team" => team_name} -> team_name end)
    |> Enum.reduce(Ecto.Multi.new(), &find_or_insert_team/2)
    |> Repo.transaction()
    |> Result.map(fn _ -> data end)
  end

  defp find_or_insert_team(%{"Team" => short_team_name}, multi) do
    Ecto.Multi.run(multi, {:team, short_team_name}, fn _, _ ->
      RushHour.Services.Teams.find_or_create(short_team_name)
    end)
  end

  def parse_and_save_player_with_stats(data) do
    data
    |> Enum.uniq_by(fn %{"Player" => name} -> name end)
    |> Enum.reduce(Ecto.Multi.new(), &parse_rush_statistics/2)
    |> Repo.transaction()
    |> Result.map(fn _ -> data end)
  end

  defp parse_rush_statistics(
         %{"Player" => name, "Pos" => position, "Team" => team} = input,
         multi
       ) do
    Ecto.Multi.run(multi, {:player, name}, fn _, _ ->
      name
      |> RushHour.Services.Players.find_or_create(position, team)
      |> Result.and_then(&Parsers.RushStatistics.new(input, &1))
      |> Result.and_then(&RushHour.Services.RushStatistics.upsert/1)
    end)
  end
end
