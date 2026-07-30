use hound;
use std::path::Path;

pub struct Sample {
    pub data: Vec<f32>,
    pub sample_rate: u32,
    pub pitch: f32,
    pub volume: f32,
}

impl Sample {
    pub fn load<P: AsRef<Path>>(path: P) -> Result<Self, anyhow::Error> {
        let mut reader = hound::WavReader::open(path)?;
        let spec = reader.spec();
        
        let data: Vec<f32> = match spec.sample_format {
            hound::SampleFormat::Float => reader.samples::<f32>().map(|s| s.unwrap_or(0.0)).collect(),
            hound::SampleFormat::Int => {
                let max_val = (1 << (spec.bits_per_sample - 1)) as f32;
                reader.samples::<i32>().map(|s| (s.unwrap_or(0) as f32) / max_val).collect()
            }
        };

        Ok(Self {
            data,
            sample_rate: spec.sample_rate,
            pitch: 1.0,
            volume: 1.0,
        })
    }

    pub fn normalize(&mut self) {
        let max_amplitude = self.data.iter().fold(0.0, |max, &s| s.abs().max(max));
        if max_amplitude > 0.0 {
            let scale = 1.0 / max_amplitude;
            for s in self.data.iter_mut() {
                *s *= scale;
            }
        }
    }

    pub fn get_sample_at(&self, index: f32) -> f32 {
        let idx = index as usize;
        if idx < self.data.len() {
            // Линейная интерполяция для более плавного питча
            let frac = index - idx as f32;
            let s1 = self.data[idx];
            let s2 = if idx + 1 < self.data.len() { self.data[idx + 1] } else { 0.0 };
            (s1 + (s2 - s1) * frac) * self.volume
        } else {
            0.0
        }
    }

    /// Простой алгоритм Time Stretch (изменение длительности без изменения питча)
    /// В реальности требует WSOLA или Phase Vocoder, здесь реализуем базовый ресемплинг
    pub fn stretch(&mut self, factor: f32) {
        if factor == 1.0 { return; }
        let new_len = (self.data.len() as f32 * factor) as usize;
        let mut new_data = Vec::with_capacity(new_len);
        for i in 0..new_len {
            let old_idx = i as f32 / factor;
            new_data.push(self.get_sample_at(old_idx));
        }
        self.data = new_data;
    }
}
