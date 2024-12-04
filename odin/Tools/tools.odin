package tools

import "core:text/regex"
import "core:fmt"

arrValue :: proc(arr: [$A][$B]$T, arr2: [2]int) -> T {
    return arr[arr2[0]][arr2[1]]
}

nbrs :: proc(arr: [$A][$B]$T, loc: [2]int, $N: int, diag: bool = false) -> (indices: [N][2]int, vals: [N]T) {
    assert(N == 4 || N == 8, "N must be 4 or 8")

    dir: [N][2]int
    when diag == false && N == 4 do dir = {{-1, 0}, {0, -1}, {0, 1}, {1, 0}}
    when diag == true && N == 4 do dir = {{-1, -1}, {-1, 1}, {1, -1}, {1, 1}}
    when N == 8 do dir = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}

    for i, ind in dir {
        tmp := loc + i
        if tmp[0] != -1 && tmp[1] != -1 && tmp[0] != len(arr) && tmp[1] != len(arr[0]) {
            indices[ind] = tmp
            vals[ind] = arrValue(arr, tmp)
        }
    }
    return
}

regexFind :: proc(str, pattern: string, slide: int = 1) -> (arr: [dynamic]regex.Capture) {
    re, _ := regex.create(pattern, {.Global}); 
    defer { regex.destroy(re); delete(arr) }
    
    ind := 0
    for ind < len(str) {
        res, pass := regex.match_and_allocate_capture(re, str[ind:], context.temp_allocator)
        if pass {
            ind += res.pos[0][1]
            append(&arr, res)
        }
        else {
            ind += slide
        }
    }
    return
}
