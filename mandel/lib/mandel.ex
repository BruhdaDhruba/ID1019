defmodule Mandel do

    def mandelbrot(width, height, x, y, k, depth) do
        trans = fn(w, h) ->
            Cmplx.new(x + k * (w - 1), y - k * (h - 1))
        end

        rows(width, height, trans, depth, [])
    end

    def rows(_, 0, _, _, rows) do rows end
    def rows(w, h, tr, depth, rows) do
        row = row(w, h, tr, depth, [])
        rows(w, h - 1, tr, depth, [row | rows])
    end

    def row(0, _, _, _, row) do row end
    def row(w, h, tr, depth, row) do 
        c = tr.(w, h)
        res = Brot.mandelbrot(c, depth)
        color = Color.convert(res, depth)
        row(w - 1, h, tr, depth, [color | row])
    end

end