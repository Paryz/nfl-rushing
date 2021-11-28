defmodule RushHour.DataAccess.Schemas.RushStatistic do
  use Ecto.Schema
  import Ecto.Changeset
  alias RushHour.DataAccess.Schemas.Player

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  @required_params [
    :player_id,
    :avg_att_per_game,
    :total_attempts,
    :avg_yds_per_att,
    :avg_yds_per_game,
    :total_yards,
    :total_touchdowns,
    :longest_rush,
    :was_longest_touchdown,
    :first_downs,
    :first_downs_percentage,
    :more_than_twenty_yds,
    :more_than_forty_yds,
    :fumbles
  ]
  schema "rush_statistics" do
    field :avg_att_per_game, :float
    field :total_attempts, :integer
    field :avg_yds_per_att, :float
    field :avg_yds_per_game, :float
    field :total_yards, :integer
    field :total_touchdowns, :integer
    field :longest_rush, :integer
    field :was_longest_touchdown, :boolean
    field :first_downs, :integer
    field :first_downs_percentage, :float
    field :more_than_twenty_yds, :integer
    field :more_than_forty_yds, :integer
    field :fumbles, :integer

    belongs_to :player, Player

    timestamps(type: :utc_datetime)
  end

  def insert_changset(params) do
    %__MODULE__{}
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end

  def update_changset(old_record, params) do
    old_record
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
