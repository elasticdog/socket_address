Socket Address
==============

An [Elixir][] convenience library for manipulating Internet socket addresses.

[![Build Status](https://travis-ci.org/elasticdog/socket_address.svg?branch=master)](https://travis-ci.org/elasticdog/socket_address)
[![Coverage Status](https://coveralls.io/repos/github/elasticdog/socket_address/badge.svg?branch=master)](https://coveralls.io/github/elasticdog/socket_address?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/socket_address.svg)](https://hex.pm/packages/socket_address)

[Elixir]: http://elixir-lang.org/

Usage
-----

```elixir
iex> {:ok, socket_address} = SocketAddress.new("127.0.0.1", 80)
iex> socket_address
#SocketAddress<127.0.0.1:80>
iex> socket_address.ip
{127, 0, 0, 1}
iex> socket_address.port
80
iex> SocketAddress.to_opts(socket_address, [compress: true])
[ip: {127, 0, 0, 1}, port: 80, compress: true]

iex> {:ok, socket_address} = SocketAddress.new("fe80::204:acff:fe17:bf38", 80)
iex> socket_address
#SocketAddress<[FE80::204:ACFF:FE17:BF38]:80>
iex> socket_address.ip
{65152, 0, 0, 0, 516, 44287, 65047, 48952}

iex> SocketAddress.new("100.200.300.400", 80)
{:error, :invalid_ip}

iex> SocketAddress.new("0.0.0.0", 99999)
{:error, :invalid_port}
```

### Installation

Releases are published to [Hex](https://hex.pm) and can be installed by adding
`socket_address` to your list of dependencies in `mix.exs`:

```elixir
defp deps do
  [{:socket_address, "~> 0.1"}]
end
```

### Documentation

Generated [ExDoc][] API reference documentation can be found at
<https://hexdocs.pm/socket_address/>

[ExDoc]: https://github.com/elixir-lang/ex_doc

Background
----------

A *socket address* is the combination of an IP address and a port number. This
can be used along with a transport protocol in order to define an endpoint of
a connection across a network.

### The Problem

When using the Erlang HTTP server [Cowboy][], either directly or indirectly via
[Plug][] / [Phoenix][] / etc., if you want to bind the listener to a specific
IP address, you must pass the address in a **tuple format**. For example, if
you want to bind to the localhost address of _127.0.0.1_, you must pass in the
tuple:

    {127, 0, 0, 1}

The required tuple format gets more confusing if you want to bind to an IPv6
address. For instance, the IPv6 address _FE80::204:ACFF:FE17:BF38_ must be
passed in as the tuple:

    {65152, 0, 0, 0, 516, 44287, 65047, 48952}

[Cowboy]: https://github.com/ninenines/cowboy
[Plug]: https://github.com/elixir-lang/plug
[Phoenix]: http://www.phoenixframework.org/

### The Solution

The Socket Address library eases the mental burden of using Cowboy's tuple
format by generating it for you based on normal IP address strings. It sanity
checks both the IP address and port number you give, and then packages it into
a struct for use when setting your listener options.

It's essentially a thin wrapper around the Erlang [`:inet.parse_address/1`][]
function, with some added niceties.

[`:inet.parse_address/1`]: http://erlang.org/doc/man/inet.html#parse_address-1

Contributing
------------

This project welcomes contributions from everyone. If you're thinking of
helping out, please read the [guidelines for contributing][contributing].

[contributing]: https://github.com/elasticdog/socket_address/blob/master/CONTRIBUTING.md

License
-------

Socket Address is provided under the terms of the
[ISC License](https://en.wikipedia.org/wiki/ISC_license).

Copyright &copy; 2016, [Aaron Bull Schaefer](mailto:aaron@elasticdog.com).
