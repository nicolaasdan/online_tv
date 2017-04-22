defmodule OnlineTv.SessionController do
	use OnlineTv.Web, :controller 

	def new(conn, _) do
		render conn, "new.html"
	end

	def create(conn, %{"session" => %{"username" => user, "password" => pass}}) do
		case OnlineTv.Auth.login_by_username_and_pass(conn, user, pass, repo: Repo) do
			{:ok, conn} ->
			  conn
			  |> put_flash(:info, "welcome back")
			  |> redirect(to: page_path(conn, :index))

			{:error, _reason, conn} ->
				conn
				|> put_flash(:error, "invalid username or password")
				|> render("new.html")
		end
	end

	def delete(conn, _) do
		conn
		|> OnlineTv.Auth.logout()
		|> redirect(to: page_path(conn, :index))
	end
end