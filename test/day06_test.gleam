import day06
import gleeunit/should

pub fn day06_part_1_test() {
  let testinput =
    "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."

  testinput
  |> day06.part1
  |> should.equal("41")
}

pub fn day06_part_2_test() {
  let testinput =
    "....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#..."

  testinput
  |> day06.part2
  |> should.equal("6")
}