defmodule AdventOfCode.Puzzle2 do
  def calculate_code(instructions, keypad, starting_position) do
    instructions
    |> parse_instructions
    |> do_calculate_code(keypad, starting_position)
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

  defp do_calculate_code(instruction_sequences, keypad, starting_position) do
    # This assumes a square keypad.
    keypad_size = tuple_size(keypad)

    {_, keypresses} =
      instruction_sequences
      |> Enum.reduce({starting_position, []}, fn instruction_sequence, {position, keypresses} ->
           new_position = Enum.reduce(instruction_sequence, position, fn instruction, current_position ->
             new_position = apply_instruction(instruction, current_position, keypad_size)
             if keypress(keypad, new_position), do: new_position, else: current_position
           end)

           {new_position, [keypress(keypad, new_position) | keypresses]}
         end)

    keypresses
    |> Enum.reverse
    |> Enum.join("")
  end

  defp apply_instruction(:up, {r, c}, _), do:       {max(r - 1, 0), c}
  defp apply_instruction(:down, {r, c}, size), do:  {min(r + 1, size - 1), c}
  defp apply_instruction(:left, {r, c}, _), do:     {r, max(c - 1, 0)}
  defp apply_instruction(:right, {r, c}, size), do: {r, min(c + 1, size - 1)}

  defp keypress(keypad, {r, c}), do: keypad |> elem(r) |> elem(c)

  ExUnit.start

  defmodule Test do
    use ExUnit.Case

    @instructions File.read!("puzzle_2.input")

    @sample_instructions """
    ULL
    RRDDD
    LURDL
    UUUUD
    """

    test "first half" do
      keypad = {
        {"1", "2", "3"},
        {"4", "5", "6"},
        {"7", "8", "9"},
      }

      starting_position = {1, 1}

      assert AdventOfCode.Puzzle2.calculate_code(@sample_instructions, keypad, starting_position) == "1985"
      assert AdventOfCode.Puzzle2.calculate_code(@instructions, keypad, starting_position) == "74921"
    end

    test "second half" do
      keypad = {
        {nil, nil, "1", nil, nil},
        {nil, "2", "3", "4", nil},
        {"5", "6", "7", "8", "9"},
        {nil, "A", "B", "C", nil},
        {nil, nil, "D", nil, nil},
      }

      starting_position = {2, 0}

      assert AdventOfCode.Puzzle2.calculate_code(@sample_instructions, keypad, starting_position) == "5DB3"
      IO.inspect AdventOfCode.Puzzle2.calculate_code(@instructions, keypad, starting_position), label: "answer"
    end
  end
end
