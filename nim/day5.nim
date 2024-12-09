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


proc sortArr(arr: SI, tab: HISI): SI =
  var arr = arr
  for i in arr:
    for k in tab.getOrDefault(i, @[]):
      if arr.contains(k):
        let
          i_pos = arr.find(i)
          k_pos = arr.find(k)          
        if i_pos > k_pos:
          (arr[i_pos], arr[k_pos]) = (arr[k_pos], arr[i_pos])
          return sortArr(arr, tab)

  return arr

proc solution(mat: SSI, tab: HISI): (int, int) =
  for i in mat:
    block ordered:
      for j in i:
        for k in tab.getOrDefault(j, @[]):
          if i.contains(k):
            if i.find(j) > i.find(k):
              let 
                 tmp = sortArr(i, tab)
                 n = ((tmp.len() - 1) / 2).int()
              result[1] += tmp[n]
              break ordered
            
      result[0] += i[int((i.len() - 1) / 2)]

let 
  (mat, tab) = readInput()
  (pt1, pt2) = solution(mat, tab)

echo &"Solution 1: {pt1}\nSolution 2: {pt2}"
