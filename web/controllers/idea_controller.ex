defmodule Agare.IdeaController do
  use Agare.Web, :controller

  alias Agare.Idea

  plug :scrub_params, "idea" when action in [:create, :update]

  def index(conn, _params) do
    ideas = Repo.all(Idea)
    render(conn, "index.html", ideas: ideas)
  end

  def new(conn, _params) do
    changeset = Idea.changeset(%Idea{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"idea" => idea_params}) do
    changeset = Idea.changeset(%Idea{}, idea_params)

    case Repo.insert(changeset) do
      {:ok, _idea} ->
        conn
        |> put_flash(:info, "Idea created successfully.")
        |> redirect(to: idea_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)
    render(conn, "show.html", idea: idea)
  end

  def edit(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)
    changeset = Idea.changeset(idea)
    render(conn, "edit.html", idea: idea, changeset: changeset)
  end

  def update(conn, %{"id" => id, "idea" => idea_params}) do
    idea = Repo.get!(Idea, id)
    changeset = Idea.changeset(idea, idea_params)

    case Repo.update(changeset) do
      {:ok, idea} ->
        conn
        |> put_flash(:info, "Idea updated successfully.")
        |> redirect(to: idea_path(conn, :show, idea))
      {:error, changeset} ->
        render(conn, "edit.html", idea: idea, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    idea = Repo.get!(Idea, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(idea)

    conn
    |> put_flash(:info, "Idea deleted successfully.")
    |> redirect(to: idea_path(conn, :index))
  end
end
