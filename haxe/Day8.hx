import Tools;

using hx.strings.Strings;
using Lambda;

typedef MSAV2 = Map<String, Array<Vec2>>;

class Day8 {
    static var slopes: MSAV2 = [];
    static var ants: MSAV2 = [];
    static var mat: AAS = [];
    static var height: Int = 0;
    static var width: Int = 0;
    static function main() {
        parse_file();
        antSlopes(ants);
        var pt1 = solution(mat, ants, slopes, width, height);
        var pt2 = solution2(ants, slopes, width, height);        
        Sys.println('Part 1: ${pt1}\nPart 2: ${pt2}');
    }

    static function parse_file() {
        mat = [for (i in sys.io.File.getContent('input/Day8.txt').trim().split('\r\n')) i.split("")];
        for (r_ind => r_val in mat) {
            for (c_ind => c_val in r_val) {
                if (c_val != ".") {
                    if (!ants.exists(c_val)) ants[c_val] = [];
                    ants[c_val].push({x: r_ind, y: c_ind});
                }
            }
            height = mat.length;
            width = mat[0].length;
        }
    }

    static function antSlopes(ants: MSAV2) {
        for (value in ants) {
            for (i in 0...(value.length - 1)) {
                for (j in (i+1)...value.length) {
                    var str = vecToStr(value[i]);
                    if (!slopes.exists(str)) slopes[str] = [];
                    var a = new Tup(value[i]);
                    slopes[str].push(a - value[j]);
                }
            }
        }
    }

    static function solution(mat: AAS, ants: MSAV2, slopes: MSAV2, width: Int, height: Int) {
        var ttl: Set<String> = new Set([]);
        for (key => value in slopes) {
            for (i in value) {
                var tup_k = new Tup(strToVec(key));
                var tup_i = new Tup(i);
                var symb = fetchVal(mat, strToVec(key));
                var pos = tup_k + i;
                var neg = tup_k - (tup_i * 2);

                if (inBounds(pos, width, height) && fetchVal(mat, pos) != symb) {
                    ttl.push(vecToStr(pos));    
                }
                if (inBounds(neg, width, height) && fetchVal(mat, neg) != symb) {
                    ttl.push(vecToStr(neg));    
                }
            }
        }
        return ttl++.length;
    }

    static function solution2(ants: MSAV2, slopes: MSAV2, width: Int, height: Int) {
        var ttl: Set<String> = new Set([]);
        for (key => value in slopes) {
            ttl.push((key));
            for (i in value) {
                var val = strToVec(key);
                while (true) {
                    val = new Tup(val) + i;
                    if (inBounds(val, width, height)) ttl.push(vecToStr(val));
                    else {
                        val = strToVec(key);
                        break;
                    }
                }
                while (true) {
                    val = new Tup(val) - i;
                    if (inBounds(val, width, height)) ttl.push(vecToStr(val));
                    else break;
                }
            }
        }
        return ttl++.length;
    }
}