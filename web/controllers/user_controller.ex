defmodule OnlineTv.UserController do
	use OnlineTv.Web, :controller
	alias OnlineTv.User
	plug :authenticate_user when action in [:index, :show]

	def index(conn, _params) do
		users = Repo.all(OnlineTv.User)
		render conn, "index.html", users: users
	end

	def new(conn, _params) do
		changeset = User.changeset(%User{})
		render conn, "new.html", changeset: changeset
	end

	def show(conn, %{"id" => id}) do
		user = Repo.get(OnlineTv.User, id)
		render conn, "show.html", user: user
	end

	def create(conn, %{"user" => user_params}) do
		changeset = User.registration_changeset(%User{}, user_params)
		case Repo.insert(changeset) do
			{:ok, user} ->
				conn
				|> OnlineTv.Auth.login(user)
				|> put_flash(:info, "#{user.name} created!")
				|> redirect(to: user_path(conn, :index))

			{:error, changeset} ->
				render(conn, "new.html", changeset: changeset)
		end		
	end

end