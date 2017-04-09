defmodule Blog.Repo.Migrations.AddNotifyPostsTrigger do
  use Ecto.Migration

  def up do
    execute """
    CREATE OR REPLACE FUNCTION notify_post()
    RETURNS trigger AS $$
    DECLARE
      current_row RECORD;
    BEGIN
      IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
        current_row := NEW;
      ELSE
        current_row := OLD;
      END IF;
    PERFORM pg_notify(
        'post_changes',
        json_build_object(
          'table', TG_TABLE_NAME,
          'type', TG_OP,
          'id', current_row.id,
          'data', row_to_json(current_row)
        )::text
      );
    RETURN current_row;
    END;
    $$ LANGUAGE plpgsql;
    """
    execute """
    CREATE TRIGGER notify_new_posts_trg
      AFTER INSERT ON posts FOR EACH ROW
      EXECUTE PROCEDURE notify_post();
    """
  end

  # listen post_changes;
  # insert into post(title, content, inserted_at, updated_at) values('hi', 'hi', current_timestamp, current_timestamp)

  def down do
    execute "DROP TRIGGER IF EXISTS notify_new_posts_trg ON posts;"
    execute "DROP FUNCTION notify_post();"
  end
end
