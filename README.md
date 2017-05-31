## Recursion
example project to write straight recursive functions with memorization in elixir using OTP and metaprogramming

### it seems to be O(2^n), but it is O(n).

```elixir
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
```

```elixir
iex --erl "+P 5000000" -S mix
Recursion.fib 10000
# => 544383731135652813387342...(very short time)
```

### remark: avoid big number addition
```elixir
# in Recursion.ex
# replace fib(n-1) + fib(n-2)
rem (fib(n-1) + fib(n-2)), 5
```



