defmodule Blog.Repo.Migrations.CreateTableComments do
  use Ecto.Migration

  def up do
    # create table(:comments, primary_key: false) do
    create table(:comments) do
    #   add :comment_id, :serial, primary_key: true
      add :message, :string, null: false
      add :post_id, references(:posts), delete: :delete_all

      timestamps()
    end
  end

  def down do
    drop_if_exists table(:comments)
    execute "DROP SEQUENCE IF EXISTS even_seq;"
  end
end

