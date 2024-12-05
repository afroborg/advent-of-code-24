import day02
import gleeunit/should

pub fn day02_part_1_test() {
  let testinput =
    "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

  testinput
  |> day02.part1
  |> should.equal("2")
}

pub fn day02_part_2_test() {
  let testinput =
    "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"

  testinput
  |> day02.part2
  |> should.equal("4")
}
