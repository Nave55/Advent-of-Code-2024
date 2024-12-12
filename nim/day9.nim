import sequtils, strformat, strutils, sugar 
type 
    TI = tuple[x, y: int]
    SI = seq[int]

proc readInput: SI  =
    result = readFile("input/day9.txt")
            .multiReplace({ "\r": "", "\n": "" })
            .map(item => ord(item) - ord('0'))

proc diskMap(str: SI): (SI, SI) =
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
  
proc orderDisk(d_map, locs: SI): SI =
  result = d_map
  for ind, val in locs:
    if val < result.len():
      result.insert(result.pop(), val)

proc tester(arr, locs: SI): SI =
  var 
    b = arr
    l = locs
    
  for i in l:
    b.insert(-1, i)
    
  for v in countdown(arr[^1],1):
    var arr_pos = collect:
      for i in countdown(b.len() - 1, 0):
        if b[i] == -1: continue
        if b[i] == v:
          i
          
    if arr_pos.len() == 0: continue

    var start = @[l[0]]
    block outer:
      var ll = l
      while ll.len() > 1:
        for i in 1..<ll.len():
          if start.len() >= arr_pos.len():
            break outer
          if ll[i] - ll[i - 1] == 1:
            start &= ll[i]
          else:
            break

        if start.len() >= ll.len():
          break
        ll = ll[start.len()..^1]
        start = @[ll[0]]


    if start.len() >= arr_pos.len():
      if start[0] < arr_pos[^1]:
        for i in arr_pos:
          b[i] = -1
        for i in start:
          b[i] = v
        
      l = l.filterIt(it notin start)
      # echo v, " ", start, " ", arr_pos, "\n"

  return b
    
proc solution(o_disk: SI): int64 =
  for ind, val in o_disk:
    if val != -1:
      result += ind * val

let s_seq = readInput()
let (u_disk, locs) = diskMap(s_seq)
let pt2_disk = tester(u_disk, locs)

# let o_disk = orderDisk(u_disk, locs)
# let pt1 = solution(o_disk)
# echo &"Solution 1: {pt1}\nSolution 2: {pt2}"
# echo u_disk, "\n\n", locs, "\n\n"
# echo pt2_disk
# echo locs
echo solution(pt2_disk)
