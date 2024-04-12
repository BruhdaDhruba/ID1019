defmodule EnvList do 

  def new() do
    []
  end

  def add([], key, value) do [{key, value}] end 
  def add([h|t], key, value) do
    case lookup([h|t], key) do
      nil ->
      z = add(t, key, value)
      [h | z]
      {_key, _value} ->
        n = remove([h|t], key)
        add(n, key, value)
    end
  end

  def lookup([], _) do nil end
  def lookup([{key, val}| _], key) do {key, val} end
  def lookup([_ | rest], key) do lookup(rest, key) end

  def remove([], _) do [] end
  def remove([{key, _val} | t], key) do t end
  def remove([h|t], key) do
    case lookup([h|t], key) do
      nil -> nil
    {_key, _value} ->
      z = remove(t, key)
      [h | z]
    end
  end


end
