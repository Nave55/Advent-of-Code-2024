#include "tools.h"
#include <tl/getlines.hpp>
#include <tl/to.hpp>
#include <fstream>
#include <ranges>
#include <array>

struct Pt1Pt2 {int pt1 {0}; int pt2 {0};};
auto solution() -> Pt1Pt2;

auto main() -> int {
    auto [sum1, sum2] = solution();
    printf("Part 1: %d\nPart 2: %d", sum1, sum2);
}

auto checkXmas(std::vector<vs> mat) -> int {
    auto width = mat[0].size();
    auto height = mat.size();

    std::array<std::array<int, 2>, 24> dirs = {{
        {-3, -3}, {-2, -2}, {-1, -1}, {-3, 3}, {-2, 2}, {-1, 1}, 
        {3, -3}, {2, -2}, {1, -1}, {3, 3}, {2, 2}, {1, 1}, 
        {-3, 0}, {-2, 0}, {-1, 0}, {3, 0}, {2, 0}, {1, 0}, 
        {0, -3}, {0, -2}, {0, -1}, {0, 3}, {0, 2}, {0, 1}
    }};

    std::vector<std::array<int, 2>> valid_inds {};
    for (size_t i = 0; i < height; i++) {
        for (size_t j = 0; j < width; j++) {
            std::array<int, 2> tmp = {(int) i, (int) j};
            if (mat[i][j] == "X") {
                valid_inds.emplace_back(tmp);
            }
        }
    }

    auto ttl = 0, cnt = 0;
    for (const auto &v : valid_inds) {
        std::string str {};
        for (const auto &val : dirs) {
            cnt++;
            auto tmp = val + v;
            if (tmp[0] >= 0 && (size_t) tmp[0] < height && tmp[1] >= 0 && (size_t) tmp[1] < width) {
                str += mat[tmp[0]][tmp[1]];
            }
            if (cnt % 3 == 0) {
                str += "X";
                if (str == "XMAS" || str == "SAMX")  ttl++;
                str = "";
            }
        }
    }

    return ttl;
}

auto checkX(std::vector<vs> mat) -> int {
    std::vector<std::array<int, 2>> valid_inds {};
    for (size_t i = 0; i < mat.size(); i++) {
        for (size_t j = 0; j < mat[0].size(); j++) {
            std::array<int, 2> tmp = {(int) i, (int) j};
            if (mat[i][j] == "A") {
                valid_inds.emplace_back(tmp);
            }
        }
    }

    auto ttl = 0;
    for (const auto &v : valid_inds) {
        auto n = nbrs<int, std::string, 4>(mat, v, 'd');
        auto tmp = tJoin(n.vals);
        if (tmp == "MMSS" || tmp == "SSMM" || tmp == "SMSM" || tmp == "MSMS")
            ttl++;
    }
    return ttl;
}

auto solution() -> Pt1Pt2 {
    std::ifstream file ("input/day4.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector<std::string>>();
    std::vector<vs> arr;
    
    for (const auto &i : lines) {
        auto a  = i
            | std::views::split(std::string_view(""))
            | tl::to<vs>();
        arr.emplace_back(a);
    }

    auto a = checkXmas(arr);
    auto b = checkX(arr);

    return {a, b};
}
