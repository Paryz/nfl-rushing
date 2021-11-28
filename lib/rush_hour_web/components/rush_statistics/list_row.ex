defmodule RushHourWeb.Components.RushStatistics.ListRow do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <tr phx-value-row_id={@row.id}>
      <td class="px-6 py-4 whitespace-nowrap">
        <div class="flex justify-center">
          <div>
            <div class="text-lg font-medium text-gray-900">
              <%= "#{@row.player.first_name} #{@row.player.last_name}"  %>
            </div>
          </div>
        </div>
      </td>
      <td class="px-6 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-lg font-medium text-gray-900">
              <%= @row.player.team.short_name %>
            </div>
          </div>
        </span>
      </td>
      <td class="px-6 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-lg font-medium text-gray-900">
              <%= @row.total_yards %>
            </div>
          </div>
        </span>
      </td>
    </tr>
    """
  end
end
