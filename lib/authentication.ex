defmodule Authentication do
  @auth_token_valid_time 30 # In days
  @required_config [:apiKey, :secret]

  def validate_config_and_fetch_auth_token do
    validate_and_fetch_config()
    token = fetch_auth_token()
    {:ok, token}
  end

  def validate_and_fetch_config do
    signin_config = Application.get_env(:niq, :signin_config)
    missing_keys = Enum.reduce(@required_config, [], fn key, missing_keys ->
      if signin_config[key] in [nil, ""], do: [key | missing_keys], else: missing_keys
    end)

    raise_on_missing_config(missing_keys, signin_config)
  end

  defp fetch_auth_token do
    token = AuthTokenEts.token
    fetch_token_after_sign_in(token)
  end

  defp fetch_token_after_sign_in(nil), do: nil

  defp fetch_token_after_sign_in(token) do
    last_sign_in = AuthTokenEts.last_sign_in
    case last_sign_in do
      nil -> nil
      _ ->
        sign_in_required = last_sign_in > Timex.shift(Timex.now, days: -@auth_token_valid_time)
        if sign_in_required, do: nil, else: token
    end
  end

  defp raise_on_missing_config([], signin_config), do: {:ok, signin_config}

  defp raise_on_missing_config(keys, signin_config) do
    raise ArgumentError, """
    expected #{inspect(keys)} to be set, got: #{inspect(signin_config)}
    """
  end
end
