package main

import "core:fmt"
import "core:os"
import "core:slice"
import "core:strconv"
import "core:strings"

main :: proc() {
    pt1, pt2 := solution("input/day2.txt")
    fmt.printf("Part 1 = %v\nPart 2 = %v\n", pt1, pt2)
}

solver :: proc(arr: []int, n: int, pt1: bool) -> int {
    if n == len(arr) do return 0

    tmp := slice.clone_to_dynamic(arr, context.temp_allocator)    
    if !pt1 do ordered_remove(&tmp, n)
    p := len(tmp) > 1 ? tmp[0] - tmp[1] : 0 

    for j in 1..<len(tmp) {
        dist := tmp[j - 1] - tmp[j]
        if p >= 0 {
            if dist > 3 || dist <= 0 {
                if pt1 do return 0
                break
            }
            if j == len(tmp) - 1 do return 1
        } else if p <= 0 {
            if dist < -3 || dist >= 0 {
                if pt1 do return 0
                break
            }
            if j == len(tmp) - 1 do return 1
        }
    }
    
    return solver(arr, n + 1, false) 
}

solution :: proc(filepath: string) -> (pt1, pt2: int) {
    data, ok := os.read_entire_file(filepath, context.temp_allocator)
    if !ok do return
    it := string(data)

    for line in strings.split_lines_iterator(&it) {
        tmp := strings.split(line, " ", context.temp_allocator)
        int_arr := make([dynamic]int, context.temp_allocator)
        for i in tmp do append(&int_arr, strconv.atoi(i))

        pt1 += solver(int_arr[:], 0, true)
        pt2 += solver(int_arr[:], 0, false)
    }

    return
}

