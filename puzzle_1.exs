defmodule AdventOfCode.Puzzle1 do
  def calculate_distance(directions) do
    directions
    |> parse_directions
    |> do_calculate_distance
  end

  def find_first_duplicate_location(directions) do
    directions
    |> parse_directions
    |> do_find_first_duplicate_location
  end

  defp do_calculate_distance(commands) do
    {point, _direction} = Enum.reduce(commands, {{0, 0}, :north}, &apply_command/2)

    distance_from_origin(point)
  end

  defp do_find_first_duplicate_location(commands) do
    start_state = {{{0, 0}, :north}, MapSet.new}

    point = Enum.reduce_while(commands, start_state, fn command, {current_position, previous_points} ->
      {current_point, _} = current_position

      new_position = {new_point, _} = apply_command(command, current_position)
      newly_visited_points = points_between(current_point, new_point) |> MapSet.delete(current_point)

      if path_cross_point = Enum.find(newly_visited_points, &MapSet.member?(previous_points, &1)) do
        {:halt, path_cross_point}
      else
        {:cont, {new_position, MapSet.union(previous_points, newly_visited_points)}}
      end
    end)

    distance_from_origin(point)
  end

  defp points_between({x, y1}, {x, y2}), do: (y1..y2) |> MapSet.new(fn y -> {x, y} end)
  defp points_between({x1, y}, {x2, y}), do: (x1..x2) |> MapSet.new(fn x -> {x, y} end)

  defp distance_from_origin({x, y}), do: abs(x) + abs(y)

  defp apply_command({turn, count}, {current_point, current_direction}) do
    new_direction = turn(current_direction, turn)
    new_point = walk(new_direction, current_point, count)

    {new_point, new_direction}
  end

  defp parse_directions(directions_string) do
    directions_string
    |> String.split(", ")
    |> Enum.map(&parse_single_command/1)
  end

  defp parse_single_command(<<"L", num_blocks :: binary>>), do: {:left,  Integer.parse(num_blocks) |> elem(0)}
  defp parse_single_command(<<"R", num_blocks :: binary>>), do: {:right, Integer.parse(num_blocks) |> elem(0)}

  defp turn(:north, :left), do: :west
  defp turn(:west,  :left), do: :south
  defp turn(:south, :left), do: :east
  defp turn(:east,  :left), do: :north

  defp turn(:north, :right), do: :east
  defp turn(:east,  :right), do: :south
  defp turn(:south, :right), do: :west
  defp turn(:west,  :right), do: :north

  defp walk(:north, {x, y}, blocks), do: {x, y + blocks}
  defp walk(:east,  {x, y}, blocks), do: {x + blocks, y}
  defp walk(:south, {x, y}, blocks), do: {x, y - blocks}
  defp walk(:west,  {x, y}, blocks), do: {x - blocks, y}

  ExUnit.start

  defmodule Test do
    use ExUnit.Case

    @directions "L3, R1, L4, L1, L2, R4, L3, L3, R2, R3, L5, R1, R3, L4, L1, L2, R2, R1, L4, L4, R2, L5, R3, R2, R1, L1, L2, R2, R2, L1, L1, R2, R1, L3, L5, R4, L3, R3, R3, L5, L190, L4, R4, R51, L4, R5, R5, R2, L1, L3, R1, R4, L3, R1, R3, L5, L4, R2, R5, R2, L1, L5, L1, L1, R78, L3, R2, L3, R5, L2, R2, R4, L1, L4, R1, R185, R3, L4, L1, L1, L3, R4, L4, L1, R5, L5, L1, R5, L1, R2, L5, L2, R4, R3, L2, R3, R1, L3, L5, L4, R3, L2, L4, L5, L4, R1, L1, R5, L2, R4, R2, R3, L1, L1, L4, L3, R4, L3, L5, R2, L5, L1, L1, R2, R3, L5, L3, L2, L1, L4, R4, R4, L2, R3, R1, L2, R1, L2, L2, R3, R3, L1, R4, L5, L3, R4, R4, R1, L2, L5, L3, R1, R4, L2, R5, R4, R2, L5, L3, R4, R1, L1, R5, L3, R1, R5, L2, R1, L5, L2, R2, L2, L3, R3, R3, R1"

    test "first half of the problem" do
      assert AdventOfCode.Puzzle1.calculate_distance("R2, L3") == 5
      assert AdventOfCode.Puzzle1.calculate_distance("R2, R2, R2") == 2
      assert AdventOfCode.Puzzle1.calculate_distance("R5, L5, R5, R3") == 12
      assert AdventOfCode.Puzzle1.calculate_distance(@directions) == 252
    end

    test "second half of the problem" do
      assert AdventOfCode.Puzzle1.find_first_duplicate_location("R8, R4, R4, R8") == 4
      assert AdventOfCode.Puzzle1.find_first_duplicate_location(@directions) == 143
    end
  end
end

