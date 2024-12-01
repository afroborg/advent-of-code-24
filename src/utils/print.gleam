import gleam/io
import gleam/string

pub fn print(
  input: String,
  part1: fn(String) -> String,
  part2: fn(String) -> String,
) {
  let p = fn(f) { input |> f |> string.trim() }

  io.print("Part 1: " <> p(part1) <> "\n")
  io.print("Part 2: " <> p(part2) <> "\n")
}
