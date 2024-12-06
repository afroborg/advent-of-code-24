import gleam/bool
import gleam/dict
import gleam/int
import gleam/option
import gleam/result
import gleam/set
import utils/file
import utils/print

type Position =
  #(Int, Int)

type Direction {
  Up
  Down
  Left
  Right
}

type Point {
  None
  Obstruction
}

type Guard {
  Guard(pos: Position, dir: Direction)
}

type Map =
  dict.Dict(Position, Point)

pub fn main() {
  file.read_file("06")
  |> print.print(part1, part2)
}

fn build(
  input: String,
  lookup: Map,
  curr_pos: Position,
  guard: option.Option(Guard),
) {
  let insert = dict.insert(lookup, curr_pos, _)
  let guard_dir = fn(dir) { option.Some(Guard(curr_pos, dir)) }

  case input {
    "." <> r -> build(r, insert(None), step(curr_pos, Right), guard)
    "^" <> r -> build(r, insert(None), step(curr_pos, Right), guard_dir(Up))
    "v" <> r -> build(r, insert(None), step(curr_pos, Right), guard_dir(Down))
    "<" <> r -> build(r, insert(None), step(curr_pos, Right), guard_dir(Left))
    ">" <> r -> build(r, insert(None), step(curr_pos, Right), guard_dir(Right))
    "#" <> r -> build(r, insert(Obstruction), step(curr_pos, Right), guard)
    "\n" <> r -> build(r, lookup, #(0, curr_pos.1 + 1), guard)
    _ -> #(lookup, guard)
  }
}

fn start_build(input: String) {
  let assert #(lookup, option.Some(guard)) =
    build(input, dict.new(), #(0, 0), option.None)

  #(lookup, guard)
}

fn step(pos: Position, dir: Direction) -> Position {
  let #(x, y) = pos
  case dir {
    Up -> #(x, y - 1)
    Down -> #(x, y + 1)
    Left -> #(x - 1, y)
    Right -> #(x + 1, y)
  }
}

fn turn(dir: Direction) -> Direction {
  case dir {
    Up -> Right
    Down -> Left
    Left -> Up
    Right -> Down
  }
}

fn next_guard_pos(guard: Guard, p: Point) {
  case p {
    None -> Guard(step(guard.pos, guard.dir), guard.dir)
    Obstruction -> Guard(guard.pos, turn(guard.dir))
  }
}

fn walk(guard: Guard, visited: set.Set(Position), lookup: Map) {
  let next = step(guard.pos, guard.dir)
  let visited = visited |> set.insert(guard.pos)

  lookup
  |> dict.get(next)
  |> result.map(fn(p) { next_guard_pos(guard, p) |> walk(visited, lookup) })
  |> result.unwrap(visited)
}

fn start_walk(guard: Guard, lookup: Map) {
  walk(guard, set.new(), lookup)
}

fn causes_loop(guard: Guard, visited: set.Set(Guard), lookup: Map) {
  visited
  |> set.contains(guard)
  |> bool.guard(True, fn() {
    let next = step(guard.pos, guard.dir)
    let visited = visited |> set.insert(guard)

    lookup
    |> dict.get(next)
    |> result.map(fn(p) {
      next_guard_pos(guard, p) |> causes_loop(visited, lookup)
    })
    |> result.unwrap(False)
  })
}

pub fn part1(input: String) -> String {
  let #(lookup, guard) = start_build(input)
  let visited = start_walk(guard, lookup)

  visited |> set.size |> int.to_string
}

pub fn part2(input: String) -> String {
  let #(lookup, guard) = start_build(input)

  // can't be at the same position as the guard
  start_walk(guard, lookup)
  |> set.delete(guard.pos)
  |> set.filter(fn(x) {
    causes_loop(guard, set.new(), lookup |> dict.insert(x, Obstruction))
  })
  |> set.size
  |> int.to_string
}
