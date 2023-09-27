defmodule RealtimeToDoListingWeb.TaskLive.Index do
  use RealtimeToDoListingWeb, :live_view

  alias RealtimeToDoListing.Tasks
  alias RealtimeToDoListing.Tasks.Task
  alias RealtimeToDoListing.Accounts
  alias RealtimeToDoListing.Repo

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      Tasks.subscribe()
    end

    socket =
      socket
      |> assign(:users, Accounts.list_users())
      |> stream(:tasks, Tasks.list_tasks())

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tasks.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({RealtimeToDoListingWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    {:noreply, stream_insert(socket, :tasks, Repo.preload(task, :user))}
  end

  def handle_info({:task_created, task}, socket) do
    {:noreply, stream_insert(socket, :tasks, task, at: 0)}
  end

  def handle_info({:task_updated, task}, socket) do
    {:noreply, stream_insert(socket, :tasks, task)}
  end

  def handle_info({:task_deleted, task}, socket) do
    {:noreply, stream_delete(socket, :tasks, task)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tasks.get_task!(id)
    {:ok, _} = Tasks.delete_task(task)

    {:noreply, stream_delete(socket, :tasks, task)}
  end
end
