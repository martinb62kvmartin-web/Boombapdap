#[derive(Clone, Debug)]
pub struct Note {
    pub key: u8,      // MIDI note number (0-127)
    pub start: f32,   // Start time in beats
    pub duration: f32, // Duration in beats
    pub velocity: f32, // 0.0 - 1.0
}

pub struct MidiTrack {
    pub notes: Vec<Note>,
}

impl MidiTrack {
    pub fn new() -> Self {
        Self { notes: Vec::new() }
    }

    pub fn add_note(&mut self, key: u8, start: f32, duration: f32, velocity: f32) {
        self.notes.push(Note { key, start, duration, velocity });
        self.notes.sort_by(|a, b| a.start.partial_cmp(&b.start).unwrap());
    }

    pub fn get_active_notes(&self, current_time: f32) -> Vec<&Note> {
        self.notes.iter()
            .filter(|n| current_time >= n.start && current_time < n.start + n.duration)
            .collect()
    }
}
