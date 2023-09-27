defmodule RealtimeToDoListingWeb.TaskLiveTest do
  use RealtimeToDoListingWeb.ConnCase

  alias RealtimeToDoListing.Repo

  import Phoenix.LiveViewTest
  import RealtimeToDoListing.TasksFixtures
  import RealtimeToDoListing.AccountsFixtures

  @create_attrs %{
    completed: true,
    dead_line: "2023-09-25T11:42:00",
    description: "some description",
    priority: :low,
    title: "some title"
  }
  @update_attrs %{
    completed: false,
    dead_line: "2023-09-26T11:42:00",
    description: "some updated description",
    priority: :medium,
    title: "some updated title"
  }
  @invalid_attrs %{completed: false, dead_line: nil, description: nil, priority: nil, title: nil}

  defp create_task(_) do
    task = task_fixture() |> Repo.preload(:user)

    %{task: task}
  end

  describe "Index" do
    setup [:create_task]

    test "user must be logged in", %{conn: conn} do
      {:error,
       {:redirect,
        %{flash: %{"error" => "You must log in to access this page."}, to: "/users/log_in"}}} =
        conn |> live(~p"/tasks")
    end

    test "lists all tasks", %{conn: conn, task: task} do
      {:ok, _index_live, html} = conn |> log_in_user(task.user) |> live(~p"/tasks")

      assert html =~ "Listing Tasks"
      assert html =~ task.description
    end

    test "saves new task", %{conn: conn, task: task} do
      {:ok, index_live, _html} = conn |> log_in_user(task.user) |> live(~p"/tasks")

      assert index_live |> element("a", "New Task") |> render_click() =~
               "New Task"

      assert_patch(index_live, ~p"/tasks/new")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#task-form", task: Map.put(@create_attrs, :user_id, task.user_id))
             |> render_submit()

      assert_patch(index_live, ~p"/tasks")

      html = render(index_live)
      assert html =~ "Task created successfully"
      assert html =~ "some description"
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = conn |> log_in_user(task.user) |> live(~p"/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, ~p"/tasks/#{task}/edit")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      new_user = user_fixture()

      assert index_live
             |> form("#task-form", task: Map.put(@update_attrs, :user_id, new_user.id))
             |> render_submit()

      assert_patch(index_live, ~p"/tasks")

      html = render(index_live)
      assert html =~ "Task updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = conn |> log_in_user(task.user) |> live(~p"/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#tasks-#{task.id}")
    end
  end

  describe "Show" do
    setup [:create_task]

    test "user must be logged in", %{conn: conn, task: task} do
      {:error,
       {:redirect,
        %{flash: %{"error" => "You must log in to access this page."}, to: "/users/log_in"}}} =
        conn |> live(~p"/tasks/#{task}")
    end

    test "displays task", %{conn: conn, task: task} do
      {:ok, _show_live, html} = conn |> log_in_user(task.user) |> live(~p"/tasks/#{task}")

      assert html =~ "Show Task"
      assert html =~ task.description
    end

    test "updates task within modal", %{conn: conn, task: task} do
      {:ok, show_live, _html} = conn |> log_in_user(task.user) |> live(~p"/tasks/#{task}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, ~p"/tasks/#{task}/show/edit")

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      new_user = user_fixture()

      assert show_live
             |> form("#task-form", task: Map.put(@update_attrs, :user_id, new_user.id))
             |> render_submit()

      assert_patch(show_live, ~p"/tasks/#{task}")

      html = render(show_live)
      assert html =~ "Task updated successfully"
      assert html =~ "some updated description"
    end
  end
end
