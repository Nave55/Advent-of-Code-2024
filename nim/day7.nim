import sequtils, strutils, sugar, strformat

type 
    SI = seq[int]
    SSI = seq[seq[int]]
    
proc readInput(): (SI, SSI) =
    let file = open("input/day7.txt", fmRead);
    defer: file.close()

    for i in file.lines():
      var tmp = i.replace(" ", ",").split(":,")
      result[0] &= tmp[0].parseInt()
      result[1] &= tmp[1].split(",").map(item => item.parseInt())

func concat(a, b: int): int =
  parseInt($a & $b)
      
func evaluate(numbers: SI, target: int, index: int = 0, 
              currentValue: int = 0, pt1: bool = true): bool =
  if index == 0:
    return evaluate(numbers, target, index + 1, numbers[0], pt1)
  
  if index == numbers.len():
    return currentValue == target

  let num = numbers[index]
  if evaluate(numbers, target, index + 1, currentValue + num, pt1):
    return true
  if evaluate(numbers, target, index + 1, currentValue * num, pt1):
    return true
  if not pt1 and evaluate(numbers, target, index + 1, concat(currentValue, num), pt1): 
    return true
  return false

proc solution(a: SI, b: SSI): (int64, int64) =
  for ind, vals in b:
    if evaluate(vals, a[ind]):
      result[0] += a[ind]
    if evaluate(vals, a[ind], pt1 = false):
      result[1] += a[ind]

let (a, b) = readInput()
let (pt1, pt2) = solution(a, b)
  
echo &"Solution 1: {pt1}\nSolution 2: {pt2}"
