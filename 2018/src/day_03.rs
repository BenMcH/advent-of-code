use std::str::FromStr;

struct FabricPlan {
    id: u16,
    x: u32,
    y: u32,
    width: u32,
    height: u32,
}

impl FabricPlan {
    fn points(&self) -> Vec<(u32, u32)> {
        let mut points = Vec::new();

        for x in self.x..self.x + self.width {
            for y in self.y..self.y + self.height {
                points.push((x, y));
            }
        }

        points
    }

    fn overlaps(&self, other: &FabricPlan) -> bool {
        if self.x + self.width <= other.x
            || self.x >= other.x + other.width
            || self.y + self.height <= other.y
            || self.y >= other.y + other.height
        {
            return false;
        }

        true
    }
}

#[derive(Debug)]
struct ParseFabricPlanError;

impl FromStr for FabricPlan {
    type Err = ParseFabricPlanError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let s = s.strip_prefix("#").expect("Missing leading #");
        let (id, s) = s.split_once(" @ ").expect("Missing \" @ \"");
        let (x, s) = s.split_once(",").expect("Missing , splitting x,y");
        let (y, s) = s.split_once(": ").expect("Missing : after y");
        let (width, height) = s.split_once("x").expect("Missing dimension separator");

        let id = id.parse::<u16>().expect("id not a u8");
        let x: u32 = x.parse().expect("x not a u32");
        let y: u32 = y.parse().expect("y not a u32");
        let width: u32 = width.parse().expect("width not u32");
        let height: u32 = height.parse().expect("height not u32");

        Ok(FabricPlan {
            id,
            x,
            y,
            width,
            height,
        })
    }
}

#[cfg(test)]
mod tests {
    use std::{fs::read_to_string, path};

    use super::*;

    #[test]
    fn test_parse() {
        let plan = FabricPlan::from_str("#9 @ 843,247: 22x24").expect("Failed to parse");

        assert_eq!(plan.id, 9);
        assert_eq!(plan.x, 843);
        assert_eq!(plan.y, 247);
        assert_eq!(plan.width, 22);
        assert_eq!(plan.height, 24);
    }

    #[test]
    fn test_part_1() {
        let input =
            read_to_string(path::Path::new("src/day_03.txt")).expect("failed to read input");

        let plans: Vec<FabricPlan> = input
            .lines()
            .map(|line| line.parse::<FabricPlan>().expect("Failed to parse"))
            .collect();

        use std::collections::HashSet;
        let mut set: HashSet<(u32, u32)> = HashSet::new();

        for (idx, plan) in plans.iter().enumerate() {
            for plan2 in plans[idx + 1..].iter() {
                if !plan.overlaps(plan2) {
                    continue;
                }

                for point in plan.points() {
                    if plan2.points().contains(&point) {
                        set.insert(point);
                    }
                }
            }
        }

        println!("Day 03 result: {}", set.len());
    }

    #[test]
    fn test_part_2() {
        let input =
            read_to_string(path::Path::new("src/day_03.txt")).expect("failed to read input");

        let plans: Vec<FabricPlan> = input
            .lines()
            .map(|line| line.parse::<FabricPlan>().expect("Failed to parse"))
            .collect();

        use std::collections::HashSet;
        let mut set: HashSet<u16> = HashSet::new();

        for (idx, plan) in plans.iter().enumerate() {
            for plan2 in plans[idx + 1..].iter() {
                if !plan.overlaps(plan2) {
                    continue;
                }

                set.insert(plan.id);
                set.insert(plan2.id);
            }
        }

        for plan in plans.iter() {
            if !set.contains(&plan.id) {
                println!("Day 03 result: {}", plan.id);
                break;
            }
        }
    }
}
