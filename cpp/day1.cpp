#include "tools.h"
#include <tl/getlines.hpp>
#include <tl/to.hpp>
#include <fstream>
#include <ranges>
#include <algorithm>
#include <unordered_map>

struct Pt1Pt2 {int pt1 {0}; int pt2 {0};};
auto solution() -> Pt1Pt2;

auto main() -> int {
    auto [sum1, sum2] =  solution();
    printf("Part 1: %d\nPart 2: %d", sum1, sum2);
}

auto solution() -> Pt1Pt2 {
    std::ifstream file ("input/Day1.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector<std::string>>();
    vi left {}, right {};

    for (const auto &i : lines) {
        auto tmp = std::views::split(i, std::string_view("   ")) | tl::to<std::vector<std::string>>();
        left.emplace_back(std::stoi(tmp[0]));
        right.emplace_back(std::stoi(tmp[1]));
    }

    std::sort(left.begin(), left.end());
    std::sort(right.begin(), right.end());

    int sum1 {0}, sum2 {0};
    std::unordered_map<int, int> map {};

    for (const auto &i : left) map[i] = 0;

    for (size_t i = 0; i < left.size(); ++i) {
        sum1 += abs(left[i] - right[i]);
        if (map.contains(right[i])) sum2 += right[i];
    }

    return {sum1, sum2};
}
