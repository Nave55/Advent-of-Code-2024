import strutils, strformat, algorithm, sequtils, sets

proc readInput(): (seq[int], seq[int]) =
    let file = open("input/Day1.txt")
    defer: file.close()

    for i in file.lines():
        let lr = map(i.split("   "), proc(x: string): int = parseInt(x))

        result[0] &= lr[0]
        result[1] &= lr[1]

    result[0].sort()
    result[1].sort()
    return result

let (l, r) = readInput()
let left = l.toHashSet()
var 
    sum1 = 0
    sum2 = 0

for i in 0..<l.len:
    sum1 += abs(l[i] - r[i])

for i in r:
    if left.contains(i):
        sum2 += i

echo &"Part 1: {sum1}\nPart 2: {sum2}"
