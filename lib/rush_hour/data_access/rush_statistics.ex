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
    per_page = Map.get(params, "per_page", 15)
    sort_by = Map.get(params, "sort_by", [])
    maybe_search_query = Map.get(params, "search") |> Maybe.new()

    RushStatistic
    |> from(as: :rush_statistics)
    |> join(:inner, [rush_statistics: rs], p in assoc(rs, :player), as: :players)
    |> preload(player: :team)
    |> order_by(^sort_by)
    |> maybe_search_query(maybe_search_query)
    |> paginate(page, per_page)
    |> Repo.all()
    |> Result.ok()
  end

  @spec transform_to_csv([%RushStatistic{}]) :: Result.t(function())
  def transform_to_csv(rush_statistics) do
    csv_headers()
    |> Stream.concat(
      rush_statistics
      |> Stream.map(
        &[
          "#{&1.player.first_name} #{&1.player.last_name}",
          &1.player.team.short_name,
          &1.player.position,
          &1.total_yards,
          "#{&1.longest_rush}#{maybe_add_T_if_touchdown(&1.was_longest_touchdown)}",
          &1.total_touchdowns,
          &1.avg_att_per_game,
          &1.total_attempts,
          &1.avg_yds_per_att,
          &1.avg_yds_per_game,
          &1.first_downs,
          &1.first_downs_percentage,
          &1.more_than_twenty_yds,
          &1.more_than_forty_yds,
          &1.fumbles
        ]
      )
    )
    |> CSV.encode()
    |> Result.ok()
  end

  defp csv_headers() do
    [
      [
        "player",
        "team",
        "position",
        "total rushing yards",
        "longest rush",
        "total rushing touchdowns",
        "avg att/g",
        "total attempts",
        "avg yds/att",
        "avg yds/g",
        "first downs",
        "first downs percentage",
        "20+ yds rushes",
        "40+ yds rushes",
        "fumbles"
      ]
    ]
  end

  defp maybe_search_query(query, :nothing), do: query

  defp maybe_search_query(query, {:just, search_query}) do
    like_query = "%#{search_query}%"

    where(
      query,
      [players: p],
      ilike(p.first_name, ^like_query) or ilike(p.last_name, ^like_query)
    )
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

  defp maybe_add_T_if_touchdown(true), do: "T"
  defp maybe_add_T_if_touchdown(false), do: ""
end
