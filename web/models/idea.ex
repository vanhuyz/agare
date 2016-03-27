defmodule Agare.Idea do
  use Agare.Web, :model

  schema "ideas" do
    field :title, :string
    field :description, :string
    field :likes_count, :integer
    belongs_to :user, Agare.User

    timestamps
  end

  @required_fields ~w(title description likes_count)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
