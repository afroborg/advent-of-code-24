import gleam/int
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import utils/file
import utils/print

pub fn main() {
  file.read_file("07")
  |> print.print(part1, part2)
}

fn process(input: String) {
  input
  |> string.split("\n")
  |> list.map(fn(row) {
    let assert Ok(#(answer, number_parts)) =
      row
      |> string.split_once(": ")
      |> result.map(fn(x) {
        let #(answer, parts) = x
        let assert Ok(answer) = answer |> int.parse
        let number_parts =
          parts |> string.split(" ") |> list.map(int.parse) |> result.values
        #(answer, number_parts)
      })

    #(answer, number_parts)
  })
}

fn nbr_concat(a: Int, b: Int) {
  let assert Ok(res) = { a |> int.to_string <> b |> int.to_string } |> int.parse
  res
}

fn can_be_calculated(answer: Int, acc: Int, parts: List(Int), with_concat: Bool) {
  case parts {
    [] -> acc == answer
    [head, ..tail] ->
      can_be_calculated(answer, acc + head, tail, with_concat)
      || can_be_calculated(answer, acc * head, tail, with_concat)
      || {
        with_concat
        && can_be_calculated(answer, nbr_concat(acc, head), tail, with_concat)
      }
  }
}

pub fn part1(input: String) -> String {
  let equations = process(input)

  equations
  |> list.filter(fn(x) {
    let #(answer, parts) = x
    can_be_calculated(answer, 0, parts, False)
  })
  |> list.map(pair.first)
  |> int.sum
  |> int.to_string
}

pub fn part2(input: String) -> String {
  let equations = process(input)

  equations
  |> list.filter(fn(x) {
    let #(answer, parts) = x
    can_be_calculated(answer, 0, parts, True)
  })
  |> list.map(pair.first)
  |> int.sum
  |> int.to_string
}
