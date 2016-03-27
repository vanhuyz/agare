defmodule Agare.IdeaView do
  use Agare.Web, :view

  def render("index.json", %{ideas: ideas}) do
    %{data: render_many(ideas, Agare.IdeaView, "idea.json")}
  end

  def render("show.json", %{idea: idea}) do
    %{data: render_one(idea, Agare.IdeaView, "idea.json")}
  end

  def render("idea.json", %{idea: idea}) do
    %{id: idea.id,
      user_id: idea.user_id,
      title: idea.title,
      description: idea.description,
      likes_count: idea.likes_count}
  end
end
