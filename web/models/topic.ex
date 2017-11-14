defmodule Discuss.Topic do
  use Discuss.Web, :model

  schema "topics" do
    field :title, :string
    field :slug, :string

    belongs_to :user, Discuss.User
    has_many :comments, Discuss.Comment
  end

  def changeset(struct, params \\ %{}) do
    params = Map.merge(params, slug_map(params))
    
    struct
    |> cast(params, [:title, :slug])
    |> validate_required ([:title])
  end

  defp slug_map(%{"title" => title}) do
    slug = String.downcase(title) |> String.replace(" ", "-")
    %{"slug" => slug}
  end

  defp slug_map(_params) do
    %{}
  end
end

defimpl Phoenix.Param, for: Discuss.Topic do
  def to_param(%{slug: slug}) do
    "#{slug}"
  end
end
