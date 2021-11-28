defmodule RushHour.Services.Teams do
  alias FE.Result
  alias RushHour.DataAccess

  def find_or_create(short_name) do
    case DataAccess.Teams.find_by(short_name: short_name) do
      :nothing -> DataAccess.Teams.insert(%{short_name: short_name})
      {:just, team} -> Result.ok(team)
    end
  end
end
