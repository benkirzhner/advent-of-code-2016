defmodule AdventOfCode.Puzzle2 do

  ExUnit.start

  @keypad {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9},
  }

  @starting_position {1, 1}

  def calculate_code(instructions) do
    instructions
    |> parse_instructions
    |> do_calculate_code
  end

  defp parse_instructions(instructions_string) do
    instructions_string
    |> String.split("\n")
    |> Enum.map(fn line ->
         line
         |> String.codepoints
         |> Enum.map(&instruction_for_char/1)
       end)
    |> Enum.reject(&Enum.empty?/1)
  end

  defp instruction_for_char("U"), do: :up
  defp instruction_for_char("D"), do: :down
  defp instruction_for_char("L"), do: :left
  defp instruction_for_char("R"), do: :right

  defp do_calculate_code(instruction_sequences) do
    {_, keypresses} =
      instruction_sequences
      |> Enum.reduce({@starting_position, []}, fn instruction_sequence, {position, keypresses} ->
           new_position = Enum.reduce(instruction_sequence, position, &apply_instruction/2)

           {new_position, [keypress(new_position) | keypresses]}
         end)

    keypresses
    |> Enum.reverse
    |> Enum.join("")
  end

  defp apply_instruction(:up, {x, y}), do:    {max(x - 1, 0), y}
  defp apply_instruction(:down, {x, y}), do:  {min(x + 1, 2), y}
  defp apply_instruction(:left, {x, y}), do:  {x, max(y - 1, 0)}
  defp apply_instruction(:right, {x, y}), do: {x, min(y + 1, 2)}

  defp keypress({x, y}), do: @keypad |> elem(x) |> elem(y)

  defmodule Test do
    use ExUnit.Case

    @instructions File.read!("puzzle_2.input")

    test "first half sample" do
      sample_instructions = """
      ULL
      RRDDD
      LURDL
      UUUUD
      """
      assert AdventOfCode.Puzzle2.calculate_code(sample_instructions) == "1985"
    end

    test "first half" do
      IO.inspect AdventOfCode.Puzzle2.calculate_code(@instructions)
      assert false
    end
  end
end
