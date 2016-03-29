defmodule Agare.Api.IdeaView do
  use Agare.Web, :view

  def render("index.json", %{ideas: ideas}) do
    render_many(ideas, Agare.Api.IdeaView, "idea.json")
  end

  def render("show.json", %{idea: idea}) do
    render_one(idea, Agare.Api.IdeaView, "idea.json")
  end

  def render("idea.json", %{idea: idea}) do
    %{id: idea.id,
      user: "idea.user.name",
      title: idea.title,
      description: idea.description,
      likes_count: idea.likes_count}
  end
end
