defmodule Chatter.Message do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset
  


  schema "messages" do
    field :message, :string
    field :name, :string
    belongs_to :chat_room, Chatter.Chat.Room
    timestamps()
  end

  def recent_messages(limit \\ 10) do
    Chatter.Repo.all(Chatter.Message, limit: limit)
  end

  def recent_messages_by_room(room_id) do
    # %Chatter.Message{}
    # |> where([m], m.chat_room_id = room_id)
   
    from(m in Chatter.Message, where: m.chat_room_id == ^room_id)
    |> Chatter.Repo.all

    # Chatter.Repo.get_by!(Chatter.Message, chat_room_id: room_id)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message])
    |> validate_required([:name, :message])
  end
  def update_message(%Chatter.Message{} = message, attrs) do
    message
    |> Chatter.Message.changeset(attrs)
    |> Chatter.Repo.update()
  end

  def get_message!(id) do
     Chatter.Repo.get!(Chatter.Message, id)
  end

end
