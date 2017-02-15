defmodule AdventOfCode.Puzzle4 do
  def sum_real_room_sectors(room_data) do
    room_data
    |> parse_into_rooms
    |> Enum.filter(&checksum_valid?/1)
    |> Enum.map(fn {_, sector_id, _} -> sector_id end)
    |> Enum.sum
  end

  def real_name(encrypted_name, sector_id) do
    encrypted_name
    |> String.codepoints
    |> Enum.map(&rotate_character(&1, sector_id))
    |> Enum.join
  end

  @first_char_offset 97
  defp rotate_character("-", _), do: " "
  defp rotate_character(<<ascii_value>>, sector_id) do
    rotated_value =
      ascii_value
      |> Kernel.-(@first_char_offset)
      |> Kernel.+(sector_id)
      |> Integer.mod(26)
      |> Kernel.+(@first_char_offset)

    <<rotated_value>>
  end

  def parse_into_rooms(room_data) do
    room_data
    |> String.split
    |> Enum.map(&parse_room_string/1)
  end

  @room_pattern ~r/(?<encrypted_room_name>.+)-(?<sector_id>\d+)\[(?<checksum>.{5})\]/

  defp parse_room_string(room_string) do
    %{
      "encrypted_room_name" => encrypted_room_name,
      "sector_id" => sector_id,
      "checksum" => checksum,
    } = Regex.named_captures(@room_pattern, room_string)

    {sector_id, _} = Integer.parse(sector_id)
    {encrypted_room_name, sector_id, checksum}
  end

  defp checksum_valid?({encrypted_room_name, _sector_id, checksum}) do
    calculate_checksum(encrypted_room_name) == checksum
  end

  defp calculate_checksum(encrypted_room_name) do
    encrypted_room_name
    |> String.graphemes
    |> Stream.reject(&(&1 == "-"))
    |> Enum.group_by(&(&1))
    |> Stream.map(fn {char, list} -> {char, Enum.count(list)} end)
    |> Enum.sort_by(fn {char, count} -> {-count, char} end)
    |> Stream.map(fn {char, _} -> char end)
    |> Enum.take(5)
    |> Enum.join
  end

  ExUnit.start

  defmodule Test do
    use ExUnit.Case

    test "step 1" do
      assert AdventOfCode.Puzzle4.sum_real_room_sectors(
        """
        aaaaa-bbb-z-y-x-123[abxyz]
        a-b-c-d-e-f-g-h-987[abcde]
        not-a-real-room-404[oarel]
        totally-real-room-200[decoy]
        """
      ) == 1514

      File.read!("puzzle_4.input")
      |> AdventOfCode.Puzzle4.sum_real_room_sectors
      |> IO.inspect
    end

    test "step 2" do
      assert AdventOfCode.Puzzle4.real_name("qzmt-zixmtkozy-ivhz", 343) == "very encrypted name"

      File.read!("puzzle_4.input")
      |> AdventOfCode.Puzzle4.parse_into_rooms
      |> Enum.map(fn {enc_name, sector_id, _} ->
           name = AdventOfCode.Puzzle4.real_name(enc_name, sector_id)

           {name, sector_id}
         end)
      |> Enum.find(fn {name, _} -> String.contains?(name, "north") end)
      |> IO.inspect
    end
  end
end
