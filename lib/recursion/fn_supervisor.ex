defmodule Recursion.FnSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_child(value) do
    Supervisor.start_child(__MODULE__, [value])
  end

  def terminate_child(pid) do
    Supervisor.terminate_child(__MODULE__, pid)
  end

  def init(_) do
    children = [
      worker(Recursion.FnServer, [], restart: :temporary)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end
end