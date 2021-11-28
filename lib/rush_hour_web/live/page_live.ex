defmodule RushHourWeb.PageLive do
  use RushHourWeb, :live_view
  alias RushHourWeb.Components.RushStatistics.List

  alias RushHour.Services.RushStatistics

  @impl true
  def mount(params, _session, socket) do
    sort_by = Map.get(params, "sort_by", "")

    params =
      Map.merge(parse_params(params, socket.assigns), %{
        "sort_by" => get_sort_by_function(sort_by)
      })

    socket
    |> assign(:socket, socket)
    |> assign(:data, fetch_all_rush_statistics(params))
    |> assign(:page, Map.get(params, "page", "0"))
    |> FE.Result.ok()
  end

  @impl true
  def handle_params(params, _uri, socket) do
    sort_by = Map.get(params, "sort_by", "")

    params =
      Map.merge(parse_params(params, socket.assigns), %{
        "sort_by" => get_sort_by_function(sort_by)
      })

    {:noreply,
     socket
     |> assign(:data, fetch_all_rush_statistics(params))
     |> assign(:sort_by, sort_by)}
  end

  @impl true
  def handle_event("next", params, socket) do
    sort_by = Map.get(socket.assigns, :sort_by, "")
    page = socket.assigns.page + 1

    params =
      Map.merge(parse_params(params, socket.assigns), %{
        "sort_by" => get_sort_by_function(sort_by),
        "page" => page
      })

    {:noreply,
     socket
     |> assign(data: fetch_all_rush_statistics(params))
     |> assign(page: page)}
  end

  def handle_event("previous", params, socket) do
    sort_by = Map.get(socket.assigns, :sort_by, "")
    page = ensure_page_bigger_than_zero(socket.assigns)

    params =
      Map.merge(parse_params(params, socket.assigns), %{
        "sort_by" => get_sort_by_function(sort_by),
        "page" => page
      })

    {:noreply,
     socket
     |> assign(data: fetch_all_rush_statistics(params))
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

  defp parse_params(params, assigns) do
    params
    |> Map.get("page", Map.get(assigns, :page, 0))
    |> then(&Map.put(params, "page", parse_string_to_int(&1)))
  end

  defp parse_string_to_int(int) when is_integer(int), do: int

  defp parse_string_to_int(string) do
    string
    |> Integer.parse()
    |> case do
      {int, _} -> int
      :error -> :error
    end
  end

  defp ensure_page_bigger_than_zero(assigns) do
    case assigns.page == 0 do
      true -> 0
      false -> assigns.page - 1
    end
  end

  defp get_sort_by_function("total_yards_desc"), do: [desc: :total_yards]
  defp get_sort_by_function("total_yards_asc"), do: [asc: :total_yards]
  defp get_sort_by_function("longest_rush_desc"), do: [desc: :longest_rush]
  defp get_sort_by_function("longest_rush_asc"), do: [asc: :longest_rush]
  defp get_sort_by_function("total_touchdowns_desc"), do: [desc: :total_touchdowns]
  defp get_sort_by_function("total_touchdowns_asc"), do: [asc: :total_touchdowns]
  defp get_sort_by_function(_), do: []
end
