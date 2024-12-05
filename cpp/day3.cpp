#include "tools.h"
#include <fstream>
#include <ranges>
#include <regex>

struct Pt1Pt2 {int pt1 {0}; int pt2 {0};};
auto solution() -> Pt1Pt2;

auto main() -> int {
    auto [sum1, sum2] = solution();
    printf("Part 1: %d\nPart 2: %d", sum1, sum2);
}

auto solution() -> Pt1Pt2 {
    std::ifstream file ("input/day3.txt");
    std::stringstream buffer; 
    buffer << file.rdbuf();
    auto lines = buffer.str();

    std::regex re("mul\\(\\d+,\\d+\\)|(do(n't)?\\(\\))");    
    auto words_begin = std::sregex_iterator(lines.begin(), lines.end(), re);
    auto words_end = std::sregex_iterator();

    int sum1 {0}, sum2 {0}, mul {true};
    for (std::regex_iterator i = words_begin; i != words_end; ++i) {
        std::smatch match = *i;
        std::string str = match.str();
        str = std::regex_replace(str, std::regex("mul\\("), ""); 
        str = std::regex_replace(str, std::regex("\\)"), "");

        if (str == "do(") {
            mul = true;
            continue;
        }
        else if (str == "don't(") {
            mul = false;
            continue;
        }
        auto tmp = str 
                | std::views::split(',')
                | std::views::transform([](auto x) {
                     return std::stoi(std::string(x.begin(), x.end()));
                })
                | std::ranges::to<std::vector<int>>();

        sum1 += tmp[0] * tmp[1];
        if (mul) sum2 += tmp[0] * tmp[1];
    }

    return {sum1, sum2};
}