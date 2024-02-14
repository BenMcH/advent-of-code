use std::collections::HashMap;

#[allow(dead_code)]
fn part_1(input: String) -> i32 {
    let mut twos = 0;
    let mut threes = 0;

    for i in input.lines() {
        let mut map: HashMap<char, u8> = std::collections::HashMap::new();

        for j in i.chars() {
            *map.entry(j).or_insert(0) += 1;
        }

        if map.values().any(|&val| val == 2) {
            twos += 1;
        }
        if map.values().any(|&val| val == 3) {
            threes += 1;
        }
    }

    twos * threes
}

fn differences(one: &str, two: &str) -> (u8, String) {
    let mut differences: u8 = 0;
    let mut chars = Vec::new();

    for (i, ch) in one.char_indices() {
        if two.chars().nth(i).expect("Two is too short") != ch {
            differences += 1
        } else {
            chars.push(ch);
        }
    }

    (differences, chars.into_iter().collect())
}

#[allow(dead_code)]
fn part_2(input: String) -> String {
    let lines = input.lines().collect::<Vec<_>>();

    // let mut set = std::collections::HashSet::new();

    for (i, line) in lines.iter().enumerate() {
        for other_line in lines.iter().skip(i + 1) {
            let (diff, str) = differences(line, other_line);

            if diff == 1 {
                return str;
            }
        }
    }

    return String::new();
}

#[cfg(test)]
mod tests {
    use std::{fs::read_to_string, path};

    use super::*;

    #[test]
    fn test_part_1() {
        let input = match read_to_string(path::Path::new("src/day_02.txt")) {
            Ok(contents) => contents,
            Err(e) => panic!("Error reading file: {}", e),
        };

        println!("Day 02 result: {}", part_1(input));
    }

    #[test]
    fn test_part_2() {
        let input = match read_to_string(path::Path::new("src/day_02.txt")) {
            Ok(contents) => contents,
            Err(e) => panic!("Error reading file: {}", e),
        };

        println!("Day 02 result: {}", part_2(input));
    }
}
