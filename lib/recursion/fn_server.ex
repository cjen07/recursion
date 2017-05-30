defmodule Recursion.FnServer do
  use GenServer

  defstruct(
    pids: [],
    bool: false,
    value: nil  
  )

  def init(_) do
    {:ok, %Recursion.FnServer{}}
  end

  def start_link(value) do
    GenServer.start_link(__MODULE__, nil, name:
      {:via, Registry, {Registry.Memory, value}})
  end

  def subscribe(to, from) do
    GenServer.cast(to, {:subscribe, from})
  end

  def publish(to, value) do
    GenServer.cast(to, {:publish, value})
  end

  def gen_function(m, f, value) do
    case Registry.lookup(Registry.Memory, value) do
      [{pid, _}] -> 
        {:archive, pid}
      _ ->
        {:ok, pid} = Recursion.FnSupervisor.start_child(value)
        {:new, pid}
    end
    |> (fn {flag, pid} ->
      subscribe(pid, self())
      if :new == flag do
        publish(pid, apply(m, f, [value]))
      end
      receive do
        data -> data
      end
    end).()
  end

  def handle_cast({:subscribe, from}, state) do
    case state.bool do
      false -> 
        {:noreply, %{state | pids: [from | state.pids]}}
      true ->
        send from, state.value
        {:noreply, state}
    end
  end

  def handle_cast({:publish, value}, state) do
    Enum.map(state.pids, fn pid -> send pid, value end)
    {:noreply, %{state | pids: [], bool: true, value: value}}
  end
end