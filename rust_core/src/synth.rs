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
    oscillator: Oscillator,
    adsr: Adsr,
    filter: LowPassFilter,
}

impl Voice {
    pub fn new(frequency: f32, sample_rate: f32) -> Self {
        Self {
            oscillator: Oscillator::new(frequency, sample_rate),
            adsr: Adsr::new(0.01, 0.1, 0.5, 0.2, sample_rate),
            filter: LowPassFilter::new(0.1, 0.1),
        }
    }

    pub fn next_sample(&mut self) -> f32 {
        let osc_sample = self.oscillator.next_sample();
        let adsr_level = self.adsr.tick();
        let filtered_sample = self.filter.process(osc_sample * adsr_level);
        filtered_sample
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

    pub fn trigger_note(&mut self, frequency: f32) {
        self.voices.push(Voice::new(frequency, self.sample_rate));
    }

    pub fn process_buffer(&mut self, buffer: &mut [f32]) {
        for sample in buffer.iter_mut() {
            let mut mixed_sample = 0.0;
            for voice in self.voices.iter_mut() {
                mixed_sample += voice.next_sample();
            }
            *sample = mixed_sample * 0.1;
        }
        
        // Очистка завершенных голосов
        self.voices.retain(|v| !v.is_finished());
    }
}
