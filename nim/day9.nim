import sequtils, strformat, strutils, sugar 
type SI = seq[int]

proc readInput: SI  =
    result = readFile("input/day9.txt")
            .multiReplace({ "\r": "", "\n": "" })
            .map(item => ord(item) - ord('0'))

func diskMap(str: SI): (SI, SI) =
  var tmp = -1
  for ind, val in str:
    for i in 0..<val:
      inc tmp
      if ind %% 2 == 0:
        if ind == 0: 
          result[0] &= ind
        else: 
          result[0] &= int(ind / 2)
      else:
        result[1] &= tmp

func valLocs(arr: SI, v: int): SI =
  result = collect:
    for i in countdown(arr.len() - 1, 0):
      if arr[i] == -1: continue
      if arr[i] == v:
        i

func movePos(l, arr_pos: SI): SI =
  result = @[l[0]]
  block outer:
    var ll = l
    while ll.len() > 1:
      for i in 1..<ll.len():
        if result.len() >= arr_pos.len():
          break outer
        if ll[i] - ll[i - 1] == 1:
          result &= ll[i]
        else:
          break

      if result.len() >= ll.len():
        break
      ll = ll[result.len()..^1]
      result = @[ll[0]]
  
func orderDisk(d_map, locs: SI): SI =
  result = d_map
  for ind, val in locs:
    if val < result.len():
      result.insert(result.pop(), val)

func orderDisk2(arr, locs: SI): SI =
  var l = locs
  result = arr
  
  for i in l:
    result.insert(-1, i)
    
  for v in countdown(arr[^1], 1):
    var arr_pos = valLocs(result, v)   
    if arr_pos.len() == 0: continue
    var start = movePos(l, arr_pos)

    if start.len() >= arr_pos.len():
      if start[0] < arr_pos[^1]:
        for i in arr_pos:
          result[i] = -1
        for i in start:
          result[i] = v
        
      l = l.filterIt(it notin start)
      # echo v, " ", start, " ", arr_pos, "\n"

func solution(o_disk: SI): int64 =
  for ind, val in o_disk:
    if val != -1:
      result += ind * val

let 
  s_seq = readInput()
  (u_disk, locs) = diskMap(s_seq)
  o_disk = orderDisk(u_disk, locs)
  o_disk2 = orderDisk2(u_disk, locs)
  pt1 = solution(o_disk)
  pt2 = solution(o_disk2)

echo &"Part 1: {pt1}\nPart 2: {pt2}"
