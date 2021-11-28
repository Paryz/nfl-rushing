defmodule RushHour.Services.RushStatistics do
  alias FE.Result

  alias RushHour.DataAccess
  alias RushHour.DataAccess.Schemas.RushStatistic

  @spec upsert(%RushStatistic{}) :: Result.t(%RushStatistic{})
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

  @spec fetch_all_with_preloads(map()) :: Result.t([%RushStatistic{}])
  def fetch_all_with_preloads(params) do
    DataAccess.RushStatistics.all_with_preloads(params)
  end

  @spec download_csv(map()) :: Result.t(binary())
  def download_csv(params) do
    params
    |> DataAccess.RushStatistics.all_with_preloads()
    |> Result.and_then(&DataAccess.RushStatistics.transform_to_csv/1)
  end
end
