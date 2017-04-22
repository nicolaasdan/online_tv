defmodule OnlineTv.UserView do
	use OnlineTv.Web, :view 
	alias OnlineTv.User 

	def first_name(%User{name: name}) do
		name
		|> String.split(" ")
		|> Enum.at(0)
	end
end