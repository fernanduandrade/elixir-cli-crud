defmodule Crud.CLI.Main do
  alias Mix.Shell.IO, as: Shell #alias é uma forma de apelido para os comandos

  def startApp do
    Shell.cmd("clear")
    bemVindo()
    Shell.prompt("Pressione ENTER para continuar...")
    startOptions()
  end

  defp bemVindo do
    Shell.info("=========== Friends App ===========")
    Shell.info("============ Bem vindo ============")
    Shell.info("===================================")
  end

  defp startOptions do
    Crud.CLI.Menu.Choices.start
  end
end
