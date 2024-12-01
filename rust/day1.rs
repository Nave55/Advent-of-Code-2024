use std::{collections::HashSet, fs};

fn main() {
    let (left, right) = parse_file().expect("Failed to parse file");
    let pt1 = solution(&left, &right);
    let pt2 = solution2(&left, &right);
    println!("Part 1: {}\nPart 2: {}", pt1, pt2);
}

fn parse_file() -> Result<(Vec<i32>, Vec<i32>), Box<dyn std::error::Error>> {
    let mut left: Vec<i32> = Vec::new();
    let mut right: Vec<i32> = Vec::new();
    let con = fs::read_to_string("../inputs/day1.txt")?;
    con.split("\r\n\r\n").flat_map(|n| n.lines()).for_each(|l| {
        let tmp: Vec<&str> = l.split("   ").collect();
        left.push(tmp[0].parse::<i32>().expect("Failed to parse left value"));
        right.push(tmp[1].parse::<i32>().expect("Failed to parse right value"));
    });

    left.sort_unstable();
    right.sort_unstable();
    Ok((left, right))
}

fn solution(left: &[i32], right: &[i32]) -> i32 {
    left.iter()
        .zip(right.iter())
        .map(|(l, r)| (l - r).abs())
        .sum()
}

fn solution2(left: &[i32], right: &[i32]) -> i32 {
    let l_set: HashSet<i32> = left.iter().copied().collect();
    let mut sum = 0;

    right.iter().for_each(|&r| {
        if l_set.contains(&r) {
            sum += r;
        }
    });

    sum
}
