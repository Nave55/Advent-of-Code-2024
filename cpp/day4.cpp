#include <cassert>
#include <ranges>
#include <utility>
#include "tools.h"

using PI = std::pair<int, int>;

auto checkXmas(const std::vector<vs> &mat) -> int {
  auto width = mat[0].size();
  auto height = mat.size();

  std::array<PI, 24> dirs = {{{-3, -3}, {-2, -2}, {-1, -1}, {-3, 3}, {-2, 2},
                              {-1, 1},  {3, -3},  {2, -2},  {1, -1}, {3, 3},
                              {2, 2},   {1, 1},   {-3, 0},  {-2, 0}, {-1, 0},
                              {3, 0},   {2, 0},   {1, 0},   {0, -3}, {0, -2},
                              {0, -1},  {0, 3},   {0, 2},   {0, 1}}};

  std::vector<PI> valid_inds;
  for (size_t i = 0; i < height; i++) {
    for (size_t j = 0; j < width; j++) {
      PI tmp = {(int)i, (int)j};
      if (mat[i][j] == "X") {
        valid_inds.emplace_back(tmp);
      }
    }
  }

  auto ttl = 0, cnt = 0;
  for (const auto &v : valid_inds) {
    std::string str{};
    for (const auto &val : dirs) {
      cnt++;
      auto tmp = val + v;
      if (tmp.first >= 0 && (size_t)tmp.first < height && tmp.second >= 0 &&
          (size_t)tmp.second < width) {
        str += mat[tmp.first][tmp.second];
      }
      if (cnt % 3 == 0) {
        str += "X";
        if (str == "XMAS" || str == "SAMX") ttl++;
        str = "";
      }
    }
  }

  return ttl;
}

auto checkX(const std::vector<vs> &mat) -> int {
  std::vector<PI> valid_inds;
  for (size_t i = 0; i < mat.size(); i++) {
    for (size_t j = 0; j < mat[0].size(); j++) {
      PI tmp = {(int)i, (int)j};
      if (mat[i][j] == "A") {
        valid_inds.emplace_back(tmp);
      }
    }
  }

  auto ttl = 0;
  for (const auto &v : valid_inds) {
    auto n = nbrs<std::string, 4>(mat, v, 'd');
    auto tmp = tJoin(n.vals);
    if (tmp == "MMSS" || tmp == "SSMM" || tmp == "SMSM" || tmp == "MSMS") ttl++;
  }
  return ttl;
}

auto solution() -> void {
  std::ifstream file("input/day4.txt");
  assert(file);
  std::string line;
  std::vector<vs> arr;

  while (std::getline(file, line)) {
    auto a =
        line | std::views::split(std::string_view("")) | std::ranges::to<vs>();
    arr.emplace_back(a);
  }

  auto sum1 = checkXmas(arr);
  auto sum2 = checkX(arr);

  printf("Part 1: %d\nPart 2: %d", sum1, sum2);
}

auto main() -> int {
  solution();
}
