import gleam/dict
import gleam/function
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils/file
import utils/print

pub fn main() {
  file.read_file("01")
  |> print.print(part1, part2)
}

fn process(input: String) -> #(List(Int), List(Int)) {
  let #(l1, l2) =
    input
    |> string.split("\n")
    |> list.map(fn(l) { string.split_once(l, "   ") })
    |> result.values()
    |> list.unzip()

  let sorted = fn(l) {
    l
    |> list.map(fn(s) { s |> int.parse() })
    |> result.values()
    |> list.sort(int.compare)
  }

  #(sorted(l1), sorted(l2))
}

pub fn part1(input: String) -> String {
  let #(l1, l2) = process(input)
  list.zip(l1, l2)
  |> list.map(fn(x) {
    let #(a, b) = x
    int.absolute_value(a - b)
  })
  |> int.sum()
  |> int.to_string()
}

pub fn part2(input: String) -> String {
  let #(l1, l2) = process(input)

  let map =
    list.group(l2, by: function.identity)
    |> dict.map_values(fn(_k, v) { list.length(v) })

  list.map(l1, fn(x) {
    dict.get(map, x)
    |> result.unwrap(0)
    |> int.multiply(x)
  })
  |> int.sum()
  |> int.to_string()
}
