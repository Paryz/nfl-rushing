defmodule RushHourWeb.Components.RushStatistics.ListRow do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <tr phx-value-row_id={@row.id}>
      <td class="py-4 whitespace-nowrap">
        <div class="flex justify-center">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= "#{@row.player.first_name} #{@row.player.last_name}"  %>
            </div>
          </div>
        </div>
      </td>
      <td class="py-4 whitespace-nowrap">
        <span class="flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.player.team.short_name %>
            </div>
          </div>
        </span>
      </td>
      <td class="py-4 whitespace-nowrap">
        <span class="flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.player.position %>
            </div>
          </div>
        </span>
      </td>
      <td class="py-4 whitespace-nowrap">
        <span class="flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.total_yards %>
            </div>
          </div>
        </span>
      </td>
      <td class="py-4 whitespace-nowrap">
        <span class="flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= "#{@row.longest_rush}#{maybe_add_T_if_touchdown(@row.was_longest_touchdown)}" %>
            </div>
          </div>
        </span>
      </td>
      <td class="py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.total_touchdowns %>
            </div>
          </div>
        </span>
      </td>
      <td class="hidden lg:table-cell px-3 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.avg_att_per_game %>
            </div>
          </div>
        </span>
      </td>
      <td class="hidden lg:table-cell px-3 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.total_attempts %>
            </div>
          </div>
        </span>
      </td>
      <td class="hidden lg:table-cell px-3 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.avg_yds_per_att %>
            </div>
          </div>
        </span>
      </td>
      <td class="hidden lg:table-cell px-3 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.avg_yds_per_game %>
            </div>
          </div>
        </span>
      </td>
      <td class="hidden lg:table-cell px-3 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.first_downs %>
            </div>
          </div>
        </span>
      </td>
      <td class="hidden lg:table-cell px-3 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= "#{@row.first_downs_percentage}%" %>
            </div>
          </div>
        </span>
      </td>
      <td class="hidden lg:table-cell px-3 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.more_than_twenty_yds %>
            </div>
          </div>
        </span>
      </td>
      <td class="hidden lg:table-cell px-3 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.more_than_forty_yds %>
            </div>
          </div>
        </span>
      </td>
      <td class="hidden lg:table-cell px-3 py-4 whitespace-nowrap">
        <span class="px-2 flex justify-center text-xs leading-5 font-semibold rounded-full">
          <div>
            <div class="text-xs font-medium text-gray-900">
              <%= @row.fumbles %>
            </div>
          </div>
        </span>
      </td>
    </tr>
    """
  end

  defp maybe_add_T_if_touchdown(true), do: "T"
  defp maybe_add_T_if_touchdown(false), do: ""
end
