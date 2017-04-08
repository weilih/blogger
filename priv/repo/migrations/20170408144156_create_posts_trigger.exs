defmodule Blog.Repo.Migrations.CreatePostsTrigger do
  use Ecto.Migration

  def up do
   execute """
   CREATE OR REPLACE FUNCTION insert_first_comment()
   RETURNS trigger AS $$
   DECLARE
     current_row RECORD;
   BEGIN
     INSERT INTO comments(message, post_id, inserted_at, updated_at)
       VALUES('first', NEW.id, current_timestamp, current_timestamp);
     RETURN current_row;
   END;
   $$ LANGUAGE plpgsql;
   """

   execute """
     CREATE TRIGGER post_first_comment_trg
       AFTER INSERT ON posts FOR EACH ROW
       EXECUTE PROCEDURE insert_first_comment();
   """
  end

  def down do
   execute "DROP TRIGGER IF EXISTS post_first_comment_trg ON posts;"
   execute "DROP FUNCTION insert_first_comment();" 
  end
end
