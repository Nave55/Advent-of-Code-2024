import Std.*;
import Tools;

class Day2 {
    static function main() {
        var sol = solution();
        Sys.println('Part 1: ${sol.pt1}\nPart 2: ${sol.pt2}');
    }

    static function checkSafety(arr: AI): Bool {
        if (arr.length <= 1) return true;
        
        var is_inc_safe = true, is_dec_safe = true;
        for (i in 0...arr.length - 1) {
            if (!is_inc_safe && !is_dec_safe) return false;
            var val = arr[i] - arr[i + 1]; 
            if (is_inc_safe) is_inc_safe = val >= 1 && val <= 3; 
            if (is_dec_safe) is_dec_safe = val <= -1 && val >= -3; 
        }

        return is_inc_safe || is_dec_safe;
    }

    static function checkSafetyTwo(arr: AI): Bool {
        if (checkSafety(arr)) return true;

        for (ind => _ in arr) {
            var tmp = [for (i in arr) i];
            tmp.splice(ind, 1);
            if (checkSafety(tmp)) return true;
        }

        return false;
    }

    static function solution() {
        var con = [for (i in sys.io.File.getContent('input/Day2.txt').split("\r")) [for (j in i.split(" ")) parseInt(j) ?? 0]];
        var ttl = 0, ttl2 = 0;

        for (i in con) {
            if (checkSafety(i)) ttl++;
            if (checkSafetyTwo(i)) ttl2++;
        }

        return {pt1: ttl, pt2: ttl2};
    }
}
