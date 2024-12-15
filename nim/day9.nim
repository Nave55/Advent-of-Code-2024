import sequtils, strutils, sugar, tables, algorithm, strformat

type
  SI = seq[int]
  HISI = Table[int, SI]
  Info = object
    top: int
    m_spaces: int
    size: int

proc readInput: SI =
  result = readFile("input/day9.txt")
          .multiReplace({ "\r": "", "\n": "" })
          .map(item => ord(item) - ord('0'))

proc diskMap(str: SI): (HISI, HISI, Info) =
  result[0][-1] = @[]
  var tmp = -1
  var contig = 0
  for ind, val in str:
    let v = ind div 2
    discard result[0].hasKeyOrPut(v, @[])
    for i in 0..<val:
      inc tmp
      if ind mod 2 == 0:
        result[0][v] &= tmp
      else:
        result[0][-1].insert(tmp, 0)
        inc contig
    if ind mod 2 == 0 and val > 0:
      if contig > 0:
        let p = tmp - val - contig + 1
        discard result[1].hasKeyOrPut(contig, @[])
        result[1][contig].insert(p, 0)
      contig = 0
    elif val > 0:
      result[2].m_spaces = max(result[2].m_spaces, val)
    result[2].top = max(result[2].top, v)
  result[2].size = tmp 
  for i in 0..<result[2].m_spaces:
    discard result[1].hasKeyOrPut(i, @[])

proc orderDisk(p: HISI, info: Info): SI =
  var pos = p
  result = collect: 
    for i in 0..info.size: -1
  for i in 0..info.top:
    for j in pos[i]:
      result[j] = i
  for i in countdown(result.len() - 1, 0):
    if result[i] != -1 and pos[-1].len() > 0:
      let popped = pos[-1].pop()
      if popped < i:
        result[i].swap(result[popped])

proc orderDisk2(pos: HISI, e: HISI, info: Info): SI =
  var empty = e
  var n_pos = pos
  for i in countdown(info.top, 1):
    var l = pos[i].len()
    var lowest = info.size
    for j in l..info.top:
      discard empty.hasKeyOrPut(j, @[])
      if empty[j].len() > 0 and empty[j][^1] < lowest:
        l = j
        lowest = empty[j][^1]
    if empty[l].len() == 0: continue
    if empty.hasKey(l) and pos[i].len() > 0 and empty[l][^1] < pos[i][0]:
      let popped = empty[l].pop()
      let dif = l - n_pos[i].len()
      var tmp = collect: 
        for k in popped..<popped + l - dif: k
      empty[dif] &= popped + l - dif
      empty[dif].sort((a, b) => cmp(b, a))
      n_pos[i] = tmp

  result = collect: 
    for i in 0..<info.size: -1
  for i in 0..info.top:
    if n_pos[i].len() > 0:
      for j in n_pos[i]:
        result[j] = i

func solution(o_disk: SI): int =
  for ind, val in o_disk:
    if val != -1:
      result += ind * val

let
  s_seq = readInput()
  (pos, empty, info) = diskMap(s_seq)
  o_disk1 = orderDisk(pos, info)
  o_disk2 = orderDisk2(pos, empty, info)
  pt1 = solution(o_disk1)
  pt2 = solution(o_disk2)

echo &"Part 1: {pt1}\nPart 2: {pt2}"
