defmodule NanoCiWeb.GithubController do
  use NanoCiWeb, :controller
  alias NanoCi.GitRepo
  alias NanoCi.Repo
  alias NanoCi.Build
  alias NanoCi.Builder.Controller

  def create(conn, payload) do
    ref = Map.get(payload, "head")
    repo_url = payload["repository"]["ssh_url"]
    repo = GitRepo |> Repo.get_by(git_url: repo_url)

    create_build(conn, repo, ref)
  end

  defp create_build(conn, repo = %GitRepo{}, revision) do
    build =
      %Build{}
      |> Build.changeset(%{
        repo_id: repo.id,
        revision: revision,
        status: "pending"
      })
      |> Repo.insert!()

    Controller.start_build(repo, build)

    conn
    |> put_status(:created)
    |> json(%{status: "ok", build_id: build.id})
  end

  defp create_build(conn, _, _) do
    conn
    |> put_status(:bad_request)
    |> json(%{})
  end
end
