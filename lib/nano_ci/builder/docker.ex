defmodule NanoCi.Builder.Docker do
  def start(image, name) do
    System.cmd("docker", [
      "run",
      "-dti",
      "--rm",
      "--name",
      name,
      image,
      "/bin/sh"
    ])
    |> parse_out()
  end

  def stop(container_ref) do
    System.cmd("docker", ["stop", container_ref])
  end

  def exec(container_ref, command) do
    exec_no_log(container_ref, "#{command} >> nano.log 2>&1")
  end

  def get_status(container_ref, target) do
    System.cmd("docker", ["logs", container_ref, "--follow"], into: target)
  end

  def exec_no_log(container_ref, command) do
    System.cmd("docker", ["exec", container_ref, "sh", "-c", command])
    |> parse_out()
  end

  defp parse_out({out, code}) do
    if code == 0 do
      {:ok, out}
    else
      {:error, out}
    end
  end
end
