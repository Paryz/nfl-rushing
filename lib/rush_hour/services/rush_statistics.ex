defmodule RushHour.Services.RushStatistics do
  alias RushHour.DataAccess
  alias RushHour.DataAccess.Schemas.RushStatistic

  def upsert(%RushStatistic{} = new_stats) do
    [player_id: new_stats.player_id]
    |> DataAccess.RushStatistics.find_by()
    |> case do
      :nothing ->
        new_stats |> Map.from_struct() |> DataAccess.RushStatistics.insert()

      {:just, old_stats} ->
        DataAccess.RushStatistics.update(old_stats, Map.from_struct(new_stats))
    end
  end
end
