defmodule Springs do
  def find_sprs([]) do 0 end
  def find_sprs([h | t]) do
    total = get_springs(h) + find_sprs(t)
    IO.inspect {h, total}
    total
  end
  def find_sprs([], _mul) do
    :no_more_springs
  end
  def find_sprs(list, mul) do
    get_springs(list, mul)
  end
  
  def split_string(whole) do String.split(whole, "\n") end
  
  def get_springs(row) do
    [sprs, nums] = String.split(row)
    sprs = String.graphemes(sprs)
    nums = char_to_int(String.split(nums, ","))
    find(sprs, nums)
  end

  def get_springs(row, mul) do
    [sprs,nums] = String.split(row)
    sprs =  String.graphemes(sprs)
    [_|mulSprs] = ["?"|sprs] |> List.duplicate(mul) |> List.flatten

    nums = String.split(nums,",")
    nums = char_to_int(nums)
    mulNums = nums |> List.duplicate(mul) |> List.flatten

    IO.inspect {mulSprs, mulNums}

    find(mulSprs, mulNums)
  end
  
  def char_to_int(list) do Enum.map(list, &String.to_integer/1) end
  
  def find([], []) do 1 end
  def find([], _nums) do 0 end 
  def find(sprs, []) do if Enum.member?(sprs, "#") do 0 else 1 end end
  def find([spr1 | sprs], num) when spr1 == "." do find(sprs, num) end
  def find([spr1 | sprs], [num1 | nums]) do
    case spr1 do
      "#" -> is_broken(sprs, [num1 - 1 | nums])
      "?" -> is_broken(sprs, [num1 - 1 | nums]) + find(sprs, [num1 | nums])
    end
  end
  
  def is_broken([spr1 | sprs], [num1 | nums]) do
    if spr1 != "." and num1 > 0 do 
      is_broken(sprs, [num1 - 1 | nums])
    else if (spr1 == "#" and num1 == 0) or (spr1 == "." and num1 > 0) do 
      0
    else 
      find(sprs, nums)
    end
  end
  end
  
  def is_broken([], [0]) do 1 end
  def is_broken([], _a) do 0 end
end
