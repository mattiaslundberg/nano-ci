defmodule NanoCiWeb.BuildControllerTest do
  use NanoCiWeb.ConnCase
  alias NanoCi.GitRepo
  alias NanoCi.Repo

  test "Create build without repo_id", %{conn: conn} do
    conn = post(conn, "/api/build")
    assert json_response(conn, 200) == %{"status" => "error"}
  end

  test "Create build", %{conn: conn} do
    repo = %GitRepo{} |> GitRepo.changeset(%{name: "hello"}) |> Repo.insert!()
    conn = post(conn, "/api/build", %{repo_id: repo.id, revision: "asdf"})
    assert %{"status" => "ok", "build_id" => bid} = json_response(conn, 201)
    assert is_number(bid)
  end
end
