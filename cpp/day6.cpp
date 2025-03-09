#include "tools.h"
#include <iostream>
#include <fstream>
#include <unordered_map>
#include <unordered_set>
#include <cassert>

struct pair_hash {
    template <class T1, class T2>
    std::size_t operator()(const std::pair<T1, T2>& pair) const {
        std::size_t h1 = std::hash<T1>()(pair.first);
        std::size_t h2 = std::hash<T2>()(pair.second);
        return h1 ^ (h2 * 31); // Use a prime multiplier
    }
};

typedef std::pair<int, int> pi;
typedef std::unordered_map<pi, int, pair_hash> mpi;
typedef std::unordered_map<int, std::pair<int, int>> mipi;
typedef std::unordered_set<std::pair<int, int>, pair_hash> spi;

constexpr int ROWS = 130;
constexpr int COLS = 130;
const mipi dirs {{0, {-1, 0}}, {1, {0, 1}}, {2, {1, 0}}, {3, {0, -1}}};
char mat[ROWS][COLS] {{'.'}};
struct ParseFile {mpi locs; pi start;};

auto parseFile() -> ParseFile;
auto solution(pi) -> spi;
auto solution2(const pi&, mpi&, const spi&) -> int;

auto main() -> int {
    auto [locs, start] = parseFile();
    
    auto sol1 = solution(start);
    auto pt2 = solution2(start, locs, sol1);
    printf("Part 1: %d\nPart 2: %d", (int)sol1.size(), pt2); 
}

auto parseFile() -> ParseFile {
    mpi locs;
    pi start;
    
    std::ifstream file ("input/day6.txt");
    assert(file);
    std::string line;
    size_t i {0};
    while (std::getline(file, line)) {    
        for (size_t j {0}; j < ROWS; ++j) {
            if (line[j] == '#' || line[j] == '^') mat[i][j] = line[j];
            auto pair = std::make_pair(i, j);
            if (line[j] == '^') start = pair;
            if (line[j] == '#') locs[pair] = 0;
        }
        ++i;         
    }
    
    return {locs, start};
}

auto inbounds(const pi &pos) -> bool {
    return ((pos.first > 0 && pos.first < ROWS - 1) && (pos.second > 0 && pos.second < COLS - 1));
}

auto solution(pi pos) -> spi {
    auto facing = 0;
    spi visited;
    
    while (inbounds(pos)) {
        auto n_pos = dirs.at(facing) + pos;
        if (mat[n_pos.first][n_pos.second] == '#') {
            facing++;
            facing = facing % 4;
        } else {
            visited.emplace(pos);
            pos = n_pos;
        }
    }
    visited.emplace(pos);
    
    return visited;
}

auto solution2(const pi &start, mpi &locs, const spi &empty) -> int {
    auto ttl = 0;

    for (auto &i : empty) {
        auto facing = 0;
        auto pos = start;
        mat[i.first][i.second] = '#';
        locs[i] = 0;

        while (inbounds(pos)) {
            auto n_pos = dirs.at(facing) + pos;;
            if (arrValue(mat, n_pos) == '#') {
                facing++;
                locs[n_pos]++;
                if (locs[n_pos] == 4) {
                    // std::cout << "Obstacle was at pos " << i << "\n";
                    ttl++;
                    break;
                }
                facing = facing % 4;
            }
            else pos = n_pos;
        }
        mat[i.first][i.second] = '.';
        locs.erase(i);   
        for (auto it = locs.begin(); it != locs.end(); ++it) {
            locs[it->first] = 0;
        }
    }
    return ttl;
}
