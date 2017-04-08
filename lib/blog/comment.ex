defmodule Comment do
  use Ecto.Schema

  # @primary_key {:comment_id, :id, autogenerate: true}
  schema "comments" do
    field :message, :string
    belongs_to :post, Post
    timestamps()
  end
end
