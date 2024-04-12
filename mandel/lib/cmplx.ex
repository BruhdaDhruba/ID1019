defmodule Cmplx do
  
  def new(r, i) do
    {:cpx, r, i}
  end

  def add(a, b) do
    if is_number(b) do
      {:cpx, r, i} = a
      {:cpx, r + b, i}
    else
      {:cpx, r1, i1} = a
      {:cpx, r2, i2} = b
      {:cpx, r1+r2, i1+i2}
    end
  end

  def sqr(a) do
    {:cpx, r, i} = a
    {:cpx, (r*r) + (i*i * -1), (2*r*i)}
  end

  def abs(a) do
    {:cpx, r, i} = a
    :math.sqrt((r*r) + (i*i))
  end
  
end
