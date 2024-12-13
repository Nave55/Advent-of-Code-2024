import haxe.Int64;
import Tools;
import Std.*;

using hx.strings.Strings;
using Lambda;

class Day9 {
    static function main() {
        var con = parse_file();
        var p1_map = diskMap(con);
        var o_disk = orderDisk(p1_map.u_disk, p1_map.locs);
        var o_disk2 = orderDisk2(p1_map.u_disk, p1_map.locs);
        var pt1 = solution(o_disk);
        var pt2 = solution(o_disk2);
        Sys.println('Part 1: ${pt1}\nPart 2: ${pt2}');
    }

    static inline function parse_file() {
        return [for (i in sys.io.File.getContent('input/Day9.txt').trim().split("")) parseInt(i) ?? 0];
    }

    static function diskMap(str: AI) {
        var tmp = -1;
        var locs: AI = [];
        var u_disk: AI = [];
        for (ind => val in str) {
            for (i in 0...val) {
                tmp++;
                if (ind % 2 == 0) {
                    if (ind == 0) u_disk.push(ind);
                    else u_disk.push(int(ind / 2));
                }
                else locs.push(tmp);
            }
        }
        return {u_disk: u_disk, locs: locs};
    }

    static function orderDisk(d_map: AI, locs: AI) {
        var result = [for (i in d_map) i];
        for (ind => val in locs) {
            if (val < result.length) {
                result.insert(val, result.pop());
            }
        }
        return result;
    }

    static function vallocs(arr: AI, v: Int) {
        var result: AI =  [];
        var tmp = arr.indexOf(v);
        if (tmp != -1) {
            result.push(tmp);
            while (tmp < arr.length - 1) {
                tmp++;
                if (arr[tmp] == v) result.push(tmp);
                else break;
            }
        }
         return result;
    }

    static function movePos(l: AI, arr_pos: AI) {
        var result: AI =[l[0]];
        var ll = [for (i in l) i];
        var outer = false;
        while (ll.length > 1) {
            for (i in 1...(ll.length)) {
                if (result.length >= arr_pos.length) {
                    outer = true;
                    break;
                }
                if (ll[i] - ll[i-1] == 1) result.push(ll[i]);
                else break;
                
            }
            if (outer == true || result.length >= ll.length) break;
            ll = ll.slice(result.length, ll.length);
            result = [ll[0]];
        }
        return result;
    }

    static function orderDisk2(arr: AI, locs: AI) {
        var l = [for (i in locs) i];
        var result = [for (i in arr) i];
        for (i in l) result.insert(i, -1);

        for (v in new ReverseIterator(arr.length - 1, 1)) {
            var arr_pos = vallocs(result, v);
            if (arr_pos.length == 0) continue;
            var start = movePos(l, arr_pos);

            if (start.length >= arr_pos.length) {
                if (start[0] < arr_pos[arr_pos.length - 1]) {
                    for (i in arr_pos) result[i] = -1;
                    for (i in start) result[i] = v;
                }
            }
            l = l.filter(item -> !start.contains(item));
        }

        return result;
    }


    static function solution(o_disk: AI) {
        var result: Int64 = 0;        
        for (ind => val in o_disk) {
            if (val != -1) result += ind * val;
        }
        return result;
    }
}