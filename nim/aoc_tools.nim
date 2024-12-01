proc `+`* [T](a: seq[T], b: seq[T]): seq[T] =
    var c: seq[T] = @[];
    for i in 0..<a.len(): 
        c.add(a[i] + b[i])
    return c
    
proc arrValue*[T](arr: seq[seq[T]], ind: seq[int]): T =
    return arr[ind[0]][ind[1]]

proc nbrs*[T](arr: seq[seq[T]], loc: seq[int], diag: bool = false): (seq[seq[int]], seq[T]) =
    var dir: seq[seq[int]]
    if (not diag): dir = @[@[-1, 0], @[0, -1], @[0, 1], @[1, 0]]
    else: dir = @[@[-1, -1], @[-1, 0], @[-1, 1], @[0, -1], @[0, 1], @[1, -1], @[1, 0], @[1, 1]]
    var indices: seq[seq[int]]
    var vals: seq[T]
    for i in dir:
        let tmp = loc + i
        if (tmp[0] != -1 and tmp[1] != -1 and tmp[0] <= arr.high and tmp[1] <= arr[0].high):
            indices &= tmp
            vals &= arrValue(arr, tmp)
        
    
    return (indices, vals)