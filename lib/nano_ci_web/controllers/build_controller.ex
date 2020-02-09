defmodule NanoCiWeb.BuildController do
  use NanoCiWeb, :controller
  alias NanoCi.GitRepo
  alias NanoCi.Repo
  alias NanoCi.Build

  def create(conn, %{"repo_id" => repo_id, "revision" => revision}) do
    repo = GitRepo |> Repo.get(repo_id)

    create_build(conn, repo, revision)
  end

  def create(conn, _params) do
    conn
    |> put_status(:bad_request)
    |> json(%{})
  end

  def show(conn, %{"id" => build_id}) do
    {id, _} = Integer.parse(build_id)
    build = Build |> Repo.get(id)
    display_build(conn, build)
  end

  def show(conn, _) do
    conn |> put_status(:not_found) |> json(%{})
  end

  def display_build(conn, build = %Build{}) do
    conn
    |> json(%{status: build.status})
  end

  def display_build(conn, _) do
    conn |> put_status(:not_found) |> json(%{})
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
    |> put_status(:bad_request)
    |> json(%{})
  end
end
