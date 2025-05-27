import StringTools.*;
import Std.*;
import Tools;

using hx.strings.Strings;
using Lambda;

class Day6 {
    static var dirs: Array<Vec2> = [{x: -1, y: 0}, {x: 0, y: 1}, {x: 1, y: 0}, {x: 0, y: -1}];
    static var rows = 130;
    static var cols = 130;
    
    static function main() {
        var con = parse_file();
        var s1 = solution(con.mat, con.start);
        var s2 = solution2(con.mat, con.start, con.locs, s1);
        Sys.println('Part 1: ${s1.count()}\nPart 2: ${s2}');
    }

    static function parse_file() {
        var con = [for (i in sys.io.File.getContent('input/Day6.txt').split("\r\n")) i.split("")];
        var start: Vec2 = {x: 0, y: 0};
        var locs: Map<String, Int> = [];  

        for (r_ind => r_val in con) {
            for (c_ind => c_val in r_val) {
                if (c_val == "^") start = {x: r_ind, y: c_ind};
                if (c_val == "#") locs[vecToStr({x: r_ind, y: c_ind})] = 0;
            }
        }
        return {mat: con, start: start, locs: locs}
    }

    static function inbounds(pos: Vec2) {
        return (pos.x > 0 && pos.x < rows - 1) && (pos.y > 0 && pos.y < cols - 1);
    }

    static function solution(mat: AAS, start: Vec2) {
        var facing = 0;
        var pos = start;
        var visited: Map<String, {}> = [];
        while (inbounds(pos)) {
            var v_pos = new Tup(pos);
            var next_pos = v_pos + dirs[facing];
            if (mat[next_pos.x][next_pos.y] == "#") {
                facing++;
                facing = facing % 4;
            } else {
                visited[vecToStr({x: pos.x, y: pos.y})] = {};
                pos = next_pos;
            }
        }
        visited[vecToStr({x: pos.x, y: pos.y})] = {};

        return visited;
    }

    static function solution2(mat: AAS, start: Vec2, locs: Map<String, Int>, empty: Map<String, {}>) {
        var ttl = 0;
        for (i in empty.keys()) {
            var i_vec = strToVec(i);
            var facing = 0;
            var pos = start;
            mat[i_vec.x][i_vec.y] = "#";
            locs[i] = 0;

            while (inbounds(pos)) {
                var v_pos = new Tup(pos);
                var next_pos = v_pos + dirs[facing];
                if (mat[next_pos.x][next_pos.y] == "#") {
                    facing++;
                    locs[vecToStr(next_pos)]++;
                    if (locs[vecToStr(next_pos)] == 4) {
                        // trace('Obstacle was at pos ${i[0]},${i[1]}');
                        ttl++;
                        break;
                    }
                    facing = facing % 4;
                } else pos = next_pos;
            }
            mat[i_vec.x][i_vec.y] = '.';
            for (key in locs.keys()) locs[key] = 0;
            locs.remove(i);
        }

        return ttl;
    }
}
