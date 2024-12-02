import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day2 {
    static function main() {
        var sol = solution();
        Sys.println('Part 1: ${sol.pt1}\nPart 2: ${sol.pt2}');
    }

    static function solver(arr: AI, n: Int, pt1: Bool): Int {
        if (n == arr.length) return 0;

        var tmp = [for (i in arr) i];
        if (!pt1) tmp.splice(n, 1);

        var p = (tmp.length > 1) ? tmp[0] - tmp[1] : 0;

        for (j in 1...tmp.length) {
            var dist = tmp[j - 1] - tmp[j];
            if (p >= 0) {
                if (dist > 3 || dist <= 0) {
                    if (pt1) return 0;
                    break;
                }
                if (j == tmp.length - 1) return 1;
            } else if (p <= 0) {
                if (dist < -3 || dist >= 0) {
                    if (pt1) return 0;
                    break;
                }
                if (j == tmp.length - 1 ) return 1;
            }
        }

        return solver(arr, n + 1, false);
    }

    static function solution() {
        var con = [for (i in sys.io.File.getContent('input/Day2.txt').split("\r")) [for (j in i.split(" ")) parseInt(j) ?? 0]];
        var ttl1 = 0, ttl2 = 0;

        for (i in con) {
            ttl1 += solver(i, 0, true);
            ttl2 += solver(i, 0, false);
        }

        return {pt1: ttl1, pt2: ttl2};
    }
}