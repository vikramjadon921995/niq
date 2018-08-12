defmodule Niq do

  @base_url "https://some_niq_url"
  @default_headers ["Content-Type": "application/json"]

  defp signin do
    {:ok, signin_config} = Authentication.validate_and_fetch_config()
    params = [
      api_key: signin_config[:apiKey],
      secret: signin_config[:secret]
    ]
    commit(:post, "signin", params)
  end

  defp commit(:post, endpoint, params) do
    url = "#{@base_url}/#{endpoint}"
    url
    |> HTTPoison.post({:form, params}, @default_headers)
    |> respond
  end

  defp respond({:ok, %{status_code: 200, body: body}}) do
    {:ok, Response.success(status_code: 200, raw: body)}
  end

  defp respond({:ok, %{status_code: status_code, body: body}}) do
    {:error, Response.error(status_code: status_code, raw: body)}
  end

  defp respond({:error, %HTTPoison.Error{} = error}) do
    {
      :error,
      Response.error(
        reason: "Network related failure",
        message: "HTTPoison says '#{error.reason}' [ID: #{error.id || "nil"}]"
      )
    }
  end
end
