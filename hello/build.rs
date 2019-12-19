fn main() {
    let arch = std::env::var("ARCH").expect("please set $ARCH env");
    println!("cargo:rustc-link-search=native={}{}", "../prebuilt/ulib/", arch);
}