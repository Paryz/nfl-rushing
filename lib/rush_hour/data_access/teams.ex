defmodule RushHour.DataAccess.Teams do
  alias FE.Maybe

  alias RushHour.Repo

  alias RushHour.DataAccess.Schemas.Team
  alias RushHour.Services.ChangesetErrorHelper

  @spec find_by(keyword()) :: Maybe.t(%Team{})
  def find_by(keyword), do: Team |> Repo.get_by(keyword) |> Maybe.new()

  @spec insert(map()) :: Result.t(%Team{})
  def insert(params) do
    params
    |> Team.insert_changset()
    |> Repo.insert()
    |> ChangesetErrorHelper.handle_errors()
  end
end
