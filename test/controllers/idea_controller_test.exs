defmodule Agare.IdeaControllerTest do
  use Agare.ConnCase

  alias Agare.Idea
  @valid_attrs %{description: "some content", likes_count: 42, title: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, idea_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    idea = Repo.insert! %Idea{}
    conn = get conn, idea_path(conn, :show, idea)
    assert json_response(conn, 200)["data"] == %{"id" => idea.id,
      "user_id" => idea.user_id,
      "title" => idea.title,
      "description" => idea.description,
      "likes_count" => idea.likes_count}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, idea_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, idea_path(conn, :create), idea: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Idea, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, idea_path(conn, :create), idea: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    idea = Repo.insert! %Idea{}
    conn = put conn, idea_path(conn, :update, idea), idea: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Idea, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    idea = Repo.insert! %Idea{}
    conn = put conn, idea_path(conn, :update, idea), idea: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    idea = Repo.insert! %Idea{}
    conn = delete conn, idea_path(conn, :delete, idea)
    assert response(conn, 204)
    refute Repo.get(Idea, idea.id)
  end
end
