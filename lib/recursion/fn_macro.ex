defmodule Recursion.FnMacro do
  defmacro defrecursion(exp, do: block) do
    f = elem(exp, 0)
    args = elem(exp, 2)
    quote do
      def unquote(:"do_#{f}")(unquote_splicing(args)) do 
        unquote(block)
      end
      def unquote(f)(unquote_splicing(args)) do
        Recursion.FnServer.gen_function(
          __MODULE__,
          unquote(:"do_#{f}"),
          unquote_splicing(args))
      end
    end
  end 
end
  