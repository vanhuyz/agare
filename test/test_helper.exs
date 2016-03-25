ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Agare.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Agare.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Agare.Repo)

