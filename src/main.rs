use chrono::prelude::*;

fn main() {
    let dt = Utc::now();

    zstd::stream::copy_decode(std::io::stdin(), std::io::stdout()).expect("perfect!");

    println!("Hello, world5! {}", dt);
}
