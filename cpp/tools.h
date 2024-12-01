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
T join(const std::vector<T> &arr, const char delim = ',') {
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

std::vector<int> split(const std::string &s, const char del = ',') {
    vi result {};
    std::stringstream ss(s);
    std::string word;
    while (!ss.eof()) {
        std::getline(ss, word, del);
        result.emplace_back(std::stoi(word));
    }
    return result;
}

std::vector<int> split(const std::vector<std::string> &arr, const char del = ',') {
    vi result {};

    for (auto i: arr) {
        std::stringstream ss(i);
        std::string word;
        while (!ss.eof()) {
            std::getline(ss, word, del);
            result.emplace_back(std::stoi(word));
        }
    }
    return result;
}

template <typename T>
std::vector<T> operator+(const std::vector<T> &arr, const std::vector<T> &arr2) {
    std::vector<T> result {};
    for (size_t i {0}; i < arr.size(); i++) {
        result.push_back(arr[i] + arr2[i]);
    }
    return result;
}

template <typename T>
T arrValue(const std::vector<std::vector<T>> &arr, const std::vector<int> &arr2) {
    return arr[arr2[0]][arr2[1]];
}

template <typename T>
struct Nbrs {
    std::vector<std::vector<T>> indices {};
    std::vector<int> vals {};
};

template <typename T>
Nbrs<T> nbrs(const std::vector<std::vector<T>> &arr, const std::vector<int> &loc, bool diag = false) {
    vvi dir = {};
    if (!diag) dir = {{-1, 0}, {0, -1}, {0, 1}, {1, 0}};
    else dir = {{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}};
    std::vector<T> vals {};
    vvi indices {};
    
    for (const auto  &i : dir) {
        auto tmp = loc + i;
        if (tmp[0] != -1 && tmp[1] != -1 && (size_t) tmp[0] != arr.size() && (size_t) tmp[1] != arr[0].size()) {
            indices.emplace_back(tmp);
            vals.emplace_back(arrValue(arr, tmp));
        }
    }
    return {indices, vals};
}