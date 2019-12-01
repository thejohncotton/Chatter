defmodule Chatter.Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset


  schema "chat_rooms" do
    field :name, :string
    has_many :messages, Chatter.Message
    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  def create(name) do
    Chatter.Chat.Room.changeset(%Chatter.Chat.Room{}, %{name: name})
    |> Chatter.Repo.insert
  end

  def list_all do
    Chatter.Chat.Room
    |> Chatter.Repo.all
  end
  def get_room_by_id!(id) do

  Chatter.Chat.Room
  |> Chatter.Repo.get!(id)
  end
end
