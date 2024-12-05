import os
import tools

fn main() {
	pt1, pt2 := solution()!
	println('Part 1: ${pt1}\nPart 2: ${pt2}')
}


fn solution() !(int, int) {
	lines := os.read_lines('input/day4.txt')!
	mut arr := [][]rune{}

	for v in lines {
		arr << v.runes()
	}

	return check_xmas(arr), check_x(arr)
}

fn check_xmas(mat [][]rune) u32 {
	width := mat[0].len
	height := mat.len

	dirs := [
		[-3, -3], [-2, -2], [-1, -1], [-3, 3], [-2, 2], [-1, 1],
		[3, -3], [2, -2], [1, -1], [3, 3], [2, 2], [1, 1],
		[-3, 0], [-2, 0], [-1, 0], [3, 0], [2, 0], [1, 0],
		[0, -3], [0, -2], [0, -1], [0, 3], [0, 2], [0, 1]
		]

	mut valid_inds := [][]int{}
	for r_ind, r_val in mat {
		for c_ind, c_val in r_val {
			tmp := [r_ind, c_ind]
			if c_val == `X` {
				valid_inds << tmp
			}
		}
	}

	mut ttl := u32(0)
	mut cnt := 0
	for v in valid_inds {
		mut str := []rune{}
		for val in dirs {
			cnt++
			tmp := tools.add_arrs([val[0], val[1]], v)
			if (tmp[0] >= 0 && tmp[0] < height) && (tmp[1] >= 0 && tmp[1] < width) {
				str << rune(mat[tmp[0]][tmp[1]])
			}
			if cnt % 3 == 0 {
				str << `X`
				s := str.string()
				if s == "XMAS"|| s == "SAMX" {
					ttl += 1
				}
				str.clear()
			}
		}
	}	
	return ttl
} 

fn check_x(mat [][]rune) u32 {
	mut ttl := u32(0)
	mut valid_inds := [][]int{}
	for r_ind, r_val in mat {
		for c_ind, c_val in r_val {
			if c_val == `A` {
				valid_inds << [r_ind, c_ind]
			}
		}
	}

	for i in valid_inds {
		_, vals := tools.nbrs(mat, [i[0], i[1]], `d`)
		tmp := vals.string()
		if tmp in ["MMSS", "SSMM", "SMSM", "MSMS"] {
			ttl++
		}
	}
	return ttl
}