import strutils, sequtils, strformat, tools

type 
    SC = seq[seq[char]]
    SI = seq[seq[int]]
    
proc readInput(): SC =
    let file = open("input/day4.txt");
    defer: file.close()

    for i in file.lines():
        result &= i.toSeq()
    
proc checkXmas(matrix: SC): int =
    let
        width = matrix[0].len()
        height = matrix.len()
        dirs = [ (-3, -3), (-2, -2), (-1, -1), (-3, 3), (-2, 2), (-1, 1), 
                 (3, -3),  (2, -2),  (1, -1),  (3, 3),  (2, 2),  (1, 1), 
                 (-3, 0),  (-2, 0),  (-1, 0),  (3, 0),  (2, 0),  (1, 0), 
                 (0, -3),  (0, -2),  (0, -1),  (0, 3),  (0, 2),  (0, 1) ]

    var valid_inds: SI = @[]
    for r_ind, r_val in matrix:
        for c_ind, c_val in r_val:
            if c_val == 'X':
                valid_inds &= @[r_ind, c_ind]

    var cnt = 0
    for v in valid_inds:
        var str = ""
        for (x, y) in dirs:
            inc cnt
            let tmp = @[x, y] + v
            if (tmp[0] >= 0 and tmp[0] < height) and (tmp[1] >= 0 and tmp[1] < width):
                str = str & arrValue(matrix, tmp)
            if cnt %% 3 == 0:
                str &= "X"
                if str == "XMAS" or str == "SAMX":
                    inc result     
                str = ""

proc checkX(matrix: SC): int =
    var valid: SI = @[]
    for r_ind, r_val in matrix:
        for c_ind, c_val in r_val:
            if c_val == 'A':
                valid &= @[r_ind, c_ind] 
    
    for i in valid:
        let tmp = nbrs(matrix, @[i[0], i[1]], 'd')[1].join("")
        if tmp in ["MMSS", "SSMM", "SMSM", "MSMS"]:
            inc result

let hori = readInput()
let (pt1 , pt2) = (checkXmas(hori), checkX(hori))

echo &"Solution 1: {pt1}\nSolution 2: {pt2}"