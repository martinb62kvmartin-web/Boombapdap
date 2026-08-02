pub struct Adsr {
    pub attack: f32,  // seconds
    pub decay: f32,   // seconds
    pub sustain: f32, // level (0.0 - 1.0)
    pub release: f32, // seconds
    sample_rate: f32,
    time: f32,
    is_releasing: bool,
    release_start_time: f32,
}

impl Adsr {
    pub fn new(attack: f32, decay: f32, sustain: f32, release: f32, sample_rate: f32) -> Self {
        Self {
            attack,
            decay,
            sustain,
            release,
            sample_rate,
            time: 0.0,
            is_releasing: false,
            release_start_time: 0.0,
        }
    }

    pub fn tick(&mut self) -> f32 {
        let level = if !self.is_releasing {
            if self.time < self.attack {
                if self.attack > 0.0 {
                    self.time / self.attack
                } else {
                    1.0
                }
            } else if self.time < self.attack + self.decay {
                let decay_time = self.time - self.attack;
                if self.decay > 0.0 {
                    1.0 - (decay_time / self.decay) * (1.0 - self.sustain)
                } else {
                    self.sustain
                }
            } else {
                self.sustain
            }
        } else {
            let release_time = self.time - self.release_start_time;
            if release_time < self.release {
                if self.release > 0.0 {
                    self.sustain * (1.0 - release_time / self.release)
                } else {
                    0.0
                }
            } else {
                0.0
            }
        };

        self.time += 1.0 / self.sample_rate;
        level
    }

    pub fn note_off(&mut self) {
        self.is_releasing = true;
        self.release_start_time = self.time;
    }

    pub fn is_finished(&self) -> bool {
        self.is_releasing && (self.time - self.release_start_time) >= self.release
    }
}
