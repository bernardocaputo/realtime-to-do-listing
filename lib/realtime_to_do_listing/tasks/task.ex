defmodule RealtimeToDoListing.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :dead_line, :naive_datetime
    field :description, :string
    field :priority, Ecto.Enum, values: [:low, :medium, :high]
    field :title, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :priority, :dead_line, :completed])
    |> validate_required([:title, :description, :priority, :dead_line, :completed])
  end
end
