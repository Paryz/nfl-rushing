defmodule RushHour.DataAccess.Schemas.Player do
  use Ecto.Schema
  import Ecto.Changeset

  alias RushHour.DataAccess.Schemas.{RushStatistic, Team}

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @required_params [:first_name, :last_name, :position, :team_id]
  schema "players" do
    field :first_name, :string
    field :last_name, :string
    field :position, :string

    belongs_to :team, Team
    has_one :rush_statistic, RushStatistic

    timestamps(type: :utc_datetime)
  end

  def insert_changset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
