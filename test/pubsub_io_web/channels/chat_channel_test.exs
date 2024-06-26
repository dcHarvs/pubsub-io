defmodule PubsubIoWeb.ChatChannelTest do
  use PubsubIoWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      PubsubIoWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(PubsubIoWeb.ChatChannel, "room:lobby")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push(socket, "new_msg", %{"body" => %{"hello" => "there"}})
    assert_reply ref, :ok, %{"body" => %{"hello" => "there"}}
  end
end
