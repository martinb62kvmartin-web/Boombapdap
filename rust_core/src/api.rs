pub fn init_app() -> String {
    "Boombapdap Engine Initialized via Rust Bridge".to_string()
}

pub fn get_bpm() -> f32 {
    120.0
}

pub fn set_bpm(bpm: f32) {
    println!("BPM set to: {}", bpm);
}
