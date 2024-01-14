defmodule Example.Approximated do
  @moduledoc """
  A module for interacting with the Approximated.app API.
  """

  @primary_domain Application.compile_env(:example, :primary_domains, ["localhost"])
                  |> List.first("localhost")

  def create_vhost(incoming_address) do
    json = %{
      incoming_address: incoming_address,
      target_address: @primary_domain,
      target_ports: "443"
    }

    Req.post("https://cloud.approximated.app/api/vhosts",
      json: json,
      headers: [api_key: Application.get_env(:example, :apx_api_key)]
    )
  end

  def update_vhost(current_incoming_address, new_incoming_address) do
    json = %{
      current_incoming_address: current_incoming_address,
      incoming_address: new_incoming_address,
      target_address: @primary_domain,
      target_ports: "443"
    }

    Req.post("https://cloud.approximated.app/api/vhosts/update/by/incoming",
      json: json,
      headers: [api_key: Application.get_env(:example, :apx_api_key)]
    )
  end

  def delete_vhost(incoming_address) do
    Req.delete("https://cloud.approximated.app/api/vhosts/by/incoming/#{incoming_address}",
      headers: [api_key: Application.get_env(:example, :apx_api_key)]
    )
  end
end
