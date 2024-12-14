module tools

pub fn add_arrs[T](arr []T, arr2 []T) []T {
	mut n := []T{}
	for i in 0..arr.len {
		n << arr[i] + arr2[i]
	}
	return n
}

pub fn arr_value[T](arr [][]T, pos Vec2[int]) T {
	return arr[pos.x][pos.y]
}

pub fn in_bounds(pos Vec2[int], height int, width int) bool {
	return (pos.x >= 0 && pos.x < height && pos.y >= 0 && pos.y < width)
}


pub fn nbrs[T](arr [][]T, loc Vec2[int], t rune) ([]Vec2[int], []T) {
	mut dir := []Vec2[int]{}
    if t == `n` {
		dir = [Vec2[int]{-1, 0}, Vec2[int]{0, -1}, Vec2[int]{0, 1}, Vec2[int]{1, 0}]
	}
	else if t == `d` {
		dir = [Vec2[int]{-1, -1}, Vec2[int]{-1, 1}, Vec2[int]{1, -1}, Vec2[int]{1, 1}]
	} 
	else if t== `b`  {
		dir = [Vec2[int]{-1, -1}, Vec2[int]{-1, 0}, Vec2[int]{-1, 1}, Vec2[int]{0, -1}, Vec2[int]{0, 1}, Vec2[int]{1, -1}, Vec2[int]{1, 0}, Vec2[int]{1, 1}]
	}
    mut indices := []Vec2[int]{}
    mut vals := []T{}
    for i in dir {
        tmp := loc + i
        if in_bounds(tmp, arr.len, arr[0].len) {
            indices << tmp
            vals << arr_value[T](arr, tmp);
        }
    }
	return indices, vals
}
