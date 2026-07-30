pub struct Oscillator {
    pub frequency: f32,
    pub sample_rate: f32,
    phase: f32,
}

impl Oscillator {
    pub fn new(frequency: f32, sample_rate: f32) -> Self {
        Self {
            frequency,
            sample_rate,
            phase: 0.0,
        }
    }

    pub fn next_sample(&mut self) -> f32 {
        let sample = (self.phase * 2.0 * std::f32::consts::PI).sin();
        self.phase = (self.phase + self.frequency / self.sample_rate) % 1.0;
        sample
    }
}

pub struct Synth {
    pub oscillators: Vec<Oscillator>,
}

impl Synth {
    pub fn new() -> Self {
        Self {
            oscillators: Vec::new(),
        }
    }

    pub fn trigger_note(&mut self, frequency: f32) {
        self.oscillators.push(Oscillator::new(frequency, 44100.0));
    }

    pub fn process_buffer(&mut self, buffer: &mut [f32]) {
        for sample in buffer.iter_mut() {
            let mut mixed_sample = 0.0;
            for osc in self.oscillators.iter_mut() {
                mixed_sample += osc.next_sample();
            }
            *sample = mixed_sample * 0.1; // Снижаем громкость для безопасности
        }
    }
}
