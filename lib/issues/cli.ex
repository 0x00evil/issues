defmodule Issues.CLI do
  @default_count 4
  @moduledoc """
  Handle the command line parsing and dispatch to the various
  functions that end up generating a table of the last _n_ issues
  in a github project.
  """

  def run(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github name, project name, and (optionaly)
  the number of entries to format.
  Return a tuple of `{user, project, count}`, or `:help` if help was given.
  """

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    case parse do
      {[help: true], _, _} -> :help
      {_, [user, project, count], _} -> {user, project, count}
      {_, [user, project], _} -> {user, project, @default_count}
      _ -> :help
    end
  end

  def process(:help) do
  IO.puts """
  usage: issues <user> <project> [count | #{@default_count}]
  """
  end

  def process({user, project, _count}) do
    Issues.GithubIssues.fetch(user, project)
  end
end
