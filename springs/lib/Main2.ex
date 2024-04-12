defmodule Main do
  def main do
    test =
"???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1"
    total = Springs.detect_springs(String.split(test,"\n"))
    IO.inspect(total: total)
  end

  def test2 do
    test = "???.### 1,1,3"
    total = Springs.detect_springs(test, 5)
    IO.inspect(total: total)
  end

  def test3 do
    test = "???.### 1,1,3"
    total = Dynamic.detect_springs(test, 5)
    IO.inspect(total: total)
  end


end
