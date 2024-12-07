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
    vi result {};
    std::stringstream ss(s);
    std::string word;
    while (!ss.eof()) {
        std::getline(ss, word, del);
        if (is_int) result.emplace_back(std::stoi(word));
        else result.emplace_back(word);
    }
    return result;
}

template <typename T>
std::vector<T> tSplit(const std::vector<std::string> &arr, const char del = ',', bool is_int = false) {
    vi result {};

    for (auto i: arr) {
        std::stringstream ss(i);
        std::string word;
        while (!ss.eof()) {
            std::getline(ss, word, del);
            if (is_int) result.emplace_back(std::stoi(word));
            else result.emplace_back(word);
        }
    }
    return result;
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

template <typename T, typename V, std::size_t N>
struct Nbrs {
    std::array<std::array<int, 2>, N> indices {};
    std::array<V, N> vals {};
    std::size_t size = 0; // To keep track of actual filled elements
};

template <typename T, typename V, std::size_t N>
Nbrs<T, V, N> nbrs(const std::vector<std::vector<V>> &arr, const std::array<int, 2> &loc, char type = 'n') {
    std::array<std::array<int, 2>, 8> all = {{{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}}};
    std::array<std::array<int, 2>, 4> diag = {{{-1, -1}, {-1, 1}, {1, -1}, {1, 1}}};
    std::array<std::array<int, 2>, 4>  lrup = {{{-1, 0}, {0, -1}, {0, 1}, {1, 0}}};
    
    Nbrs<T, V, N> result;
    
    auto cnt = 0;

    if (type == 'n') {
        for (const auto &i : lrup) {
            std::array<int, 2> tmp = {loc[0] + i[0], loc[1] + i[1]};
            if (tmp[0] != -1 && tmp[1] != -1 && static_cast<size_t>(tmp[0]) < arr.size() && static_cast<size_t>(tmp[1]) < arr[0].size()) {
                result.indices[result.size] = tmp;
                result.vals[result.size] = arr[tmp[0]][tmp[1]];
                result.size++;
            }
            cnt++;
        }
    }
    if (type == 'd') {
        for (const auto &i : diag) {
            std::array<int, 2> tmp = {loc[0] + i[0], loc[1] + i[1]};
            if (tmp[0] != -1 && tmp[1] != -1 && static_cast<size_t>(tmp[0]) < arr.size() && static_cast<size_t>(tmp[1]) < arr[0].size()) {
                result.indices[result.size] = tmp;
                result.vals[result.size] = arr[tmp[0]][tmp[1]];
                result.size++;
            }
            cnt++;
        }
    }
    if (type == 'a') {
        for (const auto &i : all) {
            std::array<int, 2> tmp = {loc[0] + i[0], loc[1] + i[1]};
            if (tmp[0] != -1 && tmp[1] != -1 && static_cast<size_t>(tmp[0]) < arr.size() && static_cast<size_t>(tmp[1]) < arr[0].size()) {
                result.indices[result.size] = tmp;
                result.vals[result.size] = arr[tmp[0]][tmp[1]];
                result.size++;
            }
            cnt++;
        }
    }

    return result;
}
