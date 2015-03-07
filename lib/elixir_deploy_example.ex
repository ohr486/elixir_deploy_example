defmodule ElixirDeployExample do
end

defmodule ElixirDeployExample.API do
  use Maru.Router
  plug Plug.Logger

  get do
    "ByeBye, Elixir Deployment Example!" |> text
  end
  
  def error(conn, err) do
    "ERROR: #{inspect err}" |> text(500)
  end
end
