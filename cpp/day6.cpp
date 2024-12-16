#include "tools.h"
#include <tl/getlines.hpp>
#include <tl/to.hpp>
#include <iostream>
#include <fstream>
#include <unordered_map>
#include <algorithm>
#include <utility>
#include <unordered_set>

typedef std::pair<int, int> pi;
typedef std::vector<pi> vpi;
typedef std::unordered_map<std::string, int> msi;

struct ParseFile {vvc mat {}; msi locs {}; pi start {};};
struct SortArr {vi vals; bool is_sorted;};
const std::unordered_map<int, std::pair<int, int>> dirs {{0, {-1, 0}}, {1, {0, 1}}, {2, {1, 0}}, {3, {0, -1}}};


auto parseFile() -> ParseFile;
auto solution(const vvc &mat, pi pos) -> std::pair<int, std::unordered_set<std::string>>;
auto solution2(vvc &mat, const pi &pos, msi &locs, const std::unordered_set<std::string> &empty) -> int;

auto main() -> int {
    auto [mat, locs, start] = parseFile();
    auto sol1 = solution(mat, start);
    auto pt2 = solution2(mat, start, locs, sol1.second);
    printf("Part 1: %d\nPart 2: %d", sol1.first, pt2); 
}

auto parseFile() -> ParseFile {
    std::ifstream file ("input/day6.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector<std::string>>();

    vvc mat {};
    msi locs {};
    pi start;

    for (size_t i {0}; i < lines.size(); ++i) {
        vc tmp {};
        for (size_t j {0}; j < lines[0].size(); ++j) {
            auto pair = std::make_pair(i, j);
            if (lines[i][j] == '^') start = pair;
            if (lines[i][j] == '#') locs[pairToStr(pair)] = 0;
            tmp.push_back(lines[i][j]);
        }
        mat.emplace_back(tmp);
    }

    return {mat, locs,start};
}

auto solution(const vvc &mat, pi pos) -> std::pair<int, std::unordered_set<std::string>> {
    auto facing = 0;
    std::unordered_set<std::string> visited;
    while ((pos.first > 0 && static_cast<size_t>(pos.first) < mat.size() -1) && (pos.second > 0 && static_cast<size_t>(pos.second) < mat[0].size() - 1)) {
        auto n_pos = dirs.at(facing) + pos;
        if (arrValue(mat, n_pos) == '#') {
            facing++;
            if (facing == 4) facing = 0;
        }
        else {
            visited.emplace(pairToStr(pos));
            pos = n_pos;
        }
    }
    visited.emplace(pairToStr(pos));

    return std::make_pair(static_cast<int>(visited.size()), visited);
}

auto solution2(vvc &mat, const pi &start, msi &locs, const std::unordered_set<std::string> &empty) -> int {
    auto ttl = 0;

    for (auto i_val : empty) {
        // std::cout << i_val << std::endl;
        auto i = strToPair<int>(i_val);
        auto facing = 0;
        auto pos = start;
        mat[i.first][i.second] = '#';
        locs[i_val] = 0;
        while ((pos.first > 0 && static_cast<size_t>(pos.first) < mat.size() -1) && (pos.second > 0 && static_cast<size_t>(pos.second) < mat[0].size() - 1)) {
            auto n_pos = dirs.at(facing) + pos;
            auto n_pos_s = pairToStr(n_pos);
            if (arrValue(mat, n_pos) == '#') {
                facing++;
                locs[n_pos_s]++;
                if (locs[n_pos_s] == 4) {
                    std::cout << "Obstacle was at pos" << i << std::endl;
                    ttl++;
                    break;
                }
                if (facing == 4) facing = 0;
            }
            else pos = n_pos;
        }
        mat[i.first][i.second] = '.';
        for (auto it = locs.begin(); it != locs.end(); ++it) {
            locs[it->first] = 0;
        }
        locs.erase(i_val);   
    }
    return ttl;
}
