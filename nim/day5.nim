import sequtils, strutils, sugar, strformat, tables

type 
    SI = seq[int]
    SSI = seq[SI]
    HISI = Table[int, SI]
    
proc readInput(): (SSI, HISI) =
    let file = open("input/day5.txt", fmRead);
    defer: file.close()
  
    for i in file.lines():
      var t_map: SI = @[]
      if i != "" and i.contains("|"):
        t_map = i.split("|").map(item => item.parseInt())
        discard result[1].hasKeyOrPut(tmap[0], @[])
        result[1][t_map[0]] &= tmap[1]
      if i != "" and i.contains(","):
        result[0] &= i.split(",").map(item => item.parseInt())

proc sortArr(arr: SI, tab: HISI, sorted: bool = true): (SI, bool) =
  var arr = arr
  for i in arr:
    for k in tab.getOrDefault(i, @[]):
      if arr.contains(k):
        let
          i_pos = arr.find(i)
          k_pos = arr.find(k)          
        if i_pos > k_pos:
          (arr[i_pos], arr[k_pos]) = (arr[k_pos], arr[i_pos])
          return sortArr(arr, tab, false)
  return (arr, sorted)

proc solution(mat: SSI, tab: HISI): (int, int) =
  for i in mat:
      let 
         (arr, sorted) = sortArr(i, tab)
         n = ((arr.len() - 1) / 2).int()
      if sorted: 
        result[0] += arr[int((arr.len() - 1) / 2)]
      else:          
        result[1] += arr[n]

let 
  (mat, tab) = readInput()
  (pt1, pt2) = solution(mat, tab)

echo &"Solution 1: {pt1}\nSolution 2: {pt2}"
