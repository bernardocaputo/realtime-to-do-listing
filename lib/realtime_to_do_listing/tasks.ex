defmodule RealtimeToDoListing.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias RealtimeToDoListing.Repo

  alias RealtimeToDoListing.Tasks.Task

  @doc """
  Subscribes to a topic
  """
  def subscribe do
    Phoenix.PubSub.subscribe(RealtimeToDoListing.PubSub, "tasks")
  end

  @doc """
  Broadcasts message
  """
  def broadcast(message) do
    Phoenix.PubSub.broadcast(RealtimeToDoListing.PubSub, "tasks", message)
  end

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Task
    |> preload(:user)
    |> Repo.all()
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    with {:ok, task} <-
           %Task{}
           |> Task.changeset(attrs)
           |> Repo.insert() do
      broadcast({:task_created, Repo.preload(task, :user)})
      {:ok, task}
    end
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    with {:ok, task} <-
           task
           |> Task.changeset(attrs)
           |> Repo.update() do
      broadcast({:task_updated, Repo.preload(task, :user)})
      {:ok, task}
    end
  end

  @doc """
  Deletes a task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    with {:ok, deleted_task} <- Repo.delete(task) do
      broadcast({:task_deleted, deleted_task})
      {:ok, deleted_task}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{data: %Task{}}

  """
  def change_task(%Task{} = task, attrs \\ %{}) do
    Task.changeset(task, attrs)
  end
end
