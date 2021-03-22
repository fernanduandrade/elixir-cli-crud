defmodule Crud.Db.Csv do
  alias Mix.Shell.IO, as: Shell
  alias Crud.CLI.Menu
  alias Crud.CLI.Register
  alias NimbleCSV.RFC4180, as: CSVParser

  def perform(chosenMenuItem) do
    case chosenMenuItem do
      %Menu{id: :create, label: _ } -> create()
      %Menu{id: :read, label: _ } -> read()
      %Menu{id: :edit, label: _ } -> edit()
      %Menu{id: :delete, label: _ } -> delete()
    end
    Crud.CLI.Menu.Choices.start()
  end

  defp edit do
    promptMessage("Digite o email do contato para ser atualizado")
    |> searchByEmail()
    |> checkContact()
    |> confirmUpdate()
    |> doUpdate()
  end

  defp confirmUpdate(id) do
    Shell.cmd("clear")
    Shell.info("??? algo aqui ???")

    showContact(id)

    case Shell.yes?("Quer atualizar?") do
      true -> id
      false -> :error
    end
  end

  defp doUpdate(id) do
    Shell.cmd("clear")
    Shell.info("atualize os dados")

    updatedContact = collectData()
    get_struct_list_from_csv()
    |> deleteContactFromStruct(id)
    |> idListToCsv()
    |> prepareListToSaveCsv()
    |> saveCsvFile()

    updatedContact
    |> transformOnWrapList()
    |> prepareListToSaveCsv()
    |> saveCsvFile([:append])

    Shell.info("Amigo atualizado com sucesso!")
    Shell.prompt("Pressione Enteder")
  end

  defp delete do
    promptMessage("Digite o email do contato para ser excluido")
    |> searchByEmail()
    |> checkContact()
    |> confirmDelete()
    |> deleteAndSave()
  end

  defp searchByEmail(email) do
    get_struct_list_from_csv()
    |> Enum.find(:not_found, fn list ->
      list.email == email
   end)
  end

  defp checkContact(id) do
    case id do
      :not_found ->
        Shell.cmd("clear")
        Shell.error("Contato não encontrado.... ")
        Shell.prompt("Pressione algo")
        Crud.CLI.Menu.Choices.start()

      _ -> id
    end
  end

  defp confirmDelete(id) do
    Shell.cmd("clear")
    Shell.info("Encontrado")

    showContact(id)

    case Shell.yes?("Deseja deletar?") do
      true -> id
      false -> :error
    end
  end

  defp showContact(id) do
    id
    |> Scribe.print(data: [{"Name", :name}, {"Email", :email}, {"Phone", :phone}])
  end

  defp deleteAndSave(id) do
    case id do
      :error ->
        Shell.info("Ok, its safe")
        Shell.prompt("Hita enter")
      _ ->
        get_struct_list_from_csv()
        |> deleteContactFromStruct(id)
        |> idListToCsv()
        |> prepareListToSaveCsv()
        |> saveCsvFile()

        Shell.info("Excluido")
        Shell.prompt("press enter")
      end
  end

  defp deleteContactFromStruct(list, id) do
    list
    |> Enum.reject(fn elem -> elem.email == id.email end)
  end

  defp idListToCsv(list) do
    list
    |> Enum.map(fn item ->
      [item.email, item.name, item.phone]
    end)
  end
  defp read do
    get_struct_list_from_csv()
    |> showContacts()
  end

  defp get_struct_list_from_csv do
    readCsvFile()
    |> parseCsvFileToList()
    |> csvList()
  end

  defp csvList(list) do
    list
    |> Enum.map( fn [email, name, phone] ->
      %{name: name, email: email, phone: phone}
    end)
  end

  defp parseCsvFileToList(csv_file) do
    csv_file
    |> CSVParser.parse_string(skip_headers: false)
  end

  defp readCsvFile() do
    File.read!("#{File.cwd!}/register.csv")
  end

  defp showContacts(list) do
    list
    |> Scribe.console(data: [{"Name", :name}, {"Email", :email}, {"Phone", :phone}])
  end

  defp create do
    collectData()
    |> transformOnWrapList()
    |> prepareListToSaveCsv()
    |> saveCsvFile([:append])
  end

  defp collectData do
    Shell.cmd("clear")

    %Register{
      name: promptMessage("Dgite o nome: "),
      email: promptMessage("Dgite o email: "),
      phone: promptMessage("Dgite o telefone: ")
    }
  end

  defp promptMessage(message) do
    Shell.prompt(message)
    |> String.trim
  end

  defp transformOnWrapList(list) do
    list
    |> Map.from_struct
    |> Map.values
    |> wrapInList()
  end

  defp prepareListToSaveCsv(data) do
    data
    |> CSVParser.dump_to_iodata
  end

  defp wrapInList(list) do
    [list]
  end

  defp saveCsvFile(data, mode \\ []) do
    File.write!("#{File.cwd!}/register.csv", data, mode)
  end
end
