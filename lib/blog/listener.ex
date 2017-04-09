defmodule Listener do
  use GenServer

  import Poison, only: [decode!: 1]

  def start_link(channel) do
    GenServer.start_link(__MODULE__, channel)
  end

  def init(channel) do
    pg_config = Application.get_env(:blog, Blog.Repo)

    {:ok, pid} = Postgrex.Notifications.start_link(pg_config)
    {:ok, ref} = Postgrex.Notifications.listen(pid, channel)
    {:ok, {pid, channel, ref}}
  end

  def handle_info({:notification, pid, ref, "post_changes", payload}, state) do
    # Posts.Endpoint.broadcast("posts", "change", decode!(payload))
    IO.inspect(decode!(payload))
    {:noreply, state}
  end
end
