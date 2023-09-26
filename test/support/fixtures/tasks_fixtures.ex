defmodule RealtimeToDoListing.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RealtimeToDoListing.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed: true,
        dead_line: ~N[2023-09-25 11:42:00],
        description: "some description",
        priority: :low,
        title: "some title"
      })
      |> RealtimeToDoListing.Tasks.create_task()

    task
  end
end
