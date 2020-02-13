defmodule NanoCiWeb.PageController do
  use NanoCiWeb, :controller
  alias NanoCi.{Repo, Build, GitRepo}
  alias NanoCi.Builder.Controller

  def index(conn, _params) do
    repos = GitRepo |> Repo.all()
    builds = Build |> Repo.all() |> Enum.reverse()

    render(conn, "index.html", %{
      builds: builds,
      repos: repos
    })
  end

  def create(conn, %{"repo_id" => repo_id, "revision" => revision}) do
    repo = GitRepo |> Repo.get(repo_id)

    build =
      %Build{}
      |> Build.changeset(%{
        repo_id: repo.id,
        revision: revision,
        status: "pending"
      })
      |> Repo.insert!()

    Controller.start_build(repo, build)

    redirect(conn, to: "/")
  end

  def show(conn, %{"id" => id}) do
    build = Build |> Repo.get(id)

    render(conn, "show.html", %{
      build: build
    })
  end
end
