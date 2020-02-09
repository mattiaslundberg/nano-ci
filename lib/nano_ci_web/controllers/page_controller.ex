defmodule NanoCiWeb.PageController do
  use NanoCiWeb, :controller
  alias NanoCi.{Repo, Build}

  def index(conn, _params) do
    builds = Build |> Repo.all() |> Enum.reverse()

    render(conn, "index.html", %{
      builds: builds
    })
  end
end
