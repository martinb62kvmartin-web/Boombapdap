use crate::sequencer::Sequencer;
use crate::synth::Synth;
use lazy_static::lazy_static;
use parking_lot::Mutex;

lazy_static! {
    static ref SEQUENCER: Mutex<Sequencer> = Mutex::new(Sequencer::new(120.0, 16));
    static ref SYNTH: Mutex<Synth> = Mutex::new(Synth::new());
}

pub fn init_app() -> String {
    "Boombapdap Engine & Synth Initialized".to_string()
}

pub fn get_bpm() -> f32 {
    SEQUENCER.lock().bpm
}

pub fn set_bpm(bpm: f32) {
    SEQUENCER.lock().set_bpm(bpm);
}

pub fn toggle_playback() {
    SEQUENCER.lock().toggle_playback();
}

pub fn is_playing() -> bool {
    SEQUENCER.lock().is_playing
}

pub fn get_current_step() -> usize {
    SEQUENCER.lock().current_step
}

/// Вызывается из Flutter для обработки тика и звука
pub fn process_tick() -> Option<usize> {
    let mut seq = SEQUENCER.lock();
    if let Some(step) = seq.tick() {
        // Имитация триггера звука при каждом шаге (для теста)
        // В реальном приложении здесь проверялась бы сетка шагов
        SYNTH.lock().trigger_note(440.0); // Ля первой октавы
        return Some(step);
    }
    None
}

/// Генерация аудио-буфера для вывода звука
pub fn get_audio_buffer(len: usize) -> Vec<f32> {
    let mut buffer = vec![0.0; len];
    SYNTH.lock().process_buffer(&mut buffer);
    buffer
}
