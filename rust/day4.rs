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
    let width = mat[0].len() as i32;
    let height = mat.len() as i32;

    let dir: [(i32, i32); 24] = [
        (3, -3),
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

    let mut valid_inds: Vec<[i32; 2]> = Vec::new();
    for (r_ind, r_val) in mat.iter().enumerate() {
        for (c_ind, c_val) in r_val.iter().enumerate() {
            let tmp = [r_ind as i32, c_ind as i32];
            if *c_val == 'X' {
                valid_inds.push(tmp);
            }
        }
    }

    let mut ttl = 0;
    let mut cnt = 0;
    for v in valid_inds {
        let mut str = String::from("");
        for (x, y) in dir {
            cnt += 1;
            let tmp = [v[0] + x, v[1] + y];
            if (tmp[0] >= 0 && tmp[0] < height) && (tmp[1] >= 0 && tmp[1] < width) {
                let t_val = mat[tmp[0] as usize][tmp[1] as usize];
                str += &t_val.to_string();
            }
            if cnt % 3 == 0 {
                str += "X";
                if str == "XMAS" || str == "SAMX" {
                    ttl += 1;
                }
                str.clear();
            }
        }
    }

    ttl
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
    let mut ttl = 0;
    let mut valid_inds: Vec<[i32; 2]> = Vec::new();
    for (r_ind, r_val) in mat.iter().enumerate() {
        for (c_ind, &c_val) in r_val.iter().enumerate() {
            let tmp = [r_ind as i32, c_ind as i32];
            if c_val == 'A' {
                valid_inds.push(tmp);
            }
        }
    }

    for i in valid_inds {
        let vals: &str = &get_diags(mat, [i[0], i[1]]).iter().collect::<String>();
        if ["MMSS", "SSMM", "SMSM", "MSMS"].contains(&vals) {
            ttl += 1;
        }
    }

    ttl
}
