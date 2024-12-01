import day01
import gleeunit/should

pub fn day01_part_1_test() {
  let testinput =
    "3   4
4   3
2   5
1   3
3   9
3   3"

  day01.part1(testinput)
  |> should.equal("11")
}

pub fn day01_part_2_test() {
  let testinput =
    "3   4
4   3
2   5
1   3
3   9
3   3"

  day01.part2(testinput)
  |> should.equal("31")
}
