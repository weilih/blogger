defmodule Post do
  use Ecto.Schema

  schema "posts" do
    field :title, :string
    field :content, :string
    has_many :comments, Comment
    timestamps()
  end
end
