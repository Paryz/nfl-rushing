defmodule RushHourWeb.PageLive do
  use RushHourWeb, :live_view
  alias RushHourWeb.Components.RushStatistics.List

  alias RushHour.Services.RushStatistics

  @impl true
  def mount(params, _session, socket) do
    params = parse_params(params)

    socket
    |> assign(:data, fetch_all_rush_statistics(params))
    |> assign(:page, Map.get(params, "page", "1"))
    |> FE.Result.ok()
  end

  @impl true
  def handle_event("next", _params, socket) do
    page = socket.assigns.page + 1

    {:noreply,
     socket
     |> assign(data: fetch_all_rush_statistics(%{"page" => page}))
     |> assign(page: page)}
  end

  def handle_event("previous", _params, socket) do
    page = socket.assigns.page - 1

    {:noreply,
     socket
     |> assign(data: fetch_all_rush_statistics(%{"page" => page}))
     |> assign(page: page)}
  end

  @impl true
  def handle_event("sort", %{"key" => key, "direction" => direction}, socket) do
    params = %{sort_key: key, sort_direction: direction}
    {:noreply, assign(socket, data: fetch_all_rush_statistics(params))}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    {:noreply, assign(socket, data: fetch_all_rush_statistics(%{search: query}))}
  end

  @impl true
  def handle_event("downlaod-csv", %{"data" => data}, socket) do
    {:noreply, assign(socket, results: [], data: data)}
  end

  defp fetch_all_rush_statistics(params) do
    params
    |> RushStatistics.fetch_all_with_preloads()
    |> FE.Result.unwrap!()
  end

  defp parse_params(params) do
    params
    |> Map.get("page", "1")
    |> then(&Map.put(params, "page", parse_string_to_int(&1)))
  end

  defp parse_string_to_int(string) do
    string
    |> Integer.parse()
    |> case do
      {int, _} -> int
      :error -> :error
    end
  end
end
