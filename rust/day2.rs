fn main() {
    let arr = read_input("day1.txt");
    solve(&arr)
}

fn read_input(path: &str) -> Vec<Vec<i32>> {
    let data = std::fs::read_to_string(path).expect("Bad File Path");

    let arr: Vec<Vec<i32>> = data
        .lines()
        .map(|line| {
            line.split_whitespace()
                .filter_map(|num| num.parse::<i32>().ok())
                .collect()
        })
        .collect();

    arr
}

fn check_safety(arr: &[i32]) -> bool {
    if arr.len() <= 1 {
        return true;
    }

    let is_increasing_and_safe = arr.windows(2).all(|w| {
        let diff = w[1] - w[0];
        (diff > 0) && (diff <= 3)
    });

    let is_decreasing_and_safe = arr.windows(2).all(|w| {
        let diff = w[0] - w[1];
        (diff > 0) && (diff <= 3)
    });

    is_increasing_and_safe || is_decreasing_and_safe
}

fn check_safety_two(arr: &[i32]) -> bool {
    if check_safety(arr) {
        return true;
    }

    for i in 0..arr.len() {
        let mut temp = arr.to_vec();
        temp.remove(i);
        if check_safety(&temp) {
            return true;
        }
    }

    false
}

fn solve(arr: &Vec<Vec<i32>>) {
    let pt1 = arr.iter().filter(|l| check_safety(l)).count();
    let pt2 = arr.iter().filter(|l| check_safety_two(l)).count();

    println!("Part 1: {pt1}\nPart 2: {pt2}")
}
