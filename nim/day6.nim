import sequtils, strformat, tools, tables, sets

type 
    SSC = seq[seq[char]]
    TI = tuple[x, y: int]
    TSI = Table[TI, int]
    HSI = HashSet[TI]
    
proc readInput(): (SSC, TI, TSI) =
    let file = open("input/day6.txt");
    defer: file.close()

    for i in file.lines():
        result[0] &= i.toSeq()

    for r_ind, r_val in result[0]:
      for c_ind, c_val in r_val:
        if c_val == '^':
          result[1] = (r_ind, c_ind)
        if c_val == '#':
          result[2][(r_ind, c_ind)] = 0
          
var (mat, start, locs) = readInput()
let
  width = mat[0].len() - 1
  height = mat.len() - 1 
  dirs = {0: (-1, 0), 1: (0, 1), 2: (1, 0), 3: (0, -1)}.toTable
  
proc pt1(mat: SSC, start: TI): (int, HSI) =
  var 
    facing = 0
    pos = start
  
  while (pos[0] in 1..<height) and (pos[1] in 1..<width):
    let next_pos = pos + dirs[facing] 
    if fetchVal(mat, next_pos) == '#':
      inc facing
      if facing == 4:
        facing = 0
    else:
      result[1].incl(pos)
      pos = next_pos
      
  result[1].incl(pos)
  result[0] = result[1].len()

proc pt2(mat: var SSC, start: TI, empty: HSI, locs: var TSI): int =
  for i in empty:
    var
      facing = 0
      pos = start
    mat[i.x][i.y] = '#'
    locs[i] = 0
      
    while (pos[0] in 1..<height) and (pos[1] in 1..<width):
      let next_pos = pos + dirs[facing]
      if fetchVal(mat, next_pos) == '#':
        inc facing 
        inc locs[next_pos]
        if locs[next_pos] == 5:
          echo &"Obstacle was at pos: [{i.tupToStr()}]" 
          inc result
          break
        if facing == 4:
          facing = 0
      else:
        pos = next_pos
        
    mat[i.x][i.y] = '.'
    for key in locs.keys:
      locs[key] = 0
    locs.del(i)

let 
  (p1, empty) = pt1(mat, start)
  p2 = pt2(mat, start, empty, locs)
echo &"Solution 1: {p1}\nSolution 2: {p2}"
