fn main() {
    println!("cargo:rustc-link-search=native={}", "../prebuilt/ulib");
}