defmodule Cbclientapi.Alert do

  def alertbytime(cbclientapi, count) do 
    execute(:alertbytime, count, cbclientapi)
  end

  defp execute(type, count, %Cbclientapi{hostname: hostname, port: port, api: apikey}) do
    assemble_url(type, hostname, port, count)
    |> execute_query(apikey)
    |> get_response
    |> decode_json
  end

  defp decode_json({:ok, json}) do
    JSX.decode json
  end

  defp execute_query(url, apikey) do
    :hackney.get(url, [{"X-Auth-Token", apikey}], '', [ssl_options: [ insecure: true]])
  end

  defp get_response({:ok, 200, headers, bodyref}) do
    :hackney.body(bodyref)
  end

## URL Formatting functions:
  defp assemble_url(:alertbytime, hostname, port, count) do
    "https://" <> "#{hostname}:#{Integer.to_string(port)}/api/v1/alert?q=status:Unresolved&sort=created_time%20desc&rows=#{Integer.to_string(count)}"
  end

end
