#![feature(termination_trait)]

use std::fs::File;
use std::io;
use std::io::Read;

fn main() -> io::Result<()> {
    let mut input = File::open("input.txt")?;

    let mut content = String::new();
    input.read_to_string(&mut content)?;
    let chars = content.chars().filter(|c| c.is_numeric()).map(|c| {
        c.to_digit(10).unwrap()
    });

    let v = chars.collect::<Vec<u32>>();

    let r = calculate(&v, 1)?;
    println!("RES: {:?}", r);

    let r2 = calculate(&v, v.len() / 2)?;
    println!("RES: {:?}", r2);

    Ok(())
}

fn calculate(captcha: &Vec<u32>, interval: usize) -> Result<u32, std::io::Error> {
    let mut res: Vec<u32> = vec![];
    let max = captcha.len();

    for i in 0..max {
        if captcha[i] == captcha[(i + interval) % max] {
            res.push(captcha[i]);
        }
    }

    Ok(res.iter().sum())
}
