#+feature dynamic-literals
package day6

import "core:fmt"
import "core:os"
import "core:strings"
import "core:mem"
import vm "core:mem/virtual"
import "../Tools"

main :: proc() {
    arena: vm.Arena
    err := vm.arena_init_growing(&arena, 5 * mem.Megabyte)
    assert(err == .None)
    arena_allocator := vm.arena_allocator(&arena)
    context.allocator = arena_allocator
    defer vm.arena_destroy(&arena)
    
    dirs := map[int][2]int {
        0 = {-1, 0},
        1 = {0, 1},
        2 = {1, 0},
        3 = {0, -1},
    }

    start, locs, mat := parse_file("input/day6.txt")
    visited := solution(start, locs, dirs, &mat)
    ttl2 := solution2(start, locs, dirs, &mat, visited)

    fmt.printfln("Part 1: %v\nPart 2: %v", len(visited), ttl2)
}

@require_results
parse_file :: proc(filepath: string) -> (start: [2]int, locs: map[[2]int]int, mat: [130][130]rune) {
	data, ok := os.read_entire_file(filepath)
	if !ok do return
	defer delete(data)
	
	it := string(data)
	
    row := 0
	for line in strings.split_lines_iterator(&it) {
        tmp: [130]rune
        for i, col in line {
            tmp[col] = i
            if i == '^' do start = {row, col}
            if i == '#' do locs[{row, col}] = 0
        }

        mat[row] = tmp
        row += 1
    }

    return
}

@require_results
solution :: proc(pos: [2]int, locs: map[[2]int]int, dirs: map[int][2]int, mat: ^[130][130]rune) -> (visited: map[[2]int]struct{}) {
    facing := 0
    pos := pos

    for ((pos[0] > 0 && pos[0] < len(mat) -1) && pos[1] > 0 && pos[1] < len(mat[0])- 1) {
        next_pos := pos + dirs[facing]
        if Tools.arrValue(mat, next_pos, rune) == '#' {
            facing += 1
            if facing == 4 do facing = 0
        }
        else {
            visited[{pos[0], pos[1]}] = {}
            pos = next_pos
        }
    }
    visited[{pos[0], pos[1]}] = {}

    return
}

@require_results
solution2 :: proc(pos: [2]int, locs: map[[2]int]int, dirs: map[int][2]int, mat: ^[130][130]rune, empty: map[[2]int]struct{}) -> (ttl := 0) {
    locs := locs
    for i in empty {
        facing := 0
        pos := pos
        mat[i[0]][i[1]] = '#'
        locs[i] = 0   

        for ((pos[0] > 0 && pos[0] < len(mat) -1) && pos[1] > 0 && pos[1] < len(mat[0])- 1) {
            next_pos := pos + dirs[facing]
            if Tools.arrValue(mat, next_pos, rune)  == '#' {
                facing += 1
                locs[next_pos] += 1
                if locs[next_pos] == 4 {
                    fmt.printfln("Obstacle was at pos [%v, %v]", i[0], i[1])
                    ttl += 1
                    break
                }
                if facing == 4 do facing = 0
            }
            else do pos = next_pos
        }
        mat[i[0]][i[1]] = '.'
        for key in locs do locs[key] = 0
        delete_key(&locs, i)
    }

    return
}
