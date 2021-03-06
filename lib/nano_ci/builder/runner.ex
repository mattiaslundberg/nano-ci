defmodule NanoCi.Builder.Runner do
  alias NanoCi.Build
  alias NanoCi.GitRepo
  alias NanoCi.Builder.Docker
  alias NanoCi.StatusWriter
  use Task

  def start_link(repo = %GitRepo{}, build = %Build{}) do
    ref = start_container(repo, build)
    {:ok, pid} = Task.start_link(__MODULE__, :run, [ref, repo, build])
    {:ok, pid, ref}
  end

  def get_status(ref, status_writer) when not is_nil(ref) do
    Docker.get_status(ref, status_writer)
  end

  def run(ref, repo, build) do
    StatusWriter.set_status(build, "running")

    {repo, build, ref}
    |> checkout_code()
    |> parse_steps()
    |> run_steps()
    |> summarize_results()
    |> Docker.stop()
  end

  defp start_container(_repo, build) do
    {:ok, ref} = Docker.start("alpine:latest", "nano-#{build.id}")
    ref |> String.trim()
  end

  defp checkout_code({repo, build, ref}) do
    {:ok, file} = File.open("/tmp/ssh-key-#{ref}", [:write])
    :ok = IO.binwrite(file, repo.ssh_key)
    :ok = File.close(file)

    {:ok, _} = Docker.exec(ref, "apk add git openssh")
    {:ok, _} = Docker.exec(ref, "mkdir /root/.ssh")

    {:ok, _} =
      Docker.exec_no_log(
        ref,
        "ssh-keyscan github.com >> /root/.ssh/known_hosts"
      )

    {_, 0} =
      System.cmd("docker", [
        "cp",
        "/tmp/ssh-key-#{ref}",
        "nano-#{build.id}:/root/.ssh/id_rsa"
      ])

    {:ok, _} =
      Docker.exec(
        ref,
        "git clone #{repo.git_url} /workdir"
      )

    {build, ref}
  end

  defp parse_steps({build, ref}) do
    {status, output} = Docker.exec_no_log(ref, "cat /workdir/.nano.yaml")

    steps =
      if status == :ok do
        {:ok, yaml} = YamlElixir.read_from_string(output)
        Map.get(yaml, "steps", [])
      else
        []
      end

    {build, ref, steps}
  end

  defp run_steps({build, ref, steps}) do
    results = steps |> Enum.map(&Docker.exec(ref, &1))
    {build, ref, results}
  end

  defp summarize_results({build, ref, results}) do
    result = Enum.all?(results, fn {s, _} -> s == :ok end)

    if result do
      StatusWriter.set_status(build, "success")
    else
      StatusWriter.set_status(build, "failed")
    end

    IO.puts("RESULT: #{result}")
    ref
  end
end
