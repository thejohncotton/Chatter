defmodule Chatter.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :name, :string
      add :message, :string
      add :chat_room_id, references(:chat_rooms)
      timestamps()
    end

  end
end
