fn main() {
    let con = parse_input();
    solution(&con);
}

fn parse_input() -> Vec<Vec<i32>> {
    let con = std::fs::read_to_string("../inputs/day2.txt").unwrap();
    con
    .lines()
    .map(|line| {
        line.split_whitespace()
            .filter_map(|n| n.parse::<i32>().ok())
            .collect()
    }).collect()
}

fn check_safety(arr: &[i32]) -> bool {
    let dec = arr.windows(2).all(|w| (1..=3).contains(&(w[0] - w[1])));
    let inc = arr.windows(2).all(|w| (1..=3).contains(&(w[1] - w[0])));
    dec || inc
}

fn check_safety2(arr: &[i32]) -> bool {
    if check_safety(arr) {
        return true;
    }

    (0..arr.len()).any(|i| {
        let tmp = arr[..i].iter().chain(&arr[i + 1..]).copied().collect::<Vec<_>>();
        check_safety(&tmp)
    })
}

fn solution(con: &[Vec<i32>]) {
    let mut ttl1 = 0;
    let mut ttl2 = 0;

    for i in con {
        if check_safety(&i) {
            ttl1 += 1;
        }
        if check_safety2(&i) {
            ttl2 += 1;
        }
    }

    println!("Part 1: {ttl1}\nPart 2: {ttl2}")
}
