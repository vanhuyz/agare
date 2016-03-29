defmodule Agare.IdeaControllerTest do
  use Agare.ConnCase

  alias Agare.Idea
  @valid_attrs %{description: "some content", likes_count: 42, title: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, idea_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing ideas"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, idea_path(conn, :new)
    assert html_response(conn, 200) =~ "New idea"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, idea_path(conn, :create), idea: @valid_attrs
    assert redirected_to(conn) == idea_path(conn, :index)
    assert Repo.get_by(Idea, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, idea_path(conn, :create), idea: @invalid_attrs
    assert html_response(conn, 200) =~ "New idea"
  end

  test "shows chosen resource", %{conn: conn} do
    idea = Repo.insert! %Idea{}
    conn = get conn, idea_path(conn, :show, idea)
    assert html_response(conn, 200) =~ "Show idea"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, idea_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    idea = Repo.insert! %Idea{}
    conn = get conn, idea_path(conn, :edit, idea)
    assert html_response(conn, 200) =~ "Edit idea"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    idea = Repo.insert! %Idea{}
    conn = put conn, idea_path(conn, :update, idea), idea: @valid_attrs
    assert redirected_to(conn) == idea_path(conn, :show, idea)
    assert Repo.get_by(Idea, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    idea = Repo.insert! %Idea{}
    conn = put conn, idea_path(conn, :update, idea), idea: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit idea"
  end

  test "deletes chosen resource", %{conn: conn} do
    idea = Repo.insert! %Idea{}
    conn = delete conn, idea_path(conn, :delete, idea)
    assert redirected_to(conn) == idea_path(conn, :index)
    refute Repo.get(Idea, idea.id)
  end
end
