defmodule SocketAddress do
  @moduledoc """
  Defines an Internet socket address.

  The SocketAddress struct contains the fields `ip` (stored as a tuple) and
  `port`, which can be accessed directly:

      iex> {:ok, socket_address} = SocketAddress.new("127.0.0.1", 80)
      iex> socket_address
      #SocketAddress<127.0.0.1:80>
      iex> socket_address.ip
      {127, 0, 0, 1}
      iex> socket_address.port
      80
  """

  @typedoc "The IP address of a socket"
  @type ip_address :: String.t | char_list | :inet.ip_address

  @typedoc "The port number of a socket"
  @type port_number :: 0..65_535

  @typedoc "The socket address type"
  @type t :: %SocketAddress{ip: :inet.ip_address, port: port_number}

  @enforce_keys [:ip, :port]
  defstruct [:ip, :port]

  @valid_ports 0..65_535

  @doc """
  Creates a new socket address with the given `ip` and `port`.

  Returns `{:ok, socket_address}` if the IP address and port number are valid,
  returns `{:error, reason}` otherwise. A valid IP address is an IPv4 or IPv6
  address that can be parsed by `:inet.parse_address/1`, and a valid port must
  be an integer in the range of `#{inspect @valid_ports}`.

  ## Examples

      iex> {:ok, socket_address} = SocketAddress.new("127.0.0.1", 80)
      iex> socket_address
      #SocketAddress<127.0.0.1:80>
      iex> {:ok, socket_address} = SocketAddress.new('127.0.0.1', 80)
      iex> socket_address
      #SocketAddress<127.0.0.1:80>
      iex> {:ok, socket_address} = SocketAddress.new({127, 0, 0, 1}, 80)
      iex> socket_address
      #SocketAddress<127.0.0.1:80>

      iex> {:ok, socket_address} = SocketAddress.new("fe80::204:acff:fe17:bf38", 80)
      iex> socket_address
      #SocketAddress<[FE80::204:ACFF:FE17:BF38]:80>

      iex> SocketAddress.new("100.200.300.400", 80)
      {:error, :invalid_ip}

      iex> SocketAddress.new("0.0.0.0", 99999)
      {:error, :invalid_port}
  """
  @spec new(ip_address, port_number) ::
    {:ok, t} |
    {:error, :invalid_ip | :invalid_port}
  def new(ip, port) do
    ip_address = parse(ip)

    cond do
      ip_address == nil ->
        {:error, :invalid_ip}
      Enum.member?(@valid_ports, port) == false ->
        {:error, :invalid_port}
      true ->
        {:ok, %SocketAddress{ip: ip_address, port: port}}
    end
  end

  # Parses an `t:ip_address/0` into an `t::inet.ip_address/0` tuple.
  #
  # Returns `nil` if there was an error with parsing.
  @spec parse(ip_address) :: :inet.ip_address | nil
  defp parse(ip_address) when is_binary(ip_address) do
    ip_address |> String.to_char_list |> parse
  end
  defp parse(ip_address) when is_list(ip_address) do
    case :inet.parse_address(ip_address) do
      {:ok, value} -> value
      {:error, :einval} -> nil
    end
  end
  defp parse(ip_address) when is_tuple(ip_address) do
    try do
      :inet.ntoa(ip_address)
    rescue
      ArgumentError -> nil
    else
      {:error, :einval} -> nil
      _ -> ip_address
    end
  end
  defp parse(_), do: nil

  @doc """
  Converts a socket address to an options keyword list.

  Returns a keyword list of the socket address `ip` and `port` fields merged
  with any provided `opts`. All keys, including duplicated keys, given in
  `opts` will be added to the socket address fields, overriding any existing
  one.

  ## Examples

      iex> {:ok, socket_address} = SocketAddress.new("127.0.0.1", 80)
      iex> SocketAddress.to_opts(socket_address)
      [ip: {127, 0, 0, 1}, port: 80]

      iex> {:ok, socket_address} = SocketAddress.new("127.0.0.1", 80)
      iex> SocketAddress.to_opts(socket_address, [compress: true])
      [ip: {127, 0, 0, 1}, port: 80, compress: true]

      iex> {:ok, socket_address} = SocketAddress.new("127.0.0.1", 80)
      iex> SocketAddress.to_opts(socket_address, [port: 8888])
      [ip: {127, 0, 0, 1}, port: 8888]
  """
  @spec to_opts(t, Keyword.t) :: Keyword.t
  def to_opts(%SocketAddress{ip: ip, port: port}, opts \\ []) do
    Keyword.merge([ip: ip, port: port], opts)
  end
end


defimpl Inspect, for: SocketAddress do
  import Inspect.Algebra

  def inspect(socket_address, _opts) do
    surround("#SocketAddress<", "#{socket_address}", ">")
  end
end


defimpl String.Chars, for: SocketAddress do
  def to_string(socket_address) do
    case tuple_size(socket_address.ip) do
      4 -> "#{:inet.ntoa(socket_address.ip)}:#{socket_address.port}"
      8 -> "[#{:inet.ntoa(socket_address.ip)}]:#{socket_address.port}"
    end
  end
end
