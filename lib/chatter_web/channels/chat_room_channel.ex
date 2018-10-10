defmodule ChatterWeb.ChatRoomChannel do
  use ChatterWeb, :channel

  def join("chat_room:lobby", payload, socket) do
    if authorized?(payload) do
      send(self(), :after_join)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
  ## Add some nicer formatting to messages
  defp format_msg(msg) do
    %{
      name: msg.name,
      message: msg.message
    }
  end
  

# handle info after joining channel
  def handle_info(:after_join, socket) do
    Chatter.Message.recent_messages()
    |> Enum.each(fn msg -> push(socket, "new_message", format_msg(msg)) end)
    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (chat_room:lobby).
  ## syncronous code
  # def handle_in("new_message", payload, socket) do
  #   Chatter.Message.changeset(%Chatter.Message{}, payload) |> Chatter.Repo.insert # handle syncronously 
  #   broadcast socket, "new_message", payload
  #   {:noreply, socket}
  # end

  # async code
  def handle_in("new_message", payload, socket) do
    spawn(fn -> save_message(payload) end)
    broadcast! socket, "new_message", payload
    {:noreply, socket}
  end


  
  def save_message(message) do
    Chatter.Message.changeset(%Chatter.Message{}, message)
      |> Chatter.Repo.insert
  end
  

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
