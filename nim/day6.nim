import sequtils, strformat, tools, tables, sets

type 
    SSC = seq[seq[char]]
    SI = seq[int]
    TSI = Table[SI, int]
    HSI = HashSet[SI]
    
proc readInput(): (SSC, SI, TSI) =
    let file = open("input/day6.txt");
    defer: file.close()

    for i in file.lines():
        result[0] &= i.toSeq()

    for r_ind, r_val in result[0]:
      for c_ind, c_val in r_val:
        result[2][@[r_ind, c_ind]] = 0     
        if c_val == '^':
          result[1] = @[r_ind, c_ind]
          
var (mat, start, locs) = readInput()
let
  height = mat.len() - 1 
  width = mat[0].len() - 1
  dirs = {0: @[-1, 0], 1: @[0, 1], 2: @[1, 0], 3: @[0, -1]}.toTable
    
proc pt1(mat: SSC, start: SI): (int, HSI) =
  var 
    facing = 0
    pos = start
  
  while (pos[0] in 1..<height) and (pos[1] in 1..<width):
    let next_pos = pos + dirs[facing] 
    if arrValue(mat, next_pos) == '#':
      facing += 1
      if facing == 4:
        facing = 0
    else:
      result[1].incl(pos)
      pos = next_pos

  result[0] = result[1].len + 1

proc pt2(mat: var SSC, start: SI, empty: HSI, locs: var TSI): int =
  for i in empty:
    mat[i[0]][i[1]] = '#'
    var
      facing = 0
      pos = start
      
    while (pos[0] in 1..<height) and (pos[1] in 1..<width):
      let next_pos = pos + dirs[facing]
      if arrValue(mat, next_pos) == '#':
        facing += 1
        locs[pos] += 1
        if locs[pos] == 3:
          echo &"Obstacle was at pos: [{i[0]},{i[1]}]" 
          inc result
          break
        if facing == 4:
          facing = 0
      else:
        pos = next_pos
        
    mat[i[0]][i[1]] = '.'
    for key in locs.keys:
      locs[key] = 0

let 
  (p1, empty) = pt1(mat, start)
  p2 = pt2(mat, start, empty, locs)
echo &"Solution 1: {p1}\nSolution 2: {p2}"
