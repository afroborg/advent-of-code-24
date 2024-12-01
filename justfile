create day:
    @DAY=$(printf "%02d" {{day}}) && cp src/template.gleam src/day${DAY}.gleam && cp test/template_test.gleam test/day${DAY}_test.gleam

run day:
    @DAY=$(printf "%02d" {{day}}) && gleam run -m day${DAY}