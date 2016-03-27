defmodule Agare.IdeaTest do
  use Agare.ModelCase

  alias Agare.Idea

  @valid_attrs %{description: "some content", likes_count: 42, title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Idea.changeset(%Idea{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Idea.changeset(%Idea{}, @invalid_attrs)
    refute changeset.valid?
  end
end
