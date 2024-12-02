#include "tools.h"
#include <tl/getlines.hpp>
#include <tl/to.hpp>
#include <fstream>
#include <ranges>

struct Pt1Pt2 {int pt1 {0}; int pt2 {0};};
auto solution() -> Pt1Pt2;

auto main() -> int {
    auto [sum1, sum2] = solution();
    printf("Part 1: %d\nPart 2: %d", sum1, sum2);
}

auto solver(const vi &arr, bool pt1, size_t n = 0) -> int {
    if (n == arr.size()) return 0;

    auto tmp = arr;
    if (!pt1) tmp.erase(tmp.begin() + n);
    auto p = (tmp.size() > 1) ? tmp[0] - tmp[1] : 0;

    for (size_t j {1}; j < tmp.size(); ++j) {
        auto dist = tmp[j - 1] - tmp[j];
        if (p > 0) {
            if (dist > 3 || dist <= 0) {
                if (pt1) return 0;
                break;
            }
            if (j == tmp.size() - 1) return 1;
        }
        else if (p < 0) {
            if (dist < -3 || dist >= 0) {
                if (pt1) return 0;
                break;
            }
            if (j == tmp.size() - 1) return 1;
        }
    }

    return solver(arr, false, n + 1);
}

auto solution() -> Pt1Pt2 {
    std::ifstream file ("input/day2.txt");
    auto lines = tl::views::getlines(file) | tl::to<std::vector<std::string>>();
    int sum1 {0}, sum2 {0};

    for (const auto &i : lines) {
        auto tmp = i 
            | std::views::split(' ') 
            | std::views::transform([](auto x) {
                return std::stoi(std::string(x.begin(), x.end()));})
            | tl::to<std::vector<int>>();

        sum1 += solver(tmp, true);
        sum2 += solver(tmp, false);
    } 

    return {sum1, sum2};
}