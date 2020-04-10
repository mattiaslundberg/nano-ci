defmodule NanoCiWeb.PageControllerTest do
  use NanoCiWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "NanoCI"
  end
end
