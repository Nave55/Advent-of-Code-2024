fn main() {
    let (pt1, pt2) = solution();
    println!("Part 1: {pt1}\nPart 2: {pt2}");
}

fn solver(arr: &Vec<i32>, n: usize, pt1: bool) -> i32 {
    if n == arr.len() {
        return 0;
    } else {
        let mut tmp = arr.clone();
        if !pt1 {
            tmp.remove(n);
        }

        let p = if tmp.len() > 1 { tmp[0] - tmp[1] } else { 0 };

        for j in 1..tmp.len() {
            let dist = tmp[j - 1] - tmp[j];
            if p >= 0 {
                if dist > 3 || dist <= 0 {
                    if pt1 {
                        return 0;
                    }
                    break;
                }
                if j == tmp.len() - 1 {
                    return 1;
                }
            } else if p <= 0 {
                if dist < -3 || dist >= 0 {
                    if pt1 {
                        return 0;
                    }
                    break;
                }
                if j == tmp.len() - 1 {
                    return 1;
                }
            }
        }
    }

    solver(arr, n + 1, false)
}

fn solution() -> (i32, i32) {
    let con = std::fs::read_to_string("../inputs/day2.txt").unwrap();
    let mut sum1: i32 = 0;
    let mut sum2: i32 = 0;

    con.lines()
        .map(|line| {
            line.split_whitespace()
                .filter_map(|n| n.parse::<i32>().ok())
                .collect()
        })
        .for_each(|i| {
            sum1 += solver(&i, 0, true);
            sum2 += solver(&i, 0, false);
        });

    (sum1, sum2)
}
