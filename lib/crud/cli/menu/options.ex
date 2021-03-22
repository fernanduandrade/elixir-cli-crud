defmodule Crud.CLI.Menu.Options do
  alias Crud.CLI.Menu

  def all, do: [
    %Menu{label: "Singin a friend", id: :create },
    %Menu{label: "Read a friend", id: :read },
    %Menu{label: "Edit a friend", id: :edit },
    %Menu{label: "Delete a friend", id: :delete },
  ]
end
