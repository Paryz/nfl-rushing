defmodule RushHour.DataAccess.Schemas.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias RushHour.DataAccess.Schemas.Player

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @foreign_key_type Ecto.UUID
  schema "teams" do
    field :short_name, :string

    has_many :players, Player

    timestamps(type: :utc_datetime)
  end

  def insert_changset(params) do
    %__MODULE__{}
    |> cast(params, [:short_name])
    |> validate_required([:short_name])
  end
end
