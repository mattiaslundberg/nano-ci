defmodule NanoCiWeb.PageController do
  use NanoCiWeb, :controller
  alias NanoCi.{Repo, Build, GitRepo}

  def index(conn, _params) do
    builds = Build |> Repo.all() |> Enum.reverse()

    render(conn, "index.html", %{
      builds: builds
    })
  end

  def show(conn, %{"id" => id}) do
    build = Build |> Repo.get(id)

    render(conn, "show.html", %{
      build: build
    })
  end
end
