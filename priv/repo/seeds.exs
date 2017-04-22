# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     OnlineTv.Repo.insert!(%OnlineTv.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias OnlineTv.Repo
alias OnlineTv.Category

for category <- ~w(Comedy Educational Music Sports Popular News Gaming Technology Entertainment Fashion Health) do
  Repo.get_by(Category, name: category) ||
	Repo.insert!(%Category{name: category})
end