import sequtils, strformat, tools, tables, sets

type 
    SSC = seq[seq[char]]
    SSI = seq[seq[int]]
    SI = seq[int]
    
proc readInput(): (SSC, SI, SSI, Table[SI, int]) =
    let file = open("input/day6.txt");
    defer: file.close()

    for i in file.lines():
        result[0] &= i.toSeq()

    var locs = initTable[SI, int]()
    
    for r_ind, r_val in result[0]:
      for c_ind, c_val in r_val:
        locs[@[r_ind, c_ind]] = 0     
        if c_val == '^':
          result[1] = @[r_ind, c_ind]
        elif c_val == '.':
          result[2] &= @[r_ind, c_ind]
          
    result[3] = locs
  
var (mat, start, empty, locs) = readInput()
let
  height = mat.len()
  width = mat[0].len()
  dirs = {0: @[-1, 0], 1: @[0, 1], 2: @[1, 0], 3: @[0, -1]}.toTable
    
proc pt1(mat: SSC, start: SI): int =
  var 
    facing = 0
    visited: SSI = @[]
    pos = start
  
  while (pos[0] > 0 and pos[0] < height - 1) and (pos[1] > 0 and pos[1] < width - 1):
    let next_pos = pos + dirs[facing] 
    if arrValue(mat, next_pos) == '#':
      facing += 1
      if facing == 4:
        facing = 0
    else:
      visited &= pos
      pos = next_pos

  return visited.toHashSet().len + 1

proc pt2(mat: var SSC, start: SI, empty: SSI, locs: var Table[SI, int]): int =
  for i in empty:
    var
      facing = 0
      pos = start
      
    mat[i[0]][i[1]] = '#'

    while (pos[0] > 0 and pos[0] < height - 1) and (pos[1] > 0 and pos[1] < width - 1):
      let next_pos = pos + dirs[facing]
      if arrValue(mat, next_pos) == '#':
        facing += 1
        locs[pos] += 1
        if locs[pos] == 3:
          echo "Obstacle was at pos: [", i[0], ",", i[1], "]"  
          inc result
          break
        if facing == 4:
          facing = 0
      else:
        pos = next_pos
        
    for key in locs.keys:
      locs[key] = 0
    mat[i[0]][i[1]] = '.'

let p1 = pt1(mat, start)
let p2 = pt2(mat, start, empty, locs)
echo &"Solution 1: {p1}\nSolution 2: {p2}"
