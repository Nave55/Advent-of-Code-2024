package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
	left, right := parse_file("input/day1.txt")
	defer { delete(left); delete(right) }
	pt1 := solution(left[:], right[:])
	pt2 := solution2(left[:], right[:])
	fmt.printf("Part 1 = %v\nPart 2 = %v\n", pt1, pt2)
}

parse_file :: proc(filepath: string) -> (left, right: [dynamic]int) {
	data, ok := os.read_entire_file(filepath)
	if !ok do return
	defer delete(data)
	
	it := string(data)

	for line in strings.split_lines_iterator(&it) {
		tmp := strings.split(line, "   ", context.temp_allocator)
		append(&left, strconv.atoi(tmp[0]))
		append(&right, strconv.atoi(tmp[1]))
	}

	slice.sort(left[:])
	slice.sort(right[:])

	return
}

solution :: proc(left: []int, right: []int) -> (sum: int) {
	for i in 0..<len(left) {
		sum += abs(left[i] - right[i])
	}

	return
}

solution2 :: proc(left: []int, right: []int) -> (sum: int) {
	l_map := make(map[int]int)
	defer delete(l_map)

	for i in left {
		l_map[i] = 0
	}

	for i in right {
		if i in l_map {
			l_map[i] += 1
		}
	}

	for i, v in l_map {
		sum += i * v
	}

	return
}
