defmodule Chop do
  def start do
    stick = spawn_link(fn -> available() end)
  end

  def available() do
    #:io.format("available\n")

    receive do
      {:request, ref, from} ->
        send(from, {:granted, ref})
        gone(ref)

      :quit ->
        :ok
    end
  end

  def gone(ref) do
    #:io.format("gone\n")

    receive do
      {:return, ^ref} ->
        available()

      :quit ->
        :ok
    end
  end

  def request(stick, ref) do
    send(stick, {:request, ref, self()})
  end

  def wait(ref, time) do
    receive do
      {:granted, ^ref} ->
        :ok
    after
      time ->
        :sorry
    end
  end

  def return(stick, ref) do
    send(stick, {:return, ref})
  end

  def quit(stick) do
    :ok
  end


end