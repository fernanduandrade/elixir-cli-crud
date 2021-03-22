defmodule Mix.Tasks.Utils.AddFakeFriends do
  use Mix.Task
  alias Crud.CLI.Register
  alias NimbleCSV.RFC4180, as: CSVParser

  @shortdoc "Add Fake Friends on App"
  def run(_) do
    Faker.start()

    createFriends([], 50)
    |>CSVParser.dump_to_iodata
    |> saveCsvFile
  end

  defp createFriends(list, count) when count <= 1 do
    list ++ [randomList()]
  end

  defp createFriends(list, count) do
    list ++ [randomList()] ++ createFriends(list, count - 1)
  end

  defp randomList do
    %Register{
      name: Faker.Name.PtBr.name(),
      email: Faker.Internet.email(),
      phone: Faker.Phone.EnUs.phone()
    }
    |> Map.from_struct
    |> Map.values

  end

  defp saveCsvFile(data) do
    File.write!("#{File.cwd!}/register.csv", data, [:append])
  end
end
