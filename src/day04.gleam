import gleam/dict
import gleam/int
import gleam/list
import gleam/string
import gleam/yielder
import utils/file
import utils/print

pub fn main() {
  file.read_file("04")
  |> print.print(part1, part2)
}

pub fn build_grid_lookup(input: String) {
  input
  |> string.split("\n")
  |> yielder.from_list
  |> yielder.index
  |> yielder.flat_map(fn(row) {
    let #(l, y) = row
    l
    |> string.to_graphemes
    |> yielder.from_list
    |> yielder.index
    |> yielder.map(fn(col) {
      let #(c, x) = col
      #(#(x, y), c)
    })
  })
  |> yielder.to_list
  |> dict.from_list
}

fn add_tup(t1, t2) {
  let #(x1, x2) = t1
  let #(y1, y2) = t2

  #(x1 + y1, x2 + y2)
}

fn check_word(lookup, position, direction, w) {
  case w {
    [] -> 1
    [head, ..tail] -> {
      let new_pos = add_tup(position, direction)
      let x = dict.get(lookup, new_pos)

      case x {
        Ok(c) if head == c -> check_word(lookup, new_pos, direction, tail)
        _ -> 0
      }
    }
  }
}

pub fn part1(input: String) -> String {
  let lookup = build_grid_lookup(input)

  let directions = [
    #(1, 0),
    #(1, 1),
    #(0, 1),
    #(-1, 1),
    #(-1, 0),
    #(-1, -1),
    #(0, -1),
    #(1, -1),
  ]

  let words = ["M", "A", "S"]

  dict.to_list(lookup)
  |> list.fold(0, fn(acc, e) {
    let #(pos, c) = e

    case c {
      "X" ->
        acc
        + list.fold(directions, 0, fn(acc, d) {
          acc + check_word(lookup, pos, d, words)
        })
      _ -> acc
    }
  })
  |> int.to_string
}

pub fn part2(input: String) -> String {
  let lookup = build_grid_lookup(input)

  let directions = [#(1, 1), #(1, -1), #(-1, 1), #(-1, -1)]
  let chars = [
    ["S", "S", "M", "M"],
    ["M", "M", "S", "S"],
    ["S", "M", "S", "M"],
    ["M", "S", "M", "S"],
  ]

  let lookup_directions = fn(l: List(String), pos: #(Int, Int)) {
    list.zip(l, directions)
    |> list.fold(1, fn(acc, e) {
      let #(w, d) = e
      acc * check_word(lookup, pos, d, [w])
    })
  }

  let check_cross = fn(pos) {
    list.fold(chars, 0, fn(acc, l) { acc + lookup_directions(l, pos) })
  }

  dict.to_list(lookup)
  |> list.fold(0, fn(acc, e) {
    let #(pos, c) = e

    case c {
      "A" -> acc + check_cross(pos)
      _ -> acc
    }
  })
  |> int.to_string
}
