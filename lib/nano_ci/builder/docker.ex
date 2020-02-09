defmodule NanoCi.Builder.Docker do
  def start(image, name) do
    System.cmd("docker", [
      "run",
      "-d",
      "-it",
      "--rm",
      "--name",
      name,
      image,
      "/bin/sh"
    ])
    |> parse_out()
  end

  def exec(container_ref, command) do
    System.cmd("docker", ["exec", container_ref, "sh", "-c", command]) |> parse_out()
  end

  defp parse_out({out, code}) do
    if code == 0 do
      {:ok, out}
    else
      {:error, out}
    end
  end
end
