defmodule AdventOfCode.Puzzle5 do
  def generate_password_part_1(door_id) do
    index_stream = Stream.iterate(0, &(&1+1))
    Enum.reduce_while(index_stream, "", fn index, password ->
      password =
        case calculate_hash(door_id, index) do
          <<"00000", password_byte :: size(8), _ :: binary>> ->
            char = <<password_byte>>
            IO.puts "found character: #{char}"
            password <> char

          _else ->
            password
        end

      if String.length(password) >= 8 do
        {:halt, password}
      else
        {:cont, password}
      end
    end)
  end


  def generate_password_part_2(door_id) do
    password_chars =
      calculate_password_chars(door_id)
      |> IO.inspect

    Enum.reduce((0..7), "", fn index, str -> str <> Map.fetch!(password_chars, index) end)
  end

  defp calculate_password_chars(door_id) do
    index_stream = Stream.iterate(0, &(&1+1))
    Enum.reduce_while(index_stream, %{}, fn index, chars_so_far ->
      if index == 3231929, do: IO.puts "Made it!"

      chars_so_far =
        case calculate_hash(door_id, index) do
          <<
            "00000",
            position_byte :: size(8),
            password_byte :: size(8),
            _ :: binary
          >> when position_byte >= ?0 and position_byte <= ?7 ->
            char = <<password_byte>>
            position = position_byte - ?0
            Map.put_new_lazy(chars_so_far, position, fn -> IO.inspect(char) end)

          _ -> chars_so_far
        end

      if Enum.count(chars_so_far) == 8 do
        {:halt, chars_so_far}
      else
        {:cont, chars_so_far}
      end
    end)
  end

  defp calculate_hash(door_id, index) do
    :crypto.hash(:md5, "#{door_id}#{index}") |> Base.encode16
  end

  ExUnit.start

  defmodule Test do
    use ExUnit.Case

    @moduletag timeout: 600_000

    @input "ojvtpuvg"

    test "step 1" do
      assert AdventOfCode.Puzzle5.generate_password_part_1("abc") == "18F47A30"

      IO.inspect AdventOfCode.Puzzle5.generate_password_part_1(@input)
    end

    test "step 2" do
      assert AdventOfCode.Puzzle5.generate_password_part_2("abc") == "05ACE8E3"

      IO.inspect AdventOfCode.Puzzle5.generate_password_part_2(@input)
    end
  end
end
