#![allow(dead_code)]
fn part_1(input: String) -> i32 {
    let lines: Vec<i32> = input.lines().map(|x| x.parse().unwrap()).collect();
    let mut current = 0;

    for i in lines.iter() {
        current += i;
    }

    current
}

#[allow(dead_code)]
fn part_2(input: String) -> i32 {
    let lines: Vec<i32> = input.lines().map(|x| x.parse().unwrap()).collect();
    let mut current = 0;
    let mut set = std::collections::HashSet::new();

    for i in lines.iter().cycle() {
        current += i;
        if !set.insert(current) {
            break;
        }
    }

    current
}

#[cfg(test)]
mod tests {
    use std::{fs::read_to_string, path};

    use super::*;

    #[test]
    fn test_part_1() {
        let input = match read_to_string(path::Path::new("src/day_01.txt")) {
            Ok(contents) => contents,
            Err(e) => panic!("Error reading file: {}", e),
        };

        println!("Day 01 result: {}", part_1(input));
    }

    #[test]
    fn test_part_2() {
        let input = match read_to_string(path::Path::new("src/day_01.txt")) {
            Ok(contents) => contents,
            Err(e) => panic!("Error reading file: {}", e),
        };

        println!("Day 01 result: {}", part_2(input));
    }
}
