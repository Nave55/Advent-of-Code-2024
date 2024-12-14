#pragma once

#include <vector>
#include <string>
#include <numeric>
#include <algorithm>
#include <iostream>
#include <ostream>
#include <sstream>
#include <memory>
#include <math.h>
#include <utility>

typedef std::vector<int> vi;
typedef std::vector<std::vector<int>> vvi;
typedef std::vector<float> vf;
typedef std::vector<std::vector<float>> vvf;
typedef std::vector<std::string> vs;
typedef std::vector<std::vector<std::string>> vvs;
typedef std::vector<char> vc;
typedef std::vector<std::vector<char>> vvc;

template <typename T>
std::ostream &operator<<(std::ostream &os, const std::vector<T> &arr) {
    os << "[";
    for (size_t i {0}; i < arr.size(); ++i) {
        os << arr[i];
        if (i < arr.size() - 1) {
            os << ",";
        }
    }
    os << "]\n";
    return os;
}

template <typename T, size_t N>
std::ostream &operator<<(std::ostream &os, const std::array<T, N> &arr) {
    os << "[";
    for (size_t i {0}; i < arr.size(); ++i) {
        os << arr[i];
        if (i < arr.size() - 1) {
            os << ",";
        }
    }
    os << "]\n";
    return os;
}

template <typename T>
std::ostream &operator<<(std::ostream &os, const std::pair<T, T> &pair) {
    os << "[" << pair.first << ", " << pair.second << "]\n";
    return os;
}

template <typename T>
float avgVal(const std::vector<T> &arr) {
    if (arr.size() != 0)
        return (float) std::accumulate(arr.begin(), arr.end(), 0) / arr.size();
    return 0;
}

template <typename T>
T minVal(const std::vector<T> &arr) {
    if (arr.size() != 0) 
        return *std::ranges::min_element(arr);
    return 0;
}

template <typename T>
T maxVal(const std::vector<T> &arr) {
    if (arr.size() != 0) 
        return *std::ranges::max_element(arr);
    return 0;
}

template <typename T>
std::string tJoin(const T &arr, const char delim) {
    std::string str {""};
    for (size_t i {0}; i < arr.size(); ++i) {
        if (i < arr.size() - 1) {
            str += arr.at(i);
            str += delim;
        }
        else str += arr.at(i);
    }
    return str;
}

template <typename T>
std::string tJoin(const T &arr) {
    std::string str {""};
    for (size_t i {0}; i < arr.size(); ++i) {
        if (i < arr.size() - 1) {
            str += arr.at(i);
        }
        else str += arr.at(i);
    }
    return str;
}

template <typename T>
std::vector<T> tSplit(const std::string &s, const char del = ',', bool is_int = false) {
    std::vector<T> result;
    std::stringstream ss(s);
    std::string word;
    while (std::getline(ss, word, del)) {
        if (is_int) {
            result.push_back(static_cast<T>(std::stoi(word)));
        } else {
            std::stringstream conv(word);
            T temp;
            if constexpr (std::is_same_v<T, std::string>) {
                result.push_back(word);
            } else {
                conv >> temp;
                result.push_back(temp);
            }
        }
    }
    return result;
}

// template <typename T>
// std::vector<T> tSplit(const std::vector<std::string> &arr, const char del = ',', bool is_int = false) {
//     std::vector<T> result {};

//     for (auto i: arr) {
//         std::stringstream ss(i);
//         std::string word;
//         while (!ss.eof()) {
//             std::getline(ss, word, del);
//             if (is_int) result.emplace_back(std::stoi(word));
//             else result.emplace_back(word);
//         }
//     }
//     return result;
// }

template <typename T>
std::pair<T, T> operator+(const std::pair<T, T> &arr, const std::pair<T, T> &arr2) {
    return {arr.first + arr2.first, arr.second + arr2.second};
}

template <typename T>
std::pair<T, T> operator-(const std::pair<T, T> &arr, const std::pair<T, T> &arr2) {
    return {arr.first - arr2.first, arr.second - arr2.second};
}

template <typename T>
std::pair<T, T> operator*(const std::pair<T, T> &arr, T scalar) {
    return {arr.first * scalar, arr.second * scalar};
}

