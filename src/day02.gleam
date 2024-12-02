import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils/file
import utils/print

pub fn main() {
  file.read_file("02")
  |> print.print(part1, part2)
}

fn process(input: String) -> List(List(Int)) {
  input
  |> string.split("\n")
  |> list.map(fn(x) {
    string.split(x, " ")
    |> list.map(int.parse)
    |> result.values()
  })
}

fn is_safe(l: List(Int)) -> Bool {
  let distances =
    l
    |> list.window_by_2()
    |> list.map(fn(x) {
      let #(a, b) = x
      a - b
    })

  distances
  |> list.all(fn(x) { x >= 1 && x <= 3 })
  |> bool.or(
    distances
    |> list.all(fn(x) { x >= -3 && x <= -1 }),
  )
}

fn subsets(l: List(Int)) -> List(List(Int)) {
  l
  |> list.combinations(list.length(l) - 1)
}

pub fn part1(input: String) -> String {
  process(input)
  |> list.filter(is_safe)
  |> list.length()
  |> int.to_string()
}

pub fn part2(input: String) -> String {
  process(input)
  |> list.filter(fn(x) {
    x
    |> subsets
    |> list.any(is_safe)
  })
  |> list.length()
  |> int.to_string()
}
