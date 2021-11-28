defmodule RushHourWeb.Controllers.DownloadController do
  use RushHourWeb, :controller

  def download_csv(conn, params) do
    params = parse_params(params)

    conn =
      conn
      |> put_resp_content_type("text/csv")
      |> put_resp_header("content-disposition", ~s[attachment; filename="report.csv"])
      |> send_chunked(:ok)

    RushHour.Repo.transaction(fn ->
      {:ok, content} = RushHour.Services.RushStatistics.download_csv(params)

      chunk_data(conn, content)
    end)

    conn
  end

  defp chunk_data(conn, stream) do
    for row <- stream do
      conn |> chunk(row)
    end
  end

  defp parse_params(%{"sort_by" => sort_by} = params) do
    Map.merge(params, %{
      "sort_by" => get_sort_by_function(sort_by),
      "page" => 0,
      "per_page" => 10000
    })
  end

  defp get_sort_by_function("total_yards_desc"), do: [desc: :total_yards]
  defp get_sort_by_function("total_yards_asc"), do: [asc: :total_yards]
  defp get_sort_by_function("longest_rush_desc"), do: [desc: :longest_rush]
  defp get_sort_by_function("longest_rush_asc"), do: [asc: :longest_rush]
  defp get_sort_by_function("total_touchdowns_desc"), do: [desc: :total_touchdowns]
  defp get_sort_by_function("total_touchdowns_asc"), do: [asc: :total_touchdowns]
  defp get_sort_by_function(_), do: []
end
