defmodule RushHour.Services.Players do
  alias FE.Result
  alias RushHour.DataAccess

  def find_or_create(full_name, position, short_name) do
    with {:just, %{id: team_id}} <- DataAccess.Teams.find_by(short_name: short_name) do
      params = prepare_insert_params(full_name, position, team_id)
      keyword = Map.to_list(params)

      case DataAccess.Players.find_by(keyword) do
        :nothing -> DataAccess.Players.insert(params)
        {:just, player} -> Result.ok(player)
      end
    else
      :nothing -> Result.error(:team_not_found)
    end
  end

  defp prepare_insert_params(full_name, position, team_id) do
    [first_name, last_name] = String.split(full_name, " ", parts: 2)
    %{first_name: first_name, last_name: last_name, position: position, team_id: team_id}
  end
end
