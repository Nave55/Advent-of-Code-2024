#include "tools.h"
#include <tl/getlines.hpp>
#include <tl/to.hpp>
#include <fstream>
#include <ranges>

auto checkSafety(const vi &arr) -> bool {
    if (arr.size() <= 1) return true;

    bool is_inc = true, is_dec = true;
    for (size_t i = 0; i < arr.size() - 1; i++) {
        if (!is_inc && !is_dec) return false;
        int val = arr[i] - arr[i + 1];
        if (is_inc) is_inc = val >= 1 && val <= 3;
        if (is_dec) is_dec = val <= -1 && val >= -3;
    }

    return is_inc || is_dec;
}

auto checkSafetyTwo(const vi &arr) -> bool {
    if (checkSafety(arr)) return true;

    for (size_t i = 0; i < arr.size(); i++) {
        auto tmp = arr;
        tmp.erase(tmp.begin() + i);
        if (checkSafety(tmp)) return true;
    }

    return false;
}

auto solution() -> void {
    std::ifstream file ("input/day2.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector<std::string>>();
    int sum1 {0}, sum2 {0};

    for (const auto &i : lines) {
        auto tmp = i 
            | std::views::split(' ') 
            | std::views::transform([](auto x) {
                return std::stoi(std::string(x.begin(), x.end()));})
            | tl::to<std::vector<int>>();
        
        if (checkSafety(tmp)) sum1++;
        if (checkSafetyTwo(tmp)) sum2++;
    } 

    printf("Part 1: %d\nPart 2: %d\n", sum1, sum2);
}

auto main() -> int {
    solution();
}
