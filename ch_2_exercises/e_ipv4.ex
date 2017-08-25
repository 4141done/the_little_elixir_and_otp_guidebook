defmodule EIpv4 do
  def parse(packet) do
    <<
      version :: size(4),
      internet_header_size :: size(4),
      dscp :: size(6), # differentiated services codepoint
      ecn :: size(2), # Explicit congestion notification
      total_length :: size(16),
      identification :: size(16),
      ip_flags :: size(8),
      fragment_offset :: size(13),
      ttl :: size(8),
      protocol :: size(8),
      header_checksum :: size(16),
      source_address :: size(32),
      destination_address :: size(32),
      options :: binary
    >> = packet

      IO.puts
      # The length of an IPV4 packet header is defined by the IHL (Internet Header Length) field
      # which is a value from 0 to 15 in binary.  However, the practical minimum
      # length of the header is IHL 5 because of the size of required fields
      # so the minimum value is 5*32 bits = 160 bits = 20 bytes
      # and the maximum value is 15 * 32 bits = 480 bits = 60 bytes
  end

  def start_listening(port \\ 5678) do
    {:ok, l_sock} = :gen_tcp.listen()
  end
end