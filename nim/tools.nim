proc `+`* [T](a: seq[T], b: seq[T]): seq[T] =
    var c: seq[T] = @[];
    for i in 0..<a.len(): 
        c.add(a[i] + b[i])
    return c
    
proc arrValue*[T](arr: seq[seq[T]], ind: seq[int]): T =
    return arr[ind[0]][ind[1]]


proc nbrs*[T](arr: seq[seq[T]], loc: seq[int], md: char = 'n'): (seq[seq[int]], seq[T]) =
    var dir: seq[seq[int]]
    if md == 'n': dir = @[@[-1, 0], @[0, -1], @[0, 1], @[1, 0]]
    elif md == 'b': dir = @[@[-1, -1], @[-1, 0], @[-1, 1], @[0, -1], @[0, 1], @[1, -1], @[1, 0], @[1, 1]]
    elif md == 'd': dir = @[@[-1, -1], @[-1, 1], @[1, -1], @[1, 1]]
    for i in dir:
        let tmp = loc + i
        if (tmp[0] != -1 and tmp[1] != -1 and tmp[0] <= arr.high and tmp[1] <= arr[0].high):
            result[0] &= tmp
            result[1] &= arrValue(arr, tmp)
    
proc getDiagonals*[T](matrix: seq[seq[T]]): seq[seq[T]] =
    let rows = matrix.len
    let cols = if rows > 0: matrix[0].len else: 0

    for k in 0..<rows:
        var diagonal: seq[T] = @[]
        for i in 0..min(rows - k, cols) - 1:
            diagonal &= (matrix[k + i][i])
        if diagonal.len > 0:
            result &= (diagonal)

    for k in 1..<cols:
        var diagonal: seq[T] = @[]
        for i in 0..min(rows, cols - k) - 1:
            diagonal &= (matrix[i][k + i])
        if diagonal.len > 0:
            result &= (diagonal)

    for k in 0..<rows:
        var diagonal: seq[T] = @[]
        for i in 0..min(rows - k, cols) - 1:
            diagonal &= (matrix[k + i][cols - 1 - i])
        if diagonal.len > 0:
            result &= (diagonal)

    for k in 1..<cols:
        var diagonal: seq[T] = @[]
        for i in 0..min(rows, cols - k) - 1:
            diagonal &= (matrix[i][cols - 1 - (k + i)])
        if diagonal.len > 0:
            result &= (diagonal)

proc getCols*[T](matrix: seq[seq[T]]): seq[seq[T]] =
    for c_ind, c_val in matrix:
        var tmp: seq[T] = @[]
        for r_ind, _ in c_val:
            tmp &= matrix[r_ind][c_ind]
        result &= tmp

proc findMatches*[T](matrix: seq[seq[T]], pattern: string, rev: bool): int =
    let window = pattern.len() - 1
    for c_ind, cval in matrix:
        let r_cval = c_val.reversed()
        for j in 0..<cval.len() - window:
            if cval[j..j+window].join("") == pattern:
                inc result
            if rev:
                if r_cval[j..j+window].join("") == "XMAS":
                    inc result
