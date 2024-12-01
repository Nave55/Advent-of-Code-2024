import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day1 {
    static function main() {
        var lr = parse_file();
        var pt1 = solution(lr.left, lr.right);
        var pt2 = solution2(lr.left, lr.right);
        Sys.println('Part 1: ${pt1}\nPart 2: ${pt2}');

    }

    static function parse_file() {
        var con = [for (i in sys.io.File.getContent('input/Day1.txt').split("\r")) [for (j in i.split("   ")) parseInt(j)]];
        var left = [for (i in con) i[0]];
        var right = [for (i in con) i[1]];

        left.sort((a, b) -> a - b);
        right.sort((a, b) -> a - b);

        return {left: left, right: right};
    }

    static function solution(left: ANI, right: ANI) {
        var ttl = 0;

        for (i in 0...left.length) {
            ttl += Std.int(Math.abs(left[i] - right[i]));
        }

        return ttl;
    }

    static function solution2(left: ANI, right: ANI) {
        var l_map: MII = [];

        for (i in left) l_map[Std.int(i)] = 0;     
        for (i in right) {
            if (l_map.exists(i)) {
                l_map[i] += 1;
            }
        }

        var ttl = 0;
        for (k => v in l_map) {
            ttl += k * v;
        }

        return ttl;
    }
}
