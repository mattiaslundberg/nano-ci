defmodule NanoCiWeb.PageController do
  use NanoCiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
