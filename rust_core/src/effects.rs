pub struct Compressor {
    pub threshold: f32,
    pub ratio: f32,
    pub attack: f32,
    pub release: f32,
    envelope: f32,
}

impl Compressor {
    pub fn new() -> Self {
        Self {
            threshold: 0.5,
            ratio: 4.0,
            attack: 0.01,
            release: 0.1,
            envelope: 0.0,
        }
    }

    pub fn process(&mut self, sample: f32) -> f32 {
        let abs_sample = sample.abs();
        if abs_sample > self.envelope {
            self.envelope += self.attack * (abs_sample - self.envelope);
        } else {
            self.envelope += self.release * (abs_sample - self.envelope);
        }

        if self.envelope > self.threshold {
            let reduction = self.threshold + (self.envelope - self.threshold) / self.ratio;
            let gain = reduction / self.envelope;
            sample * gain
        } else {
            sample
        }
    }
}

pub struct BitCrusher {
    pub bits: f32,       // 1.0 to 16.0
    pub downsample: u32, // 1 to 10
    counter: u32,
    last_sample: f32,
}

impl BitCrusher {
    pub fn new() -> Self {
        Self {
            bits: 8.0,
            downsample: 1,
            counter: 0,
            last_sample: 0.0,
        }
    }

    pub fn process(&mut self, sample: f32) -> f32 {
        self.counter += 1;
        if self.counter >= self.downsample {
            self.counter = 0;
            let levels = 2.0f32.powf(self.bits);
            self.last_sample = (sample * levels).round() / levels;
        }
        self.last_sample
    }
}

pub struct Saturation {
    pub drive: f32, // 1.0 to 10.0
}

impl Saturation {
    pub fn new() -> Self {
        Self { drive: 1.0 }
    }

    pub fn process(&mut self, sample: f32) -> f32 {
        let x = sample * self.drive;
        // Soft clipping function: x / (1 + |x|)
        x / (1.0 + x.abs())
    }
}

pub struct Reverb {
    pub mix: f32,
    delay_buffer: Vec<f32>,
    write_pos: usize,
}

impl Reverb {
    pub fn new(sample_rate: usize) -> Self {
        Self {
            mix: 0.3,
            delay_buffer: vec![0.0; sample_rate / 10], // 100ms delay
            write_pos: 0,
        }
    }

    pub fn process(&mut self, sample: f32) -> f32 {
        let read_pos = (self.write_pos + 1) % self.delay_buffer.len();
        let delayed = self.delay_buffer[read_pos];
        self.delay_buffer[self.write_pos] = sample + delayed * 0.5;
        self.write_pos = read_pos;
        sample * (1.0 - self.mix) + delayed * self.mix
    }
}
