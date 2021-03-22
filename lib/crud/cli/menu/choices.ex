defmodule Crud.CLI.Menu.Choices do
  alias Mix.Shell.IO, as: Shell
  alias Crud.CLI.Menu.Options
  alias Crud.Db.Csv
  def start do
    Shell.cmd("clear")
    Shell.info("Escolha uma opção: ")

    options = Options.all()
    findMenuItemByIndex = &Enum.at(options, &1, :error)

    options
    |> Enum.map(&(&1.label))
    |> showOptions
    |> generateQuestion()
    |> Shell.prompt
    |> parseAnswer()
    |> findMenuItemByIndex.()
    |> confirmMenuItem()
    |> confirmMessage()
    |> Csv.perform()
  end

  defp showOptions(options) do
    options
    |> Enum.with_index(1)
    |> Enum.each(fn {option, index} ->
      Shell.info("#{index} - #{option}")
    end)

    options
  end

  defp generateQuestion(options) do
    options = Enum.join(1..Enum.count(options), ",")
    "Qual das opções acima você escolhe? [#{options}]\n"
  end

  defp parseAnswer(answer) do
    case Integer.parse(answer) do
      :error -> invalidOption()
      {option, _} -> option - 1
    end
  end

  defp invalidOption do
       Shell.cmd("clear")
       Shell.error("Inválida")
       Shell.prompt("pressione enteder novamente")
       start()
  end

  defp confirmMenuItem(menuOption) do
    case menuOption do
      :error -> invalidOption()
      _ -> menuOption
    end
  end

  defp confirmMessage(menuOption) do
    Shell.cmd("clear")
    Shell.info("Você escolheu...[#{menuOption.label}]")

    if Shell.yes?("Confirma") do
      menuOption
    else
    start()
  end
end
end
