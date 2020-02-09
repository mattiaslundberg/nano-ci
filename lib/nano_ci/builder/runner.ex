defmodule NanoCi.Builder.Runner do
  alias NanoCi.Build
  alias NanoCi.GitRepo
  alias NanoCi.Builder.Docker
  alias NanoCi.StatusWriter
  use Task

  def start_link(repo = %GitRepo{}, build = %Build{}) do
    Task.start_link(__MODULE__, :run, [repo, build])
  end

  def run(repo, build) do
    StatusWriter.set_status(build, "running")

    {repo, build}
    |> start_container()
    |> checkout_code()
    |> parse_steps()
    |> run_steps()
    |> summarize_results()
    |> stop_container()
  end

  defp start_container({repo, build}) do
    {:ok, ref} = Docker.start("alpine:latest", "nano-#{build.id}")
    {repo, build, ref |> String.trim()}
  end

  defp checkout_code({repo, build, ref}) do
    {:ok, file} = File.open("/tmp/ssh-key-#{ref}", [:write])
    :ok = IO.binwrite(file, repo.ssh_key)
    :ok = File.close(file)

    {:ok, _} = Docker.exec(ref, "apk add git openssh")
    {:ok, _} = Docker.exec(ref, "mkdir /root/.ssh")

    {:ok, _} =
      Docker.exec(
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
    {status, _output} = Docker.exec(ref, "cat /workdir/.nano.yaml")

    steps =
      if status == :ok do
        # TODO: Parse output
        []
      else
        ["apk add rust cargo", "cd /workdir && cargo test"]
      end

    {build, ref, steps}
  end

  defp run_steps({build, ref, steps}) do
    results = steps |> Enum.map(&run_step(ref, &1))
    {build, ref, results}
  end

  defp run_step(ref, step) do
    Docker.exec(ref, step)
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

  defp stop_container(ref) do
    System.cmd("docker", ["stop", ref])
  end
end
