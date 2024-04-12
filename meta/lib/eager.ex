defmodule Eager do

    def eval_expr({:atm, id}, _) do {:ok, id} end
    def eval_expr({:var, id}, env) do
        case Env.lookup(id, env) do
            nil ->
                :error
            {_, str} ->
                {:ok, str}
        end
    end
    def eval_expr({:cons, e1, e2}, env) do
        case eval_expr(e1, env) do
            {:ok, s1} ->
                case eval_expr(e2, env) do
                    {:ok, s2} ->
                        {:ok, {s1,s2}}
                    :error -> :error
                end
            :error -> :error
        end
    end
    def eval_expr({:case, e, clauses}, env) do
        case eval_expr(e, env) do
            {:ok, s} ->
                eval_cls(clauses, s, env)
            :error ->
                :error
        end
    end
    def eval_expr({:lambda, par, free, seq}, env) do
        case Env.closure(free, env) do
            {:ok, closure} ->
                {:ok, {:closure, par, seq, closure}}
            :error ->
                :error
        end
    end
    def eval_expr({:apply, e, args}, env) do
        case eval_expr(e, env) do
            :error ->
                :error
            {:ok, {:closure, par, seq, closure}} ->
                case eval_args(args, env) do
                    :error ->
                        :error
                    {:ok, strs} ->
                       env = Env.args(par, strs, closure)
                       eval_seq(seq, env)
                end
        end
    end
    def eval_expr({:fun, id}, env) do
        {par, seq} = apply(Prgm, id, [])
        {:ok, {:closure, par, seq, Env.new()}}
    end
    
    def eval_args([], _env), do: {:ok, []}
    def eval_args([h | t], env) do
        case eval_expr(h, env) do
            :error -> :error
            {:ok, a} ->
                case eval_args(t, env) do
                    :error -> :error
                    {:ok, b} -> {:ok, [a|b]}
                end
        end
    end



    def eval_cls([], _, _, _) do :error end
    def eval_cls([{:clause, pat, seq}| cls], s, env)do
        removed = eval_scope(pat, env)
        case eval_match(pat, s, removed) do
            :fail -> 
                eval_cls(cls, s, env)
            {:ok, updated} ->
                eval_seq(seq, updated)
        end
    end

    def eval_match(:ignore, _, _) do
        {:ok, []}
    end
    def eval_match({:atm, id}, id, env) do
        {:ok, env}
        
    end
    def eval_match({:var, id}, str, env) do
        case Env.lookup(id, env) do
            nil ->
                {:ok, Env.add(id, str, env)}
            {_, ^str} ->
                {:ok, env}
            {_, _} ->
                :fail
        end
    end
    def eval_match({:cons, hp, tp}, {a, b}, env) do
        case eval_match(hp, a, env) do
            :fail ->
                :fail
            {:ok, env} ->
                eval_match(tp, b, env)
        end
    end
    def eval_match(_, _, _) do
        :fail
    end



    def extract_vars({id, _str}) do [id] end 
    def extract_vars({:cons, e1, e2}) do
        extract_vars(e1)
        extract_vars(e2)
        [e1|e2]
    end
    def extract_vars(_) do [] end

    def eval_scope(pat, env) do
        Env.remove(extract_vars(pat), env)
    end

    def eval_seq([exp], env) do
        eval_expr(exp, env)
    end
    def eval_seq([{:match, a, b} | rest], env) do
        case eval_expr(b, env) do
            :error ->
                :error
            {:ok, pat} ->
                env = eval_scope(a, env)
                
                case eval_match(a, pat, env) do
                    :fail ->
                        :error
                    {:ok, env} ->
                        eval_seq(rest, env)
                end
        end
    end

    def eval(seq) do
        eval_seq(seq, Env.new())
    end





end
