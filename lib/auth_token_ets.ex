defmodule AuthTokenEts do
  use Agent

  @auth_token_table :auth_token_table
  @token :token
  @last_sign_in :last_sign_in

  def start_link(_opts) do
    Agent.start_link(fn -> create_auth_token_table() end, name: :auth_token_ets)
  end

  def token do
    :ets.lookup(@auth_token_table, @token)[@token]
  end

  def last_sign_in do
    :ets.lookup(@auth_token_table, @last_sign_in)[@last_sign_in]
  end

  def save_new_token(token) do
    :ets.insert(@auth_token_table, [{@token, token}, {@last_sign_in, Timex.now}])
  end

  defp create_auth_token_table() do
    IO.puts "In create auth token table!"
    :ets.new(:auth_token_table, [:public, :named_table])
  end
end
