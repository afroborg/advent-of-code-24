import simplifile

pub fn read_file(day: String) -> String {
  let file_path = "./input/day" <> day <> ".txt"
  let assert Ok(file) = simplifile.read(from: file_path)

  file
}
