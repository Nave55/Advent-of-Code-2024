package day7

import "core:fmt"
import "core:os"
import "core:strings"
import "core:strconv"
import sa "core:container/small_array"
import vm "core:mem/virtual"
import "core:mem"

main :: proc() {
    arena: vm.Arena
    err := vm.arena_init_growing(&arena, 5 * mem.Megabyte)
    assert(err == .None)
    arena_allocator := vm.arena_allocator(&arena)
    context.allocator = arena_allocator
    defer vm.arena_destroy(&arena)

    targets, nums := parse_file("input/day7.txt")
    pt1, pt2 := solution(targets, nums)

    fmt.printfln("Part 1: %v\nPart 2: %v", pt1, pt2)
}

// @require_results
parse_file :: proc(filepath: string) -> (targets: [dynamic]int, nums: [dynamic]sa.Small_Array(12, int)) {
	data, ok := os.read_entire_file(filepath)
	if !ok do return
	defer delete(data)
    	defer free_all(context.temp_allocator)
	
	it := string(data)
	
	for line in strings.split_lines_iterator(&it) {
        tmp_arr := strings.split(line, ": ", context.temp_allocator)
        append(&targets, strconv.atoi(tmp_arr[0]))
        tmp_nums: sa.Small_Array(12, int) 
        for val, ind in strings.split(tmp_arr[1], " ", context.temp_allocator) {
            sa.append(&tmp_nums, strconv.atoi(val))
        }
        append(&nums, tmp_nums)
    }

    return
}

concat :: proc(a, b: int) -> int {
    return strconv.atoi(fmt.tprintf("%v%v", a, b))
}

evaluate :: proc(nums: []int, target, index, currentVal: int, pt1: bool) -> bool {
	if index == 0 do return evaluate(nums, target, index + 1, nums[0], pt1)
	if index == len(nums) do return currentVal == target
	
	num := nums[index]
	if evaluate(nums, target, index + 1, currentVal + num, pt1) do return true
	if evaluate(nums, target, index + 1, currentVal * num, pt1) do return true
	if !pt1 && evaluate(nums, target, index + 1, concat(currentVal, num), pt1) do return true
	
	return false
}

solution :: proc (a: [dynamic]int, b: [dynamic]sa.Small_Array(12, int)) -> (ttl, ttl2: int) {
	for _, ind in b {
        sli := sa.slice(&b[ind])
		if evaluate(sli, a[ind], 0, 0, true) do ttl += a[ind]
		if evaluate(sli, a[ind], 0, 0, false) do ttl2 += a[ind]
	}
	return ttl, ttl2
}
