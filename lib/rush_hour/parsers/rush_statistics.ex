defmodule RushHour.Parsers.RushStatistics do
  alias FE.Result

  alias RushHour.DataAccess.Schemas.{Player, RushStatistic}

  @spec new(map(), %Player{}) :: Result.t(%RushStatistic{})
  def new(object, %{id: player_id}) do
    %RushStatistic{
      player_id: player_id,
      avg_att_per_game: object["Att/G"],
      total_attempts: object["Att"],
      avg_yds_per_att: object["Avg"],
      avg_yds_per_game: object["Yds/G"],
      total_yards: parse_total_yards(object["Yds"]),
      total_touchdowns: object["TD"],
      longest_rush: parse_longest_rush(object["Lng"]),
      was_longest_touchdown: parse_longest_rush_touchdown(object["Lng"]),
      first_downs: object["1st"],
      first_downs_percentage: object["1st%"],
      more_than_twenty_yds: object["20+"],
      more_than_forty_yds: object["40+"],
      fumbles: object["FUM"]
    }
    |> Result.ok()
  end

  defp parse_total_yards(distance) when is_binary(distance) do
    distance
    |> String.trim(",")
    |> Integer.parse()
    |> case do
      {distance, _} -> distance
      :error -> :error
    end
  end

  defp parse_total_yards(distance) when is_integer(distance), do: distance

  defp parse_longest_rush(distance) when is_binary(distance) do
    distance
    |> String.ends_with?("T")
    |> case do
      true -> String.trim_trailing(distance, "T")
      false -> distance
    end
    |> Integer.parse()
    |> case do
      {distance, _} -> distance
      :error -> :error
    end
  end

  defp parse_longest_rush(distance) when is_integer(distance), do: distance

  defp parse_longest_rush_touchdown(distance) when is_binary(distance) do
    String.ends_with?(distance, "T")
  end

  defp parse_longest_rush_touchdown(_), do: false
end
