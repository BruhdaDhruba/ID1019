defmodule Env do
    
      def new() do
        []
      end
    
      def add(id, str, []) do [{id, str}] end 
      def add(id, str, [h|t]) do
          z = add(id, str, t)
          [h | z]
      end
    
      def lookup(_id, []) do nil end
      def lookup(id, [{id, str}| _]) do {id, str} end
      def lookup(id, [_ | rest]) do lookup(id, rest) end
    
      def remove([],env) do
        env
      end
      def remove(_,[]) do
        []
      end
      def remove(id, [h|t]) do
        {i, _str} = h
        if(i==id) do
            t
          else
            [h|remove(id,t)]
          end
      end
      def remove([id|ids], env) do
        newEnv = remove(id, env)
        newEnv = remove(ids, newEnv)
      end
      

      def closure(free, env) do
        closure(free, env, new())
      end
      def closure([], _, closure) do {:ok, closure} end
      def closure([v|rest], env, closure) do
        case Env.lookup(v, env) do
            nil -> :error
            {_, s} ->
                closure(rest, env, add(v, s, closure))
        end
      end

      def args([], [], closure) do
        closure
      end
      def args([par | pars], [str | strs], closure) do
        h = {par, str}
        t = args(pars, strs, closure)
        [h|t]
      end
    

      
end