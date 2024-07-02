use chrono::prelude::*;

fn main() {
    let dt = Utc::now();

    zstd::stream::copy_decode(std::io::stdin(), std::io::stdout()).unwrap();

    println!("Hello, world2! {}", dt);
}
