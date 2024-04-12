defmodule Derivative do

  @type literal() :: {:num, number()} 
  | {:var, atom()}
  
  @type expr() :: {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}
  | {:ln, expr()}
  | {:sin, expr()}
  | {:cos, expr()}
  | literal()

  def test1() do
    b = {:mul, {:num, 1}, {:exp, {:sin, {:mul, {:var, :x}, {:num, 2}}}, {:num, -1}}}
    c = deriv(b, :x)
    d = simplify(c)
    IO.write("expression: #{pprint(b)} \n")
    IO.write("derivative: #{pprint(c)} \n")
    IO.write("simplified: #{pprint(d)} \n")
    d
  end

  def test2() do
    b = {:mul, {:num, 1}, {:exp, {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 5}}, {:num, 0.5}}}
    c = deriv(b, :x)
    d = simplify(c)
    IO.write("expression: #{pprint(b)} \n")
    IO.write("derivative: #{pprint(c)} \n")
    IO.write("simplified: #{pprint(d)} \n")
    d
  end

  def test3() do
    e = {:add, {:mul, {:num, 2}, {:exp, {:var, :x}, {:num, 2}}}, {:add, {:mul, {:num, 4}, {:var, :x}}, {:num, 5}}}
    f = deriv(e, :x)
    g = simplify(f)
    IO.write("expression: #{pprint(e)} \n")
    IO.write("derivative: #{pprint(f)} \n")
    IO.write("simplified: #{pprint(g)} \n")
    g
  end

  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1,v), deriv(e2,v)}
  end
  def deriv({:mul, e1, e2}, v) do
    {:add, 
     {:mul, deriv(e1, v), e2},
      {:mul, e1, deriv(e2, v)}}
  end
  def deriv({:exp, e, {:num, n}}, v) do 
    {:mul,
     deriv(e,v),
      {:mul, {:num, n}, {:exp, e, {:num, (n-1)}}}}
  end
  def deriv({:ln, e}, v) do
    {:mul,
     deriv(e, v), {:exp, e, {:num, -1}}}
  end
  def deriv({:sin, e}, v) do
    {:mul, deriv(e, v), {:cos, e}}
  end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)} + #{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:exp, e1, e2}) do "#{pprint(e1)}^(#{pprint(e2)})" end
  def pprint({:ln, e1}) do "ln(#{pprint(e1)})" end
  def pprint({:sin, e1}) do "sin(#{pprint(e1)})" end
  def pprint({:cos, e1}) do "cos(#{pprint(e1)})" end


  def simplify({:num, n}) do {:num, n} end
  def simplify({:var, v}) do {:var, v} end
  def simplify({:sin, e}) do {:sin, e} end
  def simplify({:cos, e}) do {:cos, e} end
  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul({:num, n1}, {:mul, {:num, n2}, e2}) do 
    {:mul, {:num, n1*n2}, e2} 
  end
  def simplify_mul({:num, n1}, {:mul, e1, {:num, n2}}) do 
    {:mul, {:num, n1*n2}, e1} 
  end
  def simplify_mul({:mul, {:num, n2}, e2}, {:num, n1}) do 
    {:mul, {:num, n1*n2}, e2} 
  end
  def simplify_mul({:mul, e1, {:num, n2}}, {:num, n1}) do 
    {:mul, {:num, n1*n2}, e1} 
  end

  def simplify_mul(e1, e2) do {:mul, e1, e2} end


  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, 0}, _) do {:num, 0} end
  def simplify_exp({:num, 1}, _) do {:num, 1} end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  
  
end
