defmodule AdventOfCode.Puzzle3 do
  def count_possible_triangle_rows(triangles_string) do
    triangles_string
    |> parse_into_triangles_from_rows
    |> Enum.count(&triangle_valid?/1)
  end

  def count_possible_triangle_columns(triangles_string) do
    triangles_string
    |> parse_into_triangles_from_rows
    |> rearrange_triangles_from_columns
    |> Enum.count(&triangle_valid?/1)
  end

  defp parse_into_triangles_from_rows(triangles_string) do
    triangles_string
    |> String.split("\n")
    |> Enum.reject(fn s -> s == "" end)
    |> Enum.map(fn triangle_line ->
         triangle_line
         |> String.split
         |> Enum.map(fn str ->
              {int, _} = Integer.parse(str)
              int
            end)
         |> List.to_tuple
       end)
  end

  defp rearrange_triangles_from_columns(triangle_rows) do
    triangle_rows
    |> Enum.chunk(3)
    |> Enum.flat_map(fn rows ->
         [ {a1, a2, a3},
           {b1, b2, b3},
           {c1, c2, c3} ] = rows

         [
           {a1, b1, c1},
           {a2, b2, c2},
           {a3, b3, c3},
         ]
       end)
  end

  defp triangle_valid?({a, b, c}) do
    a + b > c &&
    b + c > a &&
    c + a > b
  end

  ExUnit.start

  defmodule Test do
    use ExUnit.Case

    @input File.read!("puzzle_3.input")

    test "first part" do
      assert AdventOfCode.Puzzle3.count_possible_triangle_rows(@input) == 862
    end

    test "second part" do
      assert AdventOfCode.Puzzle3.count_possible_triangle_columns(@input) == 1577
    end
  end
end
