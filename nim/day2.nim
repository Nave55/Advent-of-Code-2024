import strutils, strformat, sequtils, sugar

type
    IntSeq = seq[int]

proc readInput(): seq[IntSeq] =
    let file = open("input/day2.txt")
    defer: file.close()

    for i in file.lines():
         result &= i.splitWhitespace().map(item => parseInt(item))
         
let con = readInput()

func solver(arr: IntSeq, n: int, pt1: bool): int =
    if n == arr.len(): return 0

    var tmp = arr
    if not pt1: tmp.delete(n)

    let p = if tmp.len() > 1: tmp[0] - tmp[1] else: 0

    for j in 1..<tmp.len():
        let dist = tmp[j - 1] - tmp[j]
        if p > 0:
            if dist > 3 or dist <= 0:
                if pt1: return 0
                break
            if j == tmp.len() - 1:
                return 1
        elif p < 0:
            if dist < -3 or dist >= 0:
                if pt1: return 0
                break
            if j == tmp.len() - 1:
                return 1

    return solver(arr, n + 1, false)

proc solution(): (int, int) =    
    for i in con:
        result[0] += solver(i, 0, true)
        result[1] += solver(i, 0, false)

let (pt1, pt2) = solution()

echo &"Part 1: {pt1}\nPart 2: {pt2}"