defmodule Niq.Application do
  use Application

  def start(_type, _args) do
    AuthTokenEtsSupervisor.start_link(name: AuthTokenEtsSupervisor)
  end
end
