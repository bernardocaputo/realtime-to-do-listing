defmodule RealtimeToDoListing.TasksTest do
  use RealtimeToDoListing.DataCase

  alias RealtimeToDoListing.Tasks

  describe "tasks" do
    alias RealtimeToDoListing.Tasks.Task

    import RealtimeToDoListing.TasksFixtures
    import RealtimeToDoListing.AccountsFixtures

    @invalid_attrs %{completed: nil, dead_line: nil, description: nil, priority: nil, title: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [Repo.preload(task, :user)]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      user = user_fixture()

      valid_attrs = %{
        completed: true,
        user_id: user.id,
        dead_line: ~N[2023-09-25 11:42:00],
        description: "some description",
        priority: :low,
        title: "some title"
      }

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.completed == true
      assert task.dead_line == ~N[2023-09-25 11:42:00]
      assert task.description == "some description"
      assert task.priority == :low
      assert task.title == "some title"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()

      update_attrs = %{
        completed: false,
        dead_line: ~N[2023-09-26 11:42:00],
        description: "some updated description",
        priority: :medium,
        title: "some updated title"
      }

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.completed == false
      assert task.dead_line == ~N[2023-09-26 11:42:00]
      assert task.description == "some updated description"
      assert task.priority == :medium
      assert task.title == "some updated title"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
