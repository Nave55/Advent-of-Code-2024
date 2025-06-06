package AoC

import "../Tools"
import sa "core:container/small_array"
import "core:fmt"
import "core:mem"
import vm "core:mem/virtual"
import "core:os"
import "core:strings"
import "core:unicode/utf8"

main :: proc() {
	arena: vm.Arena
	err := vm.arena_init_static(&arena, 1 * mem.Megabyte)
	assert(err == .None)
	arena_allocator := vm.arena_allocator(&arena)
	context.allocator = arena_allocator
	defer vm.arena_destroy(&arena)

	solution("input/day4.txt")
}

solution :: proc(filepath: string) {
	arr: [dynamic][]rune
	data, ok := os.read_entire_file(filepath)
	if !ok do return
	it := string(data)

	for line in strings.split_lines_iterator(&it) {
		tmp := utf8.string_to_runes(line)
		append(&arr, tmp)
	}

	pt1 := checkXmas(&arr)
	pt2 := checkX(&arr)
	fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
}

checkXmas :: proc(mat: ^[dynamic][]rune) -> (ttl: u32) {
	width, height := len(mat[0]), len(mat)
	dirs: [24][2]int = {
		{-3, -3},
		{-2, -2},
		{-1, -1},
		{-3, 3},
		{-2, 2},
		{-1, 1},
		{3, -3},
		{2, -2},
		{1, -1},
		{3, 3},
		{2, 2},
		{1, 1},
		{-3, 0},
		{-2, 0},
		{-1, 0},
		{3, 0},
		{2, 0},
		{1, 0},
		{0, -3},
		{0, -2},
		{0, -1},
		{0, 3},
		{0, 2},
		{0, 1},
	}

	valid_inds: [dynamic][2]int
	for r_val, r_ind in mat {
		for c_val, c_ind in r_val {
			tmp: [2]int = {r_ind, c_ind}
			if c_val == 'X' do append(&valid_inds, tmp)
		}
	}

	cnt := 0
	for v in valid_inds {
		str: sa.Small_Array(4, rune)
		for val in dirs {
			defer free_all(context.temp_allocator)
			cnt += 1
			tmp: [2]int = {val.x, val.y} + v
			if (tmp.x >= 0 && tmp.x < height) &&
			   (tmp.y >= 0 && tmp.y < width) {
				sa.append(&str, rune(mat[tmp.x][tmp.y]))
			}
			if cnt %% 3 == 0 {
				sa.append(&str, 'X')
				s := utf8.runes_to_string(
					sa.slice(&str),
					context.temp_allocator,
				)
				if s == "XMAS" || s == "SAMX" do ttl += 1
				sa.clear(&str)
			}
		}
	}
	return
}

checkX :: proc(mat: ^[dynamic][]rune) -> (ttl: u32) {
	valid_inds := make([dynamic][2]int)
	for r_val, r_ind in mat {
		for c_val, c_ind in r_val {
			if c_val == 'A' {
				append(&valid_inds, ([2]int){r_ind, c_ind})
			}
		}
	}

	for i in valid_inds {
		_, vals := Tools.nbrs(mat, ([2]int){i.x, i.y}, 4, true, rune)
		tmp := utf8.runes_to_string(vals[:], context.temp_allocator)
		if tmp == "MMSS" || tmp == "SSMM" || tmp == "SMSM" || tmp == "MSMS" {
			ttl += 1
		}
	}
	return
}
