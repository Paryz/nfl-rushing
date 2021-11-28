# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     RushHour.Repo.insert!(%RushHour.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias FE.Result
alias RushHour.Services.SeedHelper

"priv/static/rushing.json"
|> File.read()
|> Result.and_then(&Jason.decode(&1, keys: :strings))
|> Result.and_then(&SeedHelper.parse_and_save_teams/1)
|> Result.and_then(&SeedHelper.parse_and_save_player_with_stats/1)
