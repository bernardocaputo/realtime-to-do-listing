defmodule RealtimeToDoListing.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  alias RealtimeToDoListing.Accounts.User

  schema "tasks" do
    field :completed, :boolean, default: false
    field :dead_line, :naive_datetime
    field :description, :string
    field :priority, Ecto.Enum, values: [:low, :medium, :high]
    field :title, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :description, :priority, :dead_line, :completed, :user_id])
    |> validate_required([:title, :description, :priority, :dead_line, :completed, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
