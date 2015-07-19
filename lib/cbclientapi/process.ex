defmodule Cbclientapi.Process do

  def summary(hostdata, id, segment) do
    execute(:summary, hostdata, id, segment) 
  end

  def events(hostdata, id, segment) do
    execute(:event, hostdata, id, segment) 
  end

  def preview(hostdata, id, segment) do
    execute(:preview, hostdata, id, segment) 
  end

  def search(%Cbclientapi{hostname: hostname, port: port, api: apikey}, {querystring, rows}) do
    assemble_url(:search, hostname, port, querystring, rows)
    |> execute_query(apikey)
    |> get_response
    |> decode_json
  end


## Private Functions
  defp execute(type, %Cbclientapi{hostname: hostname, port: port, api: apikey}, id, segment) do
    assemble_url(type, hostname, port, id, segment)
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
  defp assemble_url(:search, hostname, port, querystring, rows) do
    "https://" <> hostname <> ":" <> Integer.to_string(port) <> "/api/v1/process?q=" <> :hackney_url.urlencode(querystring) <> "&rows=" <> Integer.to_string(rows)
  end
  defp assemble_url(:summary, hostname, port, id, segment) do
    "https://" <> hostname <> ":" <> Integer.to_string(port) <> "/api/v1/process/" <> Integer.to_string(id) <> "/" <> Integer.to_string(segment)
  end
  defp assemble_url(:event, hostname, port, id, segment) do
    "https://" <> hostname <> ":" <> Integer.to_string(port) <> "/api/v1/process/" <> Integer.to_string(id) <> "/" <> Integer.to_string(segment) <> "/event"
  end
  defp assemble_url(:preview, hostname, port, id, segment) do
    "https://" <> hostname <> ":" <> Integer.to_string(port) <> "/api/v1/process/" <> Integer.to_string(id) <> "/" <> Integer.to_string(segment) <> "/preview"
  end
end
