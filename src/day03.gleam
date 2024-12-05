import gleam/int
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/string
import utils/file
import utils/print

pub fn main() {
  file.read_file("03")
  |> print.print(part1, part2)
}

pub fn part1(input: String) -> String {
  let assert Ok(re) = regexp.from_string("mul\\((\\d+),(\\d+)\\)")

  re
  |> regexp.scan(input)
  |> list.flat_map(fn(m) { m.submatches })
  |> option.values()
  |> list.map(int.parse)
  |> result.values()
  |> list.sized_chunk(2)
  |> list.map(int.product)
  |> int.sum()
  |> int.to_string()
}

pub fn part2(input: String) -> String {
  let assert Ok(after_dont) = regexp.from_string("don't\\(\\).*$")

  input
  |> string.replace("\n", "")
  |> string.split("do()")
  |> list.map(regexp.replace(after_dont, _, ""))
  |> string.join("")
  |> part1
}
