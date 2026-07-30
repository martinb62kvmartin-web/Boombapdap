use std::time::{Duration, Instant};

pub struct Sequencer {
    pub bpm: f32,
    pub current_step: usize,
    pub total_steps: usize,
    pub is_playing: bool,
    last_tick: Instant,
}

impl Sequencer {
    pub fn new(bpm: f32, total_steps: usize) -> Self {
        Self {
            bpm,
            current_step: 0,
            total_steps,
            is_playing: false,
            last_tick: Instant::now(),
        }
    }

    pub fn set_bpm(&mut self, bpm: f32) {
        self.bpm = bpm;
    }

    pub fn toggle_playback(&mut self) {
        self.is_playing = !self.is_playing;
        if self.is_playing {
            self.last_tick = Instant::now();
        }
    }

    pub fn step_duration(&self) -> Duration {
        let secs_per_beat = 60.0 / self.bpm;
        let secs_per_step = secs_per_beat / 4.0;
        Duration::from_secs_f32(secs_per_step)
    }

    pub fn tick(&mut self) -> Option<usize> {
        if !self.is_playing {
            return None;
        }

        let now = Instant::now();
        if now.duration_since(self.last_tick) >= self.step_duration() {
            self.current_step = (self.current_step + 1) % self.total_steps;
            self.last_tick = now;
            return Some(self.current_step);
        }
        None
    }
}
