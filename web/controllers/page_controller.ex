defmodule Agare.PageController do
  use Agare.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
