defmodule Huffman do

  def decode_table(etable) do
    Enum.reduce(etable, %{}, fn({char, seq}, acc) -> Map.put(acc, seq, char) end)
  end

  def decode(encoded, tree) do decode(encoded, tree, tree) end 
  def decode([], _, _) do [] end 
  def decode([0|rest], {zero, _}, root) do
    decode(rest, zero, root)
  end
  def decode([1|rest], {_, one}, root)do
    decode(rest, one, root)
  end
  def decode(encoded, char, root) do
    [char| decode(encoded, root, root)]
  end
  
  def naive(encoded, dtable) do
    naive(encoded, 1, dtable)
  end
  def naive([], _, _) do [] end
  def naive(encoded, n, dtable) do
    {seq, rest} = Enum.split(encoded, n)
    case Map.get(dtable, seq) do
      nil ->
        naive(encoded, n+1, dtable)
      char ->
        [char | naive(rest, 1, dtable)]
    end
  end

  def encode([], _table) do [] end
  def encode([char|rest], table) do
    case Map.get(table, char) do
      nil ->
        IO.puts("error could not encode #{[char]}", [char])
        encode(rest, table)
      seq -> 
        seq ++ encode(rest, table)
    end
  end
  
  def encode_table(tree) do
    encode_table(tree, [], %{})
  end
  def encode_table({zero, one}, path, table) do
    table = encode_table(zero, [0|path], table)
    encode_table(one, [1|path], table)
  end
  def encode_table(char, path, table) do
    Map.put(table, char, Enum.reverse(path))
  end

  def huffman_tree(freq) do
    sorted = Enum.sort(freq, fn({_, f1}, {_, f2}) -> f1 < f2 end)
    huffman(sorted)
  end

  def huffman([ {tree, _} ]) do tree end 
  def huffman([ {tree1, f1}, {tree2, f2} | rest]) do
    node = { {tree1, tree2}, f1 + f2}
    huffman(insert(node, rest))
  end

  def insert(node, []) do [node] end 
  def insert(node1, [node2 | rest] = nodes) do
    if(elem(node1, 1) <= elem(node2, 1)) do
      [node1 | nodes]
    else
      [node2 | insert(node1, rest)]
    end
  end

  def freq(sample) do freq(sample, %{}) end
  def freq([], freq) do Map.to_list(freq) end
  def freq([char | rest], freq) do
    case Map.get(freq, char) do
      nil ->
        freq(rest, Map.put(freq, char, 1))
      f ->
        freq(rest, Map.put(freq, char, f+1))
    end
  end

end
