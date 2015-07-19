defmodule Cbclientapi.Sensor do

  def search(%Cbclientapi{hostname: hostname, port: port, api: apikey}) do
    assemble_url(:allsensors, hostname, port)
    |> execute_query(apikey)
    |> get_response
    |> decode_json
  end

  def sensor(%Cbclientapi{hostname: hostname, port: port, api: apikey}, sensorid) do
    assemble_url(:sensor, hostname, port, sensorid)
    |> execute_query(apikey)
    |> get_response
    |> decode_json
  end

  defp execute_query(url, apikey) do
    :hackney.get(url, [{"X-Auth-Token", apikey}], '', [ssl_options: [ insecure: true]])
  end

  defp get_response({:ok, 200, _headers, bodyref}) do
    :hackney.body(bodyref)
  end

  defp decode_json({:ok, json}) do
    JSX.decode json
  end





## URL Formatting functions:
  defp assemble_url(:allsensors, hostname, port) do
    "https://" <> hostname <> ":" <> Integer.to_string(port) <> "/api/v1/sensor"
  end
  defp assemble_url(:sensor, hostname, port, sensorid) do
    "https://" <> hostname <> ":" <> Integer.to_string(port) <> "/api/v1/sensor/#{sensorid}" 
  end
end
