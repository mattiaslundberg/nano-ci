defmodule NanoCiWeb.BuildControllerTest do
  use NanoCiWeb.ConnCase
  alias NanoCi.GitRepo
  alias NanoCi.Repo
  alias NanoCi.Build

  test "Create build without repo_id", %{conn: conn} do
    conn = post(conn, "/api/build")
    assert json_response(conn, 400) == %{}
  end

  test "Create build nonexisting repo", %{conn: conn} do
    conn = post(conn, "/api/build", %{repo_id: 111_111, revision: "asdf"})
    assert json_response(conn, 400) == %{}
  end

  test "Create build", %{conn: conn} do
    repo = %GitRepo{} |> GitRepo.changeset(%{name: "hello"}) |> Repo.insert!()
    conn = post(conn, "/api/build", %{repo_id: repo.id, revision: "asdf"})
    assert %{"build_id" => bid} = json_response(conn, 201)
    assert is_number(bid)
  end

  test "Get build status", %{conn: conn} do
    repo = %GitRepo{} |> GitRepo.changeset(%{name: "first"}) |> Repo.insert!()

    build =
      %Build{}
      |> Build.changeset(%{repo_id: repo.id, revision: "asdf", status: "custom"})
      |> Repo.insert!()

    conn = get(conn, "/api/build/#{build.id}")
    assert json_response(conn, 200) == %{"status" => "custom"}
  end
end
