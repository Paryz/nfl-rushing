defmodule RushHourWeb.Components.RushStatistics.List do
  use Phoenix.Component
  alias RushHourWeb.Components.RushStatistics.ListRow

  def render(assigns) do
    ~H"""
    <div class="-my-2 overflow-x-auto">
      <div class="py-2 align-middle inline-block min-w-full sm:px-6 lg:px-8">
        <div class="shadow overflow-hidden border-b border-gray-200 sm:rounded-lg">
          <table class="min-w-full divide-y divide-gray-200 -mb-0">
            <thead class="bg-gray-50">
              <tr>
                <th scope="col" class="text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Player
                </th>
                <th scope="col" class="text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Team
                </th>
                <th scope="col" class="text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Pos
                </th>
                <th scope="col" class="text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  <div>
                    Yds
                  </div>
                  <div>
                    <%= live_patch "↑", to: RushHourWeb.Router.Helpers.page_path(@socket, :index, %{sort_by: "total_yards_asc"}) %>
                    <%= live_patch "↓", to: RushHourWeb.Router.Helpers.page_path(@socket, :index, %{sort_by: "total_yards_desc"}) %>
                  </div>
                </th>
                <th scope="col" class="text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  <div>
                    Lng
                  </div>
                  <div>
                    <%= live_patch "↑", to: RushHourWeb.Router.Helpers.page_path(@socket, :index, %{sort_by: "longest_rush_asc"}) %>
                    <%= live_patch "↓", to: RushHourWeb.Router.Helpers.page_path(@socket, :index, %{sort_by: "longest_rush_desc"}) %>
                  </div>
                </th>
                <th scope="col" class="text-center py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  <div>
                    TD
                  </div>
                  <div class="flex">
                    <%= live_patch "↑", to: RushHourWeb.Router.Helpers.page_path(@socket, :index, %{sort_by: "total_touchdowns_asc"}) %>
                    <%= live_patch "↓", to: RushHourWeb.Router.Helpers.page_path(@socket, :index, %{sort_by: "total_touchdowns_desc"}) %>
                  </div>
                </th>
                <th scope="col" class="hidden lg:table-cell text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Avg Att/G
                </th>
                <th scope="col" class="hidden lg:table-cell text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Total Attempts
                </th>
                <th scope="col" class="hidden lg:table-cell text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Avg Yds/Att
                </th>
                <th scope="col" class="hidden lg:table-cell text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Avg Yds/G
                </th>
                <th scope="col" class="hidden lg:table-cell text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  1ST
                </th>
                <th scope="col" class="hidden lg:table-cell text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  1ST%
                </th>
                <th scope="col" class="hidden lg:table-cell text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  20+
                </th>
                <th scope="col" class="hidden lg:table-cell text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  40+
                </th>
                <th scope="col" class="hidden lg:table-cell text-center px-3 py-3 text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Fum
                </th>
              </tr>
            </thead>
            <tbody class="bg-white divide-y divide-gray-200">
              <%= for row <- @data do %>
                <ListRow.render row={row} />
              <% end %>
            </tbody>
          </table>
        </div>
      </div>
    </div>
    """
  end
end
