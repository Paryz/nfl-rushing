defmodule RushHour.DataAccess.RushStatistics do
  import Ecto.Query
  alias FE.{Maybe, Result}

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

  @spec all_with_preloads(map()) :: Result.t([%RushStatistic{}])
  def all_with_preloads(params) do
    page = Map.get(params, "page", 0)
    sort_by = Map.get(params, "sort_by", [])

    RushStatistic
    |> from(as: :rush_statistics)
    |> preload(player: :team)
    |> order_by(^sort_by)
    |> paginate(page, 15)
    |> Repo.all()
    |> Result.ok()
  end

  defp paginate(query, page, per_page) do
    case page > 0 do
      true ->
        offset_by = page * per_page

        query
        |> limit(^per_page)
        |> offset(^offset_by)

      false ->
        limit(query, ^per_page)
    end
  end
end
