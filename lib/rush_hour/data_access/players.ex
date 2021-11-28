defmodule RushHour.DataAccess.Players do
  alias FE.Maybe

  alias RushHour.Repo

  alias RushHour.DataAccess.Schemas.Player
  alias RushHour.Services.ChangesetErrorHelper

  @spec find_by(keyword()) :: Maybe.t(%Player{})
  def find_by(keyword), do: Player |> Repo.get_by(keyword) |> Maybe.new()

  @spec insert(map()) :: Result.t(%Player{})
  def insert(params) do
    params
    |> Player.insert_changset()
    |> Repo.insert()
    |> ChangesetErrorHelper.handle_errors()
  end
end
