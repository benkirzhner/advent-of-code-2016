defmodule AdventOfCode.Puzzle7 do
  @bracket_pattern ~r/\[.+?\]/
  def supports_tls?(address) do
    {bracket_segments, no_bracket_segments} =
      address
      |> String.split(@bracket_pattern, include_captures: true)
      |> Enum.split_with(&Regex.match?(@bracket_pattern, &1))

    Enum.any?(no_bracket_segments, &abba_present?/1) &&
      !Enum.any?(bracket_segments, &abba_present?/1)
  end

  defp abba_present?(segment) do
    (0..String.length(segment) - 4)
    |> Enum.map(&String.slice(segment, &1, 4))
    |> Enum.any?(fn
         <<a, b, b, a>> when a != b -> true
         _else -> false
       end)
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
  end
end
