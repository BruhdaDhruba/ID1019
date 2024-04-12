defmodule Color do
    def convert(depth, max) do 
      f = depth/max
      a = f*4
      x = Kernel.trunc(a)
      y = Kernel.trunc(255*(a-x))
      {:rgb, 0, 0, 255 - y}
    end
  end