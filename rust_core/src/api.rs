use crate::sequencer::Sequencer;
use crate::synth::Synth;
use crate::mixer::Mixer;
use crate::automation::AutomationClip;
use crate::midi::MidiTrack;
use lazy_static::lazy_static;
use parking_lot::Mutex;

lazy_static! {
    static ref SEQUENCER: Mutex<Sequencer> = Mutex::new(Sequencer::new(120.0, 16));
    static ref SYNTH: Mutex<Synth> = Mutex::new(Synth::new());
    static ref MIXER: Mutex<Mixer> = Mutex::new(Mixer::new(6, 44100));
    static ref AUTOMATIONS: Mutex<Vec<AutomationClip>> = Mutex::new(Vec::new());
    static ref MIDI_TRACK: Mutex<MidiTrack> = Mutex::new(MidiTrack::new());
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
    let automations = AUTOMATIONS.lock();
    let current_time = SEQUENCER.lock().current_step as f32 / 4.0; // Текущее время в тактах

    // Применяем автоматизацию к параметрам микшера перед обработкой
    for auto in automations.iter() {
        let value = auto.get_value_at(current_time);
        if auto.target_param_id == "master_volume" {
            mixer.master_volume = value;
        } else if auto.target_param_id.starts_with("ch_vol_") {
            if let Ok(idx) = auto.target_param_id.replace("ch_vol_", "").parse::<usize>() {
                if let Some(ch) = mixer.channels.get_mut(idx) {
                    ch.volume = value;
                }
            }
        }
    }

    for sample in buffer.iter_mut() {
        // Обработка через каналы и мастер
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
