import day03
import gleeunit/should

pub fn day03_part_1_test() {
  let testinput =
    "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

  testinput
  |> day03.part1
  |> should.equal("161")
}

pub fn day03_part_2_test() {
  let testinput =
    "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

  testinput
  |> day03.part2
  |> should.equal("48")
}
