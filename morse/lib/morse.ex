defmodule MorseCode do 

  # The codes that you should decode:
  
  def base, do: '.- .-.. .-.. ..-- -.-- --- ..- .-. ..-- -... .- ... . ..-- .- .-. . ..-- -... . .-.. --- -. --. ..-- - --- ..-- ..- ... '
  
  def rolled, do: '.... - - .--. ... ---... .----- .----- .-- .-- .-- .-.-.- -.-- --- ..- - ..- -... . .-.-.- -.-. --- -- .----- .-- .- - -.-. .... ..--.. ...- .----. -.. .--.-- ..... .---- .-- ....- .-- ----. .--.-- ..... --... --. .--.-- ..... ---.. -.-. .--.-- ..... .---- '
  
  # The decoding tree.
  #
  # The tree has the structure  {:node, char, long, short} | :nil
  # 

  def decode(msg) do
    tree = MorseCode.tree()
    decode(msg, tree, tree)
  end
  #if we're standing at root, and there's no message, we're done.
  def decode([], _, _) do [] end 
  #decode the rest, going down the long, taking the root with us(i.e remembering the root)
  def decode([?- | rest], {:node, _, long, _}, root) do
    decode(rest, long, root) 
  end
  #decode the rest, going down the short, taking the root with us(i.e remembering the root)
  def decode([?. | rest], {:node, _, _, short}, root) do
    decode(rest, short, root) 
  end
  #decode the rest, putting the character in the seq., taking the root with us(i.e remembering the root)
  def decode([?\s | rest], {:node, char, _, _}, root) do
    [char | decode(rest, root, root)] 
  end
  

  def encode(text) do
    tree = MorseCode.tree()
    table = encode_table(tree)
    encode(text, table)
  end
  def encode([], _) do [] end 
  def encode([char | rest], table) do
    code = table[char]
    code ++ [?\s | encode(rest, table)]
  end


  def encode_table(tree) do
    encode_table(tree, [], %{})
  end
  #map is everything we've found so far
  def encode_table(nil, _code, map) do map end 
  def encode_table({:node, :na, long, short}, code, map) do
    map = encode_table(long, [?- | code], map)
    encode_table(short, [?. | code], map)
  end
  def encode_table({:node, char, long, short}, code, map) do
    map = Map.put(map, char, Enum.reverse(code)) #add a character to the map given it's code (code is how we got to the particular character, i.e a sequence of longs and shorts so far)
    map = encode_table(long, [?- | code], map)
    encode_table(short, [?. | code], map)
  end
  
  
  def tree do
    {:node, :na,
      {:node, 116,
        {:node, 109,
          {:node, 111,
            {:node, :na, {:node, 48, nil, nil}, {:node, 57, nil, nil}},
            {:node, :na, nil, {:node, 56, nil, {:node, 58, nil, nil}}}},
          {:node, 103,
            {:node, 113, nil, nil},
            {:node, 122,
              {:node, :na, {:node, 44, nil, nil}, nil},
              {:node, 55, nil, nil}}}},
        {:node, 110,
          {:node, 107, {:node, 121, nil, nil}, {:node, 99, nil, nil}},
          {:node, 100,
            {:node, 120, nil, nil},
            {:node, 98, nil, {:node, 54, {:node, 45, nil, nil}, nil}}}}},
      {:node, 101,
        {:node, 97,
          {:node, 119,
            {:node, 106,
              {:node, 49, {:node, 47, nil, nil}, {:node, 61, nil, nil}},
              nil},
            {:node, 112,
              {:node, :na, {:node, 37, nil, nil}, {:node, 64, nil, nil}},
              nil}},
          {:node, 114,
            {:node, :na, nil, {:node, :na, {:node, 46, nil, nil}, nil}},
            {:node, 108, nil, nil}}},
        {:node, 105,
          {:node, 117,
            {:node, 32,
              {:node, 50, nil, nil},
              {:node, :na, nil, {:node, 63, nil, nil}}},
            {:node, 102, nil, nil}},
          {:node, 115,
            {:node, 118, {:node, 51, nil, nil}, nil},
            {:node, 104, {:node, 52, nil, nil}, {:node, 53, nil, nil}}}}}}
  end
  
end