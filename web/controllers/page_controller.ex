defmodule Agare.PageController do
  require Logger

  use Agare.Web, :controller

  alias Agare.User

  def index(conn, _params) do
    current_user_id = get_session(conn, :current_user_id)

    if is_nil(current_user_id) do
      conn
      |> assign(:current_user, nil)
      |> render "index.html"
    else
      current_user = Repo.get(User, current_user_id)
      conn
      |> assign(:current_user, current_user)
      |> render "index.html"
    end
  end
end
