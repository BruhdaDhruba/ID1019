defmodule Dinner do
    def start(), do: spawn(fn -> init() end)
  
    def init() do
      c1 = Chop.start()
      c2 = Chop.start()
      c3 = Chop.start()
      c4 = Chop.start()
      c5 = Chop.start()
      ctrl = self()
      h = 5
      Phil.start(:arendt, c1, c2, h,5, ctrl)
      Phil.start(:hypatia, c2, c3, h,5, ctrl)
      Phil.start(:simone, c3, c4, h,5, ctrl)
      Phil.start(:elisabeth, c4, c5, h,5, ctrl)
      Phil.start(:ayn, c5, c1, h,5, ctrl)
      t1 = :os.system_time(:millisecond)
      wait(5, [c1, c2, c3, c4, c5], t1)
    end
  
    def wait(0, chopsticks, t1) do
      t2 = :os.system_time(:millisecond)
      IO.puts("#{t2-t1} ms")
      Enum.each(chopsticks, fn c -> Chop.quit(c) end)
    end
  
    def wait(n, chopsticks, t1) do
      receive do
        :done ->
          wait(n - 1, chopsticks, t1)
        :abort ->
          Process.exit(self(), :kill)
      end
    end

end
  