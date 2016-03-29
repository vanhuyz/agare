defmodule Agare.Api.IdeaController do
  use Agare.Web, :controller

  alias Agare.Idea

  plug :scrub_params, "idea" when action in [:create, :update]

  def index(conn, _params) do
    ideas = Repo.all(Idea)
    render(conn, "index.json", ideas: ideas)
  end

  def create(conn, %{"idea" => idea_params}) do
    changeset = Idea.changeset(%Idea{}, idea_params)

    case Repo.insert(changeset) do
      {:ok, idea} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", idea_path(conn, :show, idea))
        |> render("show.json", idea: idea)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Agare.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)
    render(conn, "show.json", idea: idea)
  end

  def update(conn, %{"id" => id, "idea" => idea_params}) do
    idea = Repo.get!(Idea, id)
    changeset = Idea.changeset(idea, idea_params)

    case Repo.update(changeset) do
      {:ok, idea} ->
        render(conn, "show.json", idea: idea)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Agare.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(idea)

    send_resp(conn, :no_content, "")
  end
end