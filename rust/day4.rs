fn main() {
    solution()
}

fn solution() {
    let con = std::fs::read_to_string("../inputs/day4.txt").expect("Bad File Name");

    let mat: Vec<Vec<char>> = con
        .split("\r\n\r\n")
        .flat_map(|line| line.lines())
        .map(|s| s.chars().collect())
        .collect();

    let pt1 = check_xmas(&mat);
    let pt2 = check_x(&mat);
    println!("Part 1: {pt1}\nPart 2: {pt2}")
}

fn check_xmas(mat: &Vec<Vec<char>>) -> i32 {
    let dir: [(i32, i32); 24] = [
        (-3, -3),
        (-2, -2),
        (-1, -1),
        (-3, 3),
        (-2, 2),
        (-1, 1),
        (3, -3),
        (2, -2),
        (1, -1),
        (3, 3),
        (2, 2),
        (1, 1),
        (-3, 0),
        (-2, 0),
        (-1, 0),
        (3, 0),
        (2, 0),
        (1, 0),
        (0, -3),
        (0, -2),
        (0, -1),
        (0, 3),
        (0, 2),
        (0, 1),
    ];

    let valid_inds: Vec<Vec<i32>> = mat
        .iter()
        .enumerate()
        .flat_map(|(r_ind, r_vals)| {
            r_vals
                .iter()
                .enumerate()
                .filter_map(|(c_ind, &c_val)| {
                    let tmp = vec![r_ind as i32, c_ind as i32];
                    if c_val == 'X' {
                        Some(tmp)
                    } else {
                        None
                    }
                })
                .collect::<Vec<Vec<i32>>>()
        })
        .collect();

    valid_inds
        .iter()
        .flat_map(|v| {
            dir.iter()
                .filter_map(|&(x, y)| {
                    let tmp = [v[0] + x, v[1] + y];
                    mat.get(tmp[0] as usize)
                        .and_then(|row| row.get(tmp[1] as usize))
                        .copied()
                        .or(Some('0'))
                })
                .collect::<Vec<char>>()
                .chunks(3)
                .filter_map(|chunk| {
                    if chunk == ['S', 'A', 'M'] {
                        Some(1)
                    } else {
                        None
                    }
                })
                .collect::<Vec<i32>>()
        })
        .sum::<i32>()
}

fn get_diags<T>(mat: &Vec<Vec<T>>, loc: [i32; 2]) -> Vec<T>
where
    T: Copy,
{
    let dir: [(i32, i32); 4] = [(-1, -1), (-1, 1), (1, -1), (1, 1)];

    dir.iter()
        .filter_map(|&(dx, dy)| {
            let new_x = loc[0] + dx;
            let new_y = loc[1] + dy;
            if new_x >= 0 && new_x < mat.len() as i32 && new_y >= 0 && new_y < mat[0].len() as i32 {
                mat.get(new_x as usize)
                    .and_then(|row| row.get(new_y as usize))
                    .copied()
            } else {
                None
            }
        })
        .collect()
}

fn check_x(mat: &Vec<Vec<char>>) -> i32 {
    let valid_inds: Vec<Vec<i32>> = mat
        .iter()
        .enumerate()
        .flat_map(|(r_ind, r_vals)| {
            r_vals
                .iter()
                .enumerate()
                .filter_map(|(c_ind, &c_val)| {
                    let tmp = vec![r_ind as i32, c_ind as i32];
                    if c_val == 'A' {
                        Some(tmp)
                    } else {
                        None
                    }
                })
                .collect::<Vec<Vec<i32>>>()
        })
        .collect();

    valid_inds
        .iter()
        .filter_map(|i| {
            let vals: &str = &get_diags(mat, [i[0], i[1]]).iter().collect::<String>();
            if ["MMSS", "SSMM", "SMSM", "MSMS"].contains(&vals) {
                Some(1)
            } else {
                None
            }
        })
        .sum::<i32>()
}
