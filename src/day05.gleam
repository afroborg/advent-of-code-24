import gleam/dict
import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/set
import gleam/string
import gleam/yielder
import utils/file
import utils/print

pub fn main() {
  file.read_file("05")
  |> print.print(part1, part2)
}

fn get_tuple_idx(tup, idx) {
  let #(first, second) = tup

  case idx {
    0 -> first
    1 -> second
    _ -> panic
  }
}

pub fn build_set(rules: List(#(String, String))) {
  rules
  |> list.group(get_tuple_idx(_, 0))
  |> dict.map_values(fn(_k, v) {
    v
    |> list.map(get_tuple_idx(_, 1))
    |> set.from_list
  })
}

fn process(input: String) {
  let assert Ok(#(ordering_str, update)) = input |> string.split_once("\n\n")
  let order_rules =
    ordering_str
    |> string.split("\n")
    |> list.map(string.split_once(_, "|"))
    |> result.values
    |> build_set

  let update_numbers =
    update
    |> string.split("\n")
    |> list.map(fn(x) {
      x
      |> string.split(",")
    })

  #(order_rules, update_numbers)
}

fn middle_of_list(l) {
  let length = list.length(l)

  l
  |> yielder.from_list
  |> yielder.at(length / 2)
}

fn is_valid_order(ruleset, update_numbers) {
  case update_numbers {
    [_] | [] -> True
    [x, ..rest] -> {
      let rest_set = rest |> set.from_list
      let remaining = ruleset |> dict.get(x) |> result.unwrap(set.new())

      set.is_subset(rest_set, remaining) && is_valid_order(ruleset, rest)
    }
  }
}

fn compare(a, b, rules) {
  case rules |> dict.get(a) |> result.unwrap(set.new()) |> set.contains(b) {
    True -> order.Lt
    False -> order.Gt
  }
}

fn summarize_str_list(l) {
  l |> list.map(int.parse) |> result.values |> int.sum |> int.to_string
}

pub fn part1(input: String) -> String {
  let #(ruleset, update_numbers) = process(input)

  update_numbers
  |> list.filter(is_valid_order(ruleset, _))
  |> list.map(middle_of_list)
  |> result.values
  |> summarize_str_list
}

pub fn part2(input: String) -> String {
  let #(ruleset, update_numbers) = process(input)

  update_numbers
  |> list.filter(fn(x) { !is_valid_order(ruleset, x) })
  |> list.map(list.sort(_, fn(a, b) { compare(a, b, ruleset) }))
  |> list.map(middle_of_list)
  |> result.values
  |> summarize_str_list
}
