use crate::sequencer::Sequencer;
use crate::synth::Synth;
use crate::mixer::Mixer;
use lazy_static::lazy_static;
use parking_lot::Mutex;

lazy_static! {
    static ref SEQUENCER: Mutex<Sequencer> = Mutex::new(Sequencer::new(120.0, 16));
    static ref SYNTH: Mutex<Synth> = Mutex::new(Synth::new());
    static ref MIXER: Mutex<Mixer> = Mutex::new(Mixer::new(6, 44100));
}

pub fn init_app() -> String {
    "Boombapdap Engine, Synth & Mixer Initialized".to_string()
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

pub fn process_tick() -> Option<usize> {
    let mut seq = SEQUENCER.lock();
    if let Some(step) = seq.tick() {
        SYNTH.lock().trigger_note(440.0);
        return Some(step);
    }
    None
}

pub fn get_audio_buffer(len: usize) -> Vec<f32> {
    let mut buffer = vec![0.0; len];
    SYNTH.lock().process_buffer(&mut buffer);
    
    let mut mixer = MIXER.lock();
    for sample in buffer.iter_mut() {
        // Для примера пропускаем все через 1-й канал и мастер
        *sample = mixer.process_channel(0, *sample);
        *sample = mixer.apply_master(*sample);
    }
    buffer
}

// Функции управления микшером
pub fn set_channel_volume(channel: usize, volume: f32) {
    if let Some(ch) = MIXER.lock().channels.get_mut(channel) {
        ch.volume = volume;
    }
}

pub fn set_master_volume(volume: f32) {
    MIXER.lock().master_volume = volume;
}
