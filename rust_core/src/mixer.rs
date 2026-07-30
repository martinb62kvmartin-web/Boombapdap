use crate::effects::{Compressor, BitCrusher, Saturation, Reverb};

pub struct Channel {
    pub volume: f32,
    pub pan: f32, // -1.0 to 1.0
    pub compressor: Compressor,
    pub bitcrusher: BitCrusher,
    pub saturation: Saturation,
    pub reverb: Reverb,
}

impl Channel {
    pub fn new(sample_rate: usize) -> Self {
        Self {
            volume: 0.8,
            pan: 0.0,
            compressor: Compressor::new(),
            bitcrusher: BitCrusher::new(),
            saturation: Saturation::new(),
            reverb: Reverb::new(sample_rate),
        }
    }

    pub fn process(&mut self, sample: f32) -> f32 {
        let mut s = sample;
        s = self.bitcrusher.process(s);
        s = self.saturation.process(s);
        s = self.compressor.process(s);
        s = self.reverb.process(s);
        s * self.volume
    }
}

pub struct Mixer {
    pub channels: Vec<Channel>,
    pub master_volume: f32,
}

impl Mixer {
    pub fn new(channel_count: usize, sample_rate: usize) -> Self {
        let mut channels = Vec::with_capacity(channel_count);
        for _ in 0..channel_count {
            channels.push(Channel::new(sample_rate));
        }
        Self {
            channels,
            master_volume: 1.0,
        }
    }

    pub fn process_channel(&mut self, channel_idx: usize, sample: f32) -> f32 {
        if channel_idx < self.channels.len() {
            self.channels[channel_idx].process(sample)
        } else {
            sample
        }
    }

    pub fn apply_master(&self, sample: f32) -> f32 {
        sample * self.master_volume
    }
}
