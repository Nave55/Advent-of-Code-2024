package main

import sa "core:container/small_array"
import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	pt1, pt2 := solution("input/day2.txt")
	fmt.printf("Part 1 = %v\nPart 2 = %v\n", pt1, pt2)
}

solver :: proc(arr: sa.Small_Array(10, int), n: int, pt1: bool) -> int {
	tmp := arr
	if n == sa.len(arr) do return 0

	if !pt1 do sa.ordered_remove(&tmp, n)
	sl := sa.slice(&tmp)
	p := len(sl) > 1 ? sl[0] - sl[1] : 0

	for j in 1 ..< len(sl) {
		dist := sl[j - 1] - sl[j]
		if p >= 0 {
			if dist > 3 || dist <= 0 {
				if pt1 do return 0
				break
			}
			if j == len(sl) - 1 do return 1
		} else if p <= 0 {
			if dist < -3 || dist >= 0 {
				if pt1 do return 0
				break
			}
			if j == len(sl) - 1 do return 1
		}
	}

	return solver(arr, n + 1, false)
}

solution :: proc(filepath: string) -> (pt1, pt2: int) {
	free_all(context.temp_allocator)
	data, ok := os.read_entire_file(filepath, context.temp_allocator)
	if !ok do return
	it := string(data)

	for line in strings.split_lines_iterator(&it) {
		s_arr: sa.Small_Array(10, int)
		tmp := strings.split(line, " ", context.temp_allocator)
		for i in tmp do sa.append(&s_arr, strconv.atoi(i))

		pt1 += solver(s_arr, 0, true)
		pt2 += solver(s_arr, 0, false)
	}

	return
}
