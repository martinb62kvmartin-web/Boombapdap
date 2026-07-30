pub struct LowPassFilter {
    cutoff: f32,
    resonance: f32,
    v0: f32,
    v1: f32,
}

impl LowPassFilter {
    pub fn new(cutoff: f32, resonance: f32) -> Self {
        Self {
            cutoff,
            resonance,
            v0: 0.0,
            v1: 0.0,
        }
    }

    pub fn process(&mut self, input: f32) -> f32 {
        // Простая реализация фильтра Chamberlin State Variable
        let f = self.cutoff;
        let q = self.resonance;
        
        let low = self.v1 + f * self.v0;
        let high = input - low - q * self.v0;
        let band = f * high + self.v0;
        
        self.v0 = band;
        self.v1 = low;
        
        low
    }

    pub fn set_params(&mut self, cutoff: f32, resonance: f32) {
        self.cutoff = cutoff;
        self.resonance = resonance;
    }
}
