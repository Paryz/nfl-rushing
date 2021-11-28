defmodule RushHour.Services.ChangesetErrorHelper do
  def handle_errors(%Ecto.Changeset{} = changeset) do
    format_changeset(changeset)
  end

  def handle_errors({:error, %Ecto.Changeset{} = changeset}) do
    format_changeset(changeset)
  end

  def handle_errors({:error, _error} = error), do: error
  def handle_errors({:ok, _} = result), do: result

  def format_changeset(changeset) do
    errors =
      changeset.errors
      |> Enum.map(fn {key, {value, _context}} ->
        [message: "#{key} #{value}"]
      end)

    {:error, errors}
  end
end
