defmodule RushHour.DataAccess.RushStatistics do
  alias FE.Maybe

  alias RushHour.Repo

  alias RushHour.DataAccess.Schemas.RushStatistic
  alias RushHour.Services.ChangesetErrorHelper

  @spec find_by(keyword()) :: Maybe.t(%RushStatistic{})
  def find_by(keyword), do: RushStatistic |> Repo.get_by(keyword) |> Maybe.new()

  @spec insert(map()) :: Result.t(%RushStatistic{})
  def insert(params) do
    params
    |> RushStatistic.insert_changset()
    |> Repo.insert()
    |> ChangesetErrorHelper.handle_errors()
  end

  @spec update(map(), map()) :: Result.t(%RushStatistic{})
  def update(old_rush_statistics, new_rush_statistics) do
    old_rush_statistics
    |> RushStatistic.update_changset(new_rush_statistics)
    |> Repo.update()
    |> ChangesetErrorHelper.handle_errors()
  end
end
