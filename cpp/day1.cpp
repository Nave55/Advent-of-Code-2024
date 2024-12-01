#include "tools.h"
#include <tl/getlines.hpp>
#include <tl/to.hpp>
#include <fstream>
#include <ranges>
#include <algorithm>
#include <unordered_map>

struct LR {std::vector<int> left {}; std::vector<int> right {};};
struct IntInt {int pt1 {0}; int pt2 {0};};

auto parseFile(const std::string &filename) -> LR;
auto solution(const LR &lr) -> IntInt;

auto main() -> int {
    auto lr = parseFile("input/Day1.txt");
    auto [sum1, sum2] =  solution(lr);
    printf("Part 1: %d\nPart 2: %d", sum1, sum2);
}

auto parseFile(const std::string &filename) -> LR {
    std::ifstream file (filename);
    auto lines = tl::views::getlines(file) | tl::to<std::vector<std::string>>();
    vi left {}, right {};

    for (const auto &i : lines) {
        auto tmp = std::views::split(i, std::string_view("   ")) | tl::to<std::vector<std::string>>();
        left.emplace_back(std::stoi(tmp[0]));
        right.emplace_back(std::stoi(tmp[1]));
    }

    std::sort(left.begin(), left.end());
    std::sort(right.begin(), right.end());

    return {left, right};
}

auto solution(const LR &lr) -> IntInt {
    int sum1 {0}, sum2 {0};
    std::unordered_map<int, int> map {};

    for (size_t i = 0; i < lr.left.size(); ++i) 
        sum1 += abs(lr.left[i] -lr.right[i]);

    for (const auto &i : lr.left) 
        map[i] = 0;

    for (const auto &i : lr.right) 
        if (map.contains(i)) map[i]++;
    
    for (const auto &[k, v] : map) 
        sum2 += k * v;

    return {sum1, sum2};
}
