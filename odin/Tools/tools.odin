package tools

import "core:text/regex"
import "core:unicode/utf8"

arrValue :: proc(arr: ^$T, arr2: [2]int, $R: typeid) -> R {
	when R == rune do return rune(arr[arr2.x][arr2.y])
	when R != rune do return arr[arr2.x][arr2.y]
	return 0
}

nbrs :: proc(
	arr: ^$T,
	loc: [2]int,
	$N: int,
	$F: bool,
	$R: typeid,
) -> (
	indices: [N][2]int,
	vals: [N]R,
) {
	assert(N == 4 || N == 8, "N must be 4 or 8")

	dir: [N][2]int
	when N == 4 && F == false do dir = {{-1, 0}, {0, -1}, {0, 1}, {1, 0}}
	when N == 4 && F == true do dir = {{-1, -1}, {-1, 1}, {1, -1}, {1, 1}}
	when N == 8 do dir = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}
	for i, ind in dir {
		tmp := loc + i
		if tmp[0] != -1 && tmp[1] != -1 && tmp[0] < len(arr) && tmp[1] < len(arr[0]) {
			indices[ind] = tmp
			vals[ind] = arrValue(arr, tmp, R)
		}
	}
	return
}

regexFind :: proc(str, pattern: string, slide: int = 1) -> (arr: [dynamic]regex.Capture) {
	re, _ := regex.create(pattern, {.Global}, context.temp_allocator)

	ind := 0
	for ind < len(str) {
		res, pass := regex.match_and_allocate_capture(re, str[ind:])
		if pass {
			ind += res.pos[0][1]
			append(&arr, res)
		} else do ind += slide
	}
	return
}

