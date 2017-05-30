defmodule Recursion do
  import Recursion.FnMacro
  defrecursion fib(n) do
    cond do
      n < 2 ->
        1
      true ->
        fib(n-1) + fib(n-2)
    end
  end
end