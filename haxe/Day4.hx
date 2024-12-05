import Tools;

using hx.strings.Strings;
using Lambda;



class Day4 {
    static function main() {
        var con = parse_file();
        var pt1 = checkXmas(con);
        var pt2 = checkX(con);
        Sys.println('Part 1: ${pt1}\nPart 2: ${pt2}');
    }

    static inline function parse_file() {
        return [for (i in sys.io.File.getContent('input/Day4.txt').split("\r")) i.trim().toChars()];
    }

    static function checkXmas(mat: AAC) {
        var width = mat[0].length, height = mat.length;
        var dirs: AAI = [
            [-3, -3], [-2, -2], [-1, -1], [-3, 3], [-2, 2], [-1, 1], 
            [3, -3], [2, -2], [1, -1], [3, 3], [2, 2], [1, 1],
            [-3, 0], [-2, 0], [-1, 0], [3, 0], [2, 0], [1, 0],
            [0, -3], [0, -2], [0, -1], [0, 3], [0, 2], [0, 1]
        ];
    
        var valid_inds: AAI = [];
        for (r_ind => r_val in mat) {
            for (c_ind => c_val in r_val) {
                var tmp = [r_ind, c_ind];
                if (c_val == 'X') valid_inds.push(tmp);
            }
        }
        
        var ttl = 0, cnt = 0; 
        for (v in valid_inds) {
            var str = "";
            for (val in dirs) {
                cnt++;
                var vec = new Vec(v);
                var loc = vec + [val[0], val[1]];
                if  ((loc[0] >= 0 && loc[0] < height) && (loc[1] >= 0 && loc[1] < width)) {
                    str += mat[loc[0]][loc[1]];
                }
                if (cnt % 3 == 0) {
                    str += "X";
                    if (str == "XMAS" || str == "SAMX") ttl++; 
                    str = "";
                }
            }
        }
        return ttl;
    }  

    static function checkX(mat: AAC) {
        var ttl = 0;
        var valid_inds: AAI = [];
        for (r_ind => r_val in mat) {
            for (c_ind => c_val in r_val) {
                if (c_val == 'A') valid_inds.push([r_ind, c_ind]);
            }
        }
        for (i in valid_inds) {
            var vals = Tools.nbrs(mat, [i[0], i[1]], "diag").vals.map(item -> item.toString()).join("");
            if (["MMSS", "SSMM", "SMSM", "MSMS"].contains(vals)) ttl++;
        }
	return ttl;
    }
}