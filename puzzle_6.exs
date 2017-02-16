defmodule AdventOfCode.Puzzle6 do
  def error_correct_part_1(message_data) do
    message_data
    |> convert_to_sequence_of_counts_maps
    |> Enum.map(&highest_count_value/1)
    |> Enum.join
  end

  def error_correct_part_2(message_data) do
    message_data
    |> convert_to_sequence_of_counts_maps
    |> Enum.map(&lowest_count_value/1)
    |> Enum.join
  end

  defp convert_to_sequence_of_counts_maps(message_data) do
    message_data
    |> String.split("\n")
    |> Enum.map(&convert_to_counts_map/1)
    |> Enum.reduce(%{}, fn map_1, map_2 ->
         Map.merge(map_1, map_2, fn _index, counts_1, counts_2 ->
           Map.merge(counts_1, counts_2, fn _char, count_1, count_2 -> count_1 + count_2 end)
         end)
       end)
    |> Enum.sort_by(fn {index, _} -> index end)
    |> Enum.map(fn {_, counts_map} -> counts_map end)
  end

  # abc -> %{0 => %{a => 1}, 1 => %{b => 1}, 2 => %{c => 1}}
  defp convert_to_counts_map(string) do
    string
    |> String.codepoints
    |> Stream.with_index
    |> Map.new(fn {char, index} -> {index, %{char => 1}} end)
  end

  defp highest_count_value(map) do
    map
    |> Enum.max_by(fn {_k, count} -> count end)
    |> elem(0)
  end

  defp lowest_count_value(map) do
    map
    |> Enum.min_by(fn {_k, count} -> count end)
    |> elem(0)
  end

  ExUnit.start

  defmodule Test do
    use ExUnit.Case

    @sample_input """
    eedadn
    drvtee
    eandsr
    raavrd
    atevrs
    tsrnev
    sdttsa
    rasrtv
    nssdts
    ntnada
    svetve
    tesnvt
    vntsnd
    vrdear
    dvrsen
    enarar
    """
    @input File.read!("puzzle_6.input")

    test "step 1" do
      assert AdventOfCode.Puzzle6.error_correct_part_1(@sample_input) == "easter"

      IO.inspect(AdventOfCode.Puzzle6.error_correct_part_1(@input))
    end

    test "step 2" do
      assert AdventOfCode.Puzzle6.error_correct_part_2(@sample_input) == "advent"

      IO.inspect(AdventOfCode.Puzzle6.error_correct_part_2(@input))
    end
  end
end
