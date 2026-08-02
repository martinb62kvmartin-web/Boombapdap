use crate::adsr::Adsr;
use crate::filter::LowPassFilter;

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

pub struct Voice {
    pub key: u8,
    oscillator: Oscillator,
    adsr: Adsr,
    filter: LowPassFilter,
    pub velocity: f32,
}

impl Voice {
    pub fn new(key: u8, frequency: f32, sample_rate: f32, velocity: f32) -> Self {
        Self {
            key,
            oscillator: Oscillator::new(frequency, sample_rate),
            adsr: Adsr::new(0.01, 0.1, 0.5, 0.2, sample_rate),
            filter: LowPassFilter::new(0.2, 0.1),
            velocity,
        }
    }

    pub fn next_sample(&mut self) -> f32 {
        let osc_sample = self.oscillator.next_sample();
        let adsr_level = self.adsr.tick();
        let filtered_sample = self.filter.process(osc_sample * adsr_level * self.velocity);
        filtered_sample
    }

    pub fn note_off(&mut self) {
        self.adsr.note_off();
    }

    pub fn is_finished(&self) -> bool {
        self.adsr.is_finished()
    }
}

pub struct Synth {
    pub voices: Vec<Voice>,
    pub sample_rate: f32,
}

impl Synth {
    pub fn new() -> Self {
        Self {
            voices: Vec::new(),
            sample_rate: 44100.0,
        }
    }

    fn midi_to_freq(key: u8) -> f32 {
        440.0 * 2.0f32.powf((key as f32 - 69.0) / 12.0)
    }

    pub fn note_on(&mut self, key: u8, velocity: f32) {
        // Останавливаем старый голос с той же нотой, если он есть
        self.note_off(key);
        let freq = Self::midi_to_freq(key);
        self.voices.push(Voice::new(key, freq, self.sample_rate, velocity));
    }

    pub fn trigger_note(&mut self, frequency: f32) {
        let key = 69;
        self.voices.push(Voice::new(key, frequency, self.sample_rate, 0.8));
    }

    pub fn note_off(&mut self, key: u8) {
        for voice in self.voices.iter_mut() {
            if voice.key == key {
                voice.note_off();
            }
        }
    }

    pub fn process_buffer(&mut self, buffer: &mut [f32]) {
        for sample in buffer.iter_mut() {
            let mut mixed_sample = 0.0;
            for voice in self.voices.iter_mut() {
                mixed_sample += voice.next_sample();
            }
            *sample = mixed_sample * 0.1;
        }
        self.voices.retain(|v| !v.is_finished());
    }
}
