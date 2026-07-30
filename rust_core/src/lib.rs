pub mod api;
pub mod sequencer;
pub mod synth;
pub mod adsr;
pub mod sample;
pub mod filter;
pub mod effects;
pub mod mixer;
pub mod export;
pub mod ffi;

pub fn init_engine() {
    println!("Boombapdap Engine Initialized");
}
