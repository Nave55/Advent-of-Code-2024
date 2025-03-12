import os
import tools as t
import datatypes as dt

fn main() {
	mat, mp, width, height := parse_file()
	slopes := ant_slopes(mp)
	pt1 := solution(mat, mp, slopes, width, height)
	pt2 := solution2(mp, slopes, width, height)
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() ([][]rune, map[rune][]t.Vec2[int], int, int)  {
	lines := os.read_lines('input/day8.txt') or { panic(err) }
	mut arr := [][]rune{}
	mut mp := map[rune][]t.Vec2[int]{}

	for i in lines {
		arr << i.runes()
	}

	for r_ind, r_val in arr {
		for c_ind, c_val in r_val {
			if c_val != `.` {
				mp[c_val] << t.Vec2[int]{r_ind, c_ind}
			}
		}
	}
	
	width := int(arr[0].len)
	height := int(arr.len)

	return arr, mp, width, height
}

fn ant_slopes(ants map[rune][]t.Vec2[int]) map[string][]t.Vec2[int] {
	mut slopes := map[string][]t.Vec2[int]{}

	for value in ants.values() {
		for i in 0..value.len - 1 {
			for j in i+1..value.len {
				slopes[value[i].to_str()] << value[i] - value[j]
			}
		}
	}

	return slopes
}

fn solution(mat [][]rune, ants map[rune][]t.Vec2[int], slopes map[string][]t.Vec2[int], width int, height int) int {
	mut ttl := dt.Set[string]{}

	for key, value in slopes {
		for i in value {
			vec := t.str_to_vec2[int](key)
			symb := t.arr_value(mat, vec)
			pos := vec + i
			neg := vec - (i.mul_by_scalar(2))

			if t.in_bounds(pos, height, width) && t.arr_value(mat, pos) != symb {
				ttl.add(pos.to_str())
			}
			if t.in_bounds(neg, height, width) && t.arr_value(mat, neg) != symb {
				ttl.add(neg.to_str())
			}
		}
	}

	return ttl.size()
}

fn solution2(ants map[rune][]t.Vec2[int], slopes map[string][]t.Vec2[int], width int, height int) int {
	mut ttl := dt.Set[string]{};

	for key, value in slopes {
		ttl.add(key)
		for i in value {
			mut val := t.str_to_vec2[int](key)
			for {
				val = val + i
				if t.in_bounds(val, height, width) {
					ttl.add(val.to_str())
				} else {
					val = t.str_to_vec2[int](key)
					break
				}
			}
			for {
				val = val - i
				if t.in_bounds(val, height, width) {
					ttl.add(val.to_str())
				} else {
					break
				}
			}
		}
	}

	return ttl.size()
}
