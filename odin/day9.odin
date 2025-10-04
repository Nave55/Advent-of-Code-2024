package day9

import "core:fmt"
import "core:mem"
import vm "core:mem/virtual"
import "core:os"

file_info :: struct {
	val:  int,
	pos:  int,
	size: int,
}

main :: proc() {
	arena: vm.Arena
	err := vm.arena_init_static(&arena, 5 * mem.Megabyte)
	assert(err == .None)
	arena_allocator := vm.arena_allocator(&arena)
	context.allocator = arena_allocator
	defer vm.arena_destroy(&arena)

	data, filled, empty, ok := parse_file("input/day9.txt")
	assert(ok, "Bad File Path")
	pt1 := solve(&data)
	pt2 := solveTwo(&filled, &empty)
	fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
}

parse_file :: proc(
	filepath: string,
) -> (
	arr: [dynamic]int,
	filled: [dynamic]file_info,
	empty: [dynamic]file_info,
	ok: bool = true,
) {
	data := os.read_entire_file(filepath) or_return
	it := string(data)

	pos, neg, idx := 0, -1, 0
	for i, ind in it {
		times := int(i) - int('0')
		if ind % 2 == 0 {
			for _ in 0 ..< times do append(&arr, pos)
			if times > 0 {
				append(&filled, file_info{pos, idx, times})
				pos += 1
			}
		} else {
			for _ in 0 ..< times do append(&arr, neg)
			if times > 0 {
				append(&empty, file_info{-1, idx, times})
				neg -= 1
			}
		}
		idx += times
	}

	return
}

solve :: proc(arr: ^[dynamic]int) -> (ttl: int) {
	for i, ind in arr {
		if i < 0 {
			pop_val := pop(arr)
			for pop_val < 0 do pop_val = pop(arr)
			if ind >= len(arr) do break
			ttl += ind * pop_val
			arr[ind] = pop_val
		} else do ttl += ind * i
	}
	return
}

solveTwo :: proc(
	filled: ^[dynamic]file_info,
	empty: ^[dynamic]file_info,
) -> (
	ttl: int,
) {
	#reverse for &f_val in filled {
		for &e_val in empty {
			if f_val.pos <= e_val.pos do break
			if f_val.size <= e_val.size {
				f_val.pos = e_val.pos
				e_val.size -= f_val.size
				e_val.pos += f_val.size
				break
			}
		}
	}

	for &i in filled {
		for ind in i.pos ..< i.pos + i.size {
			ttl += i.val * ind
		}
	}

	return ttl
}
