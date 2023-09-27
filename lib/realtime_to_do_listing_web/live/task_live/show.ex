defmodule RealtimeToDoListingWeb.TaskLive.Show do
  use RealtimeToDoListingWeb, :live_view

  alias RealtimeToDoListing.Tasks
  alias RealtimeToDoListing.Accounts
  alias RealtimeToDoListing.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, Accounts.list_users())}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:task, Repo.preload(Tasks.get_task!(id), :user))}
  end

  defp page_title(:show), do: "Show Task"
  defp page_title(:edit), do: "Edit Task"
end
