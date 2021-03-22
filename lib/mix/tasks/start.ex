defmodule Mix.Tasks.Start do
  use Mix.Task

  @shortdoc "Start [Crud App]"
  def run(_), do: Crud.init()
end
