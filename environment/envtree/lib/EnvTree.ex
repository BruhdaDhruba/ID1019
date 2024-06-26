defmodule EnvTree do
  def new() do
    nil
  end

  def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end
  def add({:node, key, _, left, right}, key, value) do 
    {:node, key, value, left, right}
  end
  def add({:node, k, v, left, right}, key, value) when key < k do
    {:node, k, v, add(left, key, value), right}
  end
  def add({:node, k, v, left, right}, key, value) when key > k do
    {:node, k, v, left, add(right, key, value)}
  end

  def lookup(nil, _key) do
    nil
  end
  def lookup({:node, key, value, _, _}, key) do {key, value} end
  def lookup({:node, k, _, left, right}, key) do
    if(k > key) do
      lookup(left, key)
    else
      lookup(right, key)
    end
  end

  def remove(nil, _) do nil end
  def remove({:node, key, _, nil, right}, key) do right end
  def remove({:node, key, _, left, nil}, key) do left end
  def remove({:node, key, _, left, right}, key) do
    {k, v, rest} = leftmost(right)
    {:node, k, v, left, rest}
  end
  def remove({:node, k, v, left, right}, key) when key < k do
    {:node, k, v, remove(left, key), right}
  end
  def remove({:node, k, v, left, right}, key) do
    {:node, k, v, left, remove(right, key)}
  end
  
  def leftmost({:node, k, v, nil, right}) do {k, v, right} end
  def leftmost({:node, k, v, left, right}) do
    {key, val, rest} = leftmost(left)
    {key, val, {:node, k, v, rest, right}}
  end

  def bench(i, n) do
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)

    list = Enum.reduce(seq, EnvTree.new(), fn(e, list) ->
        EnvTree.add(list, e, :foo)
    end)
    
    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)

    {add, _} = :timer.tc(fn() ->
        Enum.each(seq, fn(e) ->
            EnvTree.add(list, e, :foo)
        end)
    end)

    {lookup, _} = :timer.tc(fn() ->
        Enum.each(seq, fn(e) ->
            EnvTree.lookup(list, e)
        end)
    end)

    {remove, _} = :timer.tc(fn() ->
        Enum.each(seq, fn(e) ->
            EnvTree.remove(list, e)
        end)
    end)

    {i, add, lookup, remove}

end

def bench(n) do
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]
    
    :io.format("# benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])
    
    Enum.each(ls, fn (i) ->
        {i, tla, tll, tlr} = bench(i, n)
        :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
    end)
end


end
