defmodule PPM do

    def demo() do
        small(-2.6, 1.2, 1.2)
    end
    
    def small(x0, y0, xn) do
        width = 400
        height = 180
        depth = 64
        k = (xn - x0) / width
        image = Mandel.mandelbrot(width, height, x0, y0, k, depth)
        PPM.write("small.ppm", image)
    end

    # write(name, image) The image is a list of rows, each row a list of
    # tuples {R,G,B}. The RGB values are 0-255.
  
    def write(name, image) do
      height = length(image)
      width = length(List.first(image))
      {:ok, fd} = File.open(name, [:write])
      IO.puts(fd, "P6")
      IO.puts(fd, "#generated by ppm.ex")
      IO.puts(fd, "#{width} #{height}")
      IO.puts(fd, "255")
      rows(image, fd)
      File.close(fd)
    end
  
    defp rows(rows, fd) do
      Enum.each(rows, fn(r) ->
        colors = row(r)
        IO.write(fd, colors)
      end)
    end
  
    defp row(row) do
      List.foldr(row, [], fn({:rgb, r, g, b}, a) ->
        [r, g, b | a]
      end)
    end
  
  end