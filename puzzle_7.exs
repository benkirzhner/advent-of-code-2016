defmodule AdventOfCode.Puzzle7 do
  @bracket_pattern ~r/\[.+?\]/
  def supports_tls?(address) do
    {bracket_segments, no_bracket_segments} =
      split_into_segments(address)

    Enum.any?(no_bracket_segments, &abba_present?/1) &&
      !Enum.any?(bracket_segments, &abba_present?/1)
  end

  def supports_ssl?(address) do
    {bracket_segments, no_bracket_segments} =
      split_into_segments(address)

    abas = Enum.flat_map(no_bracket_segments, &find_abas/1) |> MapSet.new
    babs = Enum.flat_map(bracket_segments, &find_babs/1) |> MapSet.new

    MapSet.intersection(abas, babs)
    |> Enum.any?
  end

  defp split_into_segments(address) do
    address
    |> String.split(@bracket_pattern, include_captures: true)
    |> Enum.split_with(&Regex.match?(@bracket_pattern, &1))
  end

  defp abba_present?(segment) do
    segment
    |> slices(4)
    |> Enum.any?(fn
         <<a, b, b, a>> when a != b -> true
         _else -> false
       end)
  end

  defp find_abas(segment) do
    segment
    |> slices(3)
    |> Stream.filter(fn
         <<a, b, a>> when a != b -> true
         _else -> false
       end)
    |> Enum.map(fn <<a, b, a>> -> {a, b} end)
  end

  defp find_babs(segment) do
    segment
    |> slices(3)
    |> Stream.filter(fn
         <<b, a, b>> when a != b -> true
         _else -> false
       end)
    |> Enum.map(fn <<b, a, b>> -> {a, b} end)
  end

  defp slices(segment, n) do
    (0..String.length(segment) - n)
    |> Enum.map(&String.slice(segment, &1, n))
  end

  ExUnit.start

  defmodule Test do
    use ExUnit.Case

    @input File.read!("puzzle_7.input")

    test "step 1" do
      assert AdventOfCode.Puzzle7.supports_tls?("abba[mnop]qrst")
      refute AdventOfCode.Puzzle7.supports_tls?("abcd[bddb]xyyx")
      refute AdventOfCode.Puzzle7.supports_tls?("aaaa[qwer]tyui")
      assert AdventOfCode.Puzzle7.supports_tls?("ioxxoj[asdfgh]zxcvbn")

      @input
      |> String.split("\n")
      |> Enum.count(&AdventOfCode.Puzzle7.supports_tls?/1)
      |> IO.inspect
    end

    test "step 2" do
      assert AdventOfCode.Puzzle7.supports_ssl?("aba[bab]xyz")
      refute AdventOfCode.Puzzle7.supports_ssl?("xyx[xyx]xyx")
      assert AdventOfCode.Puzzle7.supports_ssl?("aaa[kek]eke")
      assert AdventOfCode.Puzzle7.supports_ssl?("zazbz[bzb]cdb")

      @input
      |> String.split("\n")
      |> Enum.count(&AdventOfCode.Puzzle7.supports_ssl?/1)
      |> IO.inspect
    end
  end
end
