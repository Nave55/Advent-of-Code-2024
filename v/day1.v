import os
import math

fn main() {
	a, b := parse_file()!
	pt1 := solution(a, b)
	pt2 := solution2(a, b)
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() !([]int, []int) {
	lines := os.read_lines('input/Day1.txt')!
	mut left := []int{len: lines.len, cap: lines.len, init: 0}
	mut right := []int{len: lines.len, cap: lines.len, init: 0}

	for i, v in lines {
		tmp := v.split('   ').map(it.int())
		left[i] = tmp[0]
		right[i] = tmp[1]
	}

	left.sort(a < b)
	right.sort(a < b)

	return left, right
}

fn solution(left []int, right []int) int {
	mut sum := 0
	for i in 0 .. left.len {
		sum += math.abs(left[i] - right[i])
	}

	return sum
}

fn solution2(left []int, right []int) int {
	mut l_map := map[int]int{}
	for i in left {
		l_map[i] = 0
	}

	for i in right {
		if i in l_map {
			l_map[i] += 1
		}
	}

	mut ttl := 0

	for i, v in l_map {
		ttl += i * v
	}

	return ttl
}
