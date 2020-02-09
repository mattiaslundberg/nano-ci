defmodule NanoCiWeb.BuildController do
  use NanoCiWeb, :controller
  alias NanoCi.GitRepo
  alias NanoCi.Repo
  alias NanoCi.Build

  def build(conn, %{"repo_id" => repo_id, "revision" => revision}) do
    repo = GitRepo |> Repo.get(repo_id)

    create_build(conn, repo, revision)
  end

  def build(conn, _params) do
    conn
    |> json(%{"status" => "error"})
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

    conn
    |> put_status(:created)
    |> json(%{status: "ok", build_id: build.id})
  end

  defp create_build(conn, _, _) do
    conn
    |> json(%{"status" => "error"})
  end
end
