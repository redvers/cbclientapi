require Logger
defmodule Cbclientapi.Alert do

  def facets(cbclientapi) do 
    execute(:facets, cbclientapi)
  end

  def alertbytime(cbclientapi, count, start) do 
    execute(:alertbytime, cbclientapi, count, start)
  end

  def alertbyiocvalue(cbclientapi, ioc_value, count, start) do 
    execute(:alertbyiocvalue, cbclientapi, ioc_value, count, start)
  end


  defp execute(:facets, %Cbclientapi{hostname: hostname, port: port, api: apikey}) do
    assemble_url(:facets, hostname, port)
    |> execute_query(apikey)
    |> get_response
    |> decode_json
  end

  defp execute(type, %Cbclientapi{hostname: hostname, port: port, api: apikey}, count, start) do
    assemble_url(type, hostname, port, count, start)
    |> execute_query(apikey)
    |> get_response
    |> decode_json
  end

  defp execute(:alertbyiocvalue, %Cbclientapi{hostname: hostname, port: port, api: apikey},
               ioc_value, count, start) do
    assemble_url(:alertbyiocvalue, hostname, port, ioc_value, count, start)
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
  defp assemble_url(:alertbytime, hostname, port, count, start) do
    "https://" <> "#{hostname}:#{port}/api/v1/alert?q=status:Unresolved&sort=created_time%20desc&rows=#{count}&start=#{start}"
  end

  defp assemble_url(:facets, hostname, port) do
    "https://" <> "#{hostname}:#{port}/api/v1/alert?q=status:Unresolved&facet=true&rows=0"
  end

  defp assemble_url(:alertbyiocvalue, hostname, port, ioc_value, count, start) do
    "https://" <> "#{hostname}:#{port}/api/v1/alert?q=ioc_value:#{ioc_value}%20AND%20status:Unresolved&rows=#{count}&start=#{start}"
  end

end
