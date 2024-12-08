import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day6 {
    static var dirs = [0 => [-1, 0], 1 => [0, 1], 2 => [1, 0], 3 => [0, -1]];
    static function main() {
        var con = parse_file();
        var s1 = solution(con.mat, con.start);
        var s2 = solution2(con.mat, con.start, con.locs, s1.visited);
        Sys.println('Part 1: ${s1.ttl}\nPart 2: ${s2}');
    }

    static function parse_file() {
        var con = [for (i in sys.io.File.getContent('input/Day6.txt').split("\r\n")) i.split("")];
        var start: AI = [];
        var locs: Map<String, Int> = [];  


        for (r_ind => r_val in con) {
            for (c_ind => c_val in r_val) {
                if (c_val == "^") start = [r_ind, c_ind];
                if (c_val == "#") locs['${r_ind},${c_ind}'] = 0;
            }
        }
        return {mat: con, start: start, locs: locs}
    }

    static function solution(mat: AAS, start: AI) {
        var facing = 0;
        var pos = start;
        var visited: Set<String> = new Set([]);
        while ((pos[0] > 0 && pos[0] < mat.length -1) && pos[1] > 0 && pos[1] < mat[0].length - 1) {
            var v_pos = new Vec(pos);
            var next_pos = v_pos + dirs[facing];
            if (arrValue(mat, next_pos) == '#') {
                facing++;
                if (facing == 4) facing = 0;
            }
            else {
                visited.push('${pos[0]},${pos[1]}');
                pos = next_pos;
            }
        }
        visited.push('${pos[0]},${pos[1]}');

        return {ttl: visited.rtrnArray().length, visited: visited};
    }


    static function solution2(mat: AAS, start: AI, locs: Map<String, Int>, empty: Set<String>) {
        var ttl = 0;
        for (i_val in empty.rtrnArray()) {
            var i = i_val.split(',').map(item -> parseInt(item) ?? 0);
            var facing = 0;
            var pos = start;
            mat[i[0]][i[1]] = "#";
            locs[i_val] = 0;

            while ((pos[0] > 0 && pos[0] < mat.length -1) && pos[1] > 0 && pos[1] < mat[0].length - 1) {
                var v_pos = new Vec(pos);
                var next_pos = v_pos + dirs[facing];
                var n_pos_s = '${next_pos[0]},${next_pos[1]}';
                if (arrValue(mat, next_pos) == "#") {
                    facing++;
                    locs[n_pos_s]++;
                    if (locs[n_pos_s] == 4) {
                        trace('Obstacle was at pos ${i[0]},${i[1]}');
                        ttl++;
                        break;
                    }
                    if (facing == 4) facing = 0;
                }
                else pos = next_pos;
            }
            mat[i[0]][i[1]] = '.';
            for (key in locs.keys()) locs[key] = 0;
            locs.remove(i_val);
        }

        return ttl;
    }
}
