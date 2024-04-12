defmodule Ranges do

  def test() do
    sample() |>
    parse() |>
    location()
  end

  def parse(text) do
    [seeds|maps] = String.split(text, "\n\n")
    [_|seeds] = String.split(seeds, " ")
    seeds = Enum.map(seeds, fn(nr) -> {n,_} = Integer.parse(nr); n end)
    maps = Enum.map(maps, fn(map) ->
      [_|transf] = String.split(map, "\n")
      Enum.map(transf, fn(tr) ->
        [d, s, r] = Enum.map(String.split(tr, " "), fn(nr) -> {n,_} = Integer.parse(nr); n end)
        {:tr, d, s, r}
      end)
    end)
    {seeds, maps}
  end

  def location({seeds, maps}) do
    Enum.map(seeds, fn(seed) ->
      Enum.reduce(maps, seed, fn(map, nr) ->
        Enum.find_value(map, nr, fn({:tr, d, s, r}) ->
          if (s <= nr) and (nr < (s+r)) do
            d + (nr - s)
          else
            nil
          end
        end)
      end)
    end)
  end

  def sample() do
    File.read!("sample.txt")
  end


end
