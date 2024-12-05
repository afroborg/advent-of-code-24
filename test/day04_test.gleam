import day04
import gleeunit/should

pub fn day04_part_1_test() {
  let testinput =
    "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"

  testinput
  |> day04.part1
  |> should.equal("18")
}

pub fn day04_part_2_test() {
  let testinput =
    ".M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
.........."

  testinput
  |> day04.part2
  |> should.equal("9")
}