template <typename T, std::size_t N>
std::array<T, N> operator+(const std::array<T, N> &arr, const std::array<T, N> &arr2) {
    std::array<T, N> result {};
    for (size_t i {0}; i < arr.size(); i++) {
        result[i] = arr[i] + arr2[i];
    }
    return result;
}

template <typename T, std::size_t N>
std::array<T, N> operator+(const std::array<T, N> &arr, const std::vector<T> &arr2) {
    std::vector<T> result {};
    for (size_t i {0}; i < arr.size(); i++) {
        result.emplace_back(arr[i] + arr2[i]);
    }
    return result;
}

template <typename T>
std::vector<T> operator+(const std::vector<T> &arr, const std::vector<T> &arr2) {
    std::vector<T> result {};
    for (size_t i {0}; i < arr.size(); i++) {
        result.emplace_back(arr[i] + arr2[i]);
    }
    return result;
}

template <typename T>
T arrValue(const std::vector<std::vector<T>> &arr, const std::array<int, 2> &arr2) {
    return arr[arr2[0]][arr2[1]];
}

template <typename T>
T arrValue(const std::vector<std::vector<T>> &arr, const std::pair<int, int> &arr2) {
    return arr[arr2.first][arr2.second];
}

template <typename T>
bool inBounds(const std::vector<std::vector<T>> &arr, const std::pair<int, int> &pos) {
    return (pos.first >= 0 && pos.second >= 0 && static_cast<size_t>(pos.first) < arr.size() && static_cast<size_t>(pos.second) < arr[0].size());    
}

bool inBounds(const std::pair<int, int> &pos, size_t height, size_t width) {
    return (pos.first >= 0 && pos.second >= 0 && static_cast<size_t>(pos.first) < height && static_cast<size_t>(pos.second) < width);   
}

template <typename V, std::size_t N>
struct Nbrs {
    std::array<std::pair<int, int>, N> indices {};
    std::array<V, N> vals {};
    std::size_t size = 0; // To keep track of actual filled elements
};

template <typename V, std::size_t N>
Nbrs<V, N> nbrs(const std::vector<std::vector<V>> &arr, const std::pair<int, int> &loc, char type = 'n') {
    auto height = arr.size();
    auto width = arr[0].size();

    std::array<std::pair<int, int>, 8> all = {{{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}};
    std::array<std::pair<int, int>, 4> diag = {{{-1, -1}, {-1, 1}, {1, -1}, {1, 1}}};
    std::array<std::pair<int, int>, 4>  lrup = {{{-1, 0}, {0, -1}, {0, 1}, {1, 0}}};
    
    Nbrs<V, N> result;
    
    auto cnt = 0;

    if (type == 'n') {
        for (const auto &i : lrup) {
            std::pair<int, int> tmp = {loc.first + i.first, loc.second + i.second};
            if (inBounds(tmp, height, width)) {
                result.indices[result.size] = tmp;
                result.vals[result.size] = arrValue(arr, tmp);
                result.size++;
            }
            cnt++;
        }
    }
    if (type == 'd') {
        for (const auto &i : diag) {
            std::pair<int, int> tmp = {loc.first + i.first, loc.second + i.second};
            if (inBounds(tmp, height, width)) {
                result.indices[result.size] = tmp;
                result.vals[result.size] = arrValue(arr, tmp);
                result.size++;
            }
            cnt++;
        }
    }
    if (type == 'a') {
        for (const auto &i : all) {
            std::pair<int, int> tmp = {loc.first + i.first, loc.second + i.second};;
            if (inBounds(tmp, height, width)) {
                result.indices[result.size] = tmp;
                result.vals[result.size] = arrValue(arr, tmp);
                result.size++;
            }
            cnt++;
        }
    }

    return result;
}

template <typename T>
auto pairToStr(const std::pair<T, T> &pair) -> std::string {
    return std::to_string(pair.first) + "," + std::to_string(pair.second);
}

template <typename T>
auto strToPair(std::string str) -> std::pair<T, T> {
    std::stringstream ss(str);
    T first, second;
    char delimiter;
    ss >> first >> delimiter >> second;
    return std::make_pair(first, second);   
}
