defmodule RealtimeToDoListing.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RealtimeToDoListing.Tasks` context.
  """
  alias RealtimeToDoListing.AccountsFixtures

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture()

    {:ok, task} =
      Enum.into(attrs, %{
        completed: true,
        dead_line: ~N[2023-09-25 11:42:00],
        description: "some description",
        priority: :low,
        title: "some title",
        user_id: user.id
      })
      |> RealtimeToDoListing.Tasks.create_task()

    task
  end
end
