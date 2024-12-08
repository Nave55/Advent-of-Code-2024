import os
import tools
import datatypes { Set }

fn main() {
	mut mat, mut empty, start := parse_file()!
	height := mat.len - 1
	width := mat[0].len - 1
	dirs := {
		0: [-1, 0]
		1: [0, 1]
		2: [1, 0]
		3: [0, -1]
	}
	pt1, mut visited := solution1(mat, start, width, height, dirs)
	pt2 := solution2(mut mat, start, width, height, dirs, mut empty, mut visited)!

	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}

fn parse_file() !([][]rune, map[string]int, []int) {
	lines := os.read_lines('input/day6.txt')!
	mut locs := map[string]int{}
	mut arr := [][]rune{}
	mut start := []int{}

	for v in lines {
		arr << v.runes()
	}

	for r_ind, r_val in arr {
		for c_ind, c_val in r_val {
			if c_val == `^` {
				start = [r_ind, c_ind]
			}
			if c_val == `#` {
				locs[r_ind.str() + ',' + c_ind.str()] = 0
			}
		}
	}

	return arr, locs, start
}

fn solution1(mat [][]rune, start []int, width int, height int, dirs map[int][]int) (int, Set[string]) {
	mut facing := 0
	mut pos := start.clone()
	mut visited := datatypes.Set[string]{}

	for pos[0] > 0  && pos[0] < height && pos[1] > 0 && pos[1] < width {
		next_pos := tools.add_arrs(pos, dirs[facing])
		if tools.arr_value(mat, next_pos) == `#` {
			facing += 1
			if facing == 4 {
				facing = 0
			}
		} else {
			visited.add(pos[0].str() + ',' + pos[1].str())
			pos[0] = next_pos[0]
			pos[1] = next_pos[1]
		}
	}

	visited.add(pos[0].str() + ',' + pos[1].str())

	return visited.size(), visited
}

fn solution2(mut mat [][]rune, start []int, width int, height int, dirs map[int][]int, mut locs map[string]int, mut empty Set[string]) !int {
	mut ttl := 0 
	for !empty.is_empty() {
		v := empty.pop() or { break }
		v_pos := v.split(",").map(it.int())
		mut facing := 0
		mut pos := start.clone()
		mat[v_pos[0]][v_pos[1]] = `#`
		locs[v] = 0

		for pos[0] > 0  && pos[0] < height && pos[1] > 0 && pos[1] < width {
			next_pos := tools.add_arrs(pos, dirs[facing])
			if tools.arr_value(mat, next_pos) == `#` {
				str_pos :=next_pos[0].str() + "," + next_pos[1].str()
				facing += 1
				locs[str_pos] += 1
				if locs[str_pos] == 4 {
					println("Obstacle at ${v.split(',').map(it.int())}")
					ttl++
					break
				}	
				if facing == 4 {
					facing = 0
				}
			} else {
				pos[0] = next_pos[0]
				pos[1] = next_pos[1]
			}
		}
		mat[v_pos[0]][v_pos[1]] = `.`
		for i in locs.keys() {
			locs[i] = 0
		}
		locs.delete(v)

	}

	return ttl
}