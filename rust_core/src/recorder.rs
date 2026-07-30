use std::sync::{Arc, Mutex};

pub struct Recorder {
    pub is_recording: bool,
    pub buffer: Arc<Mutex<Vec<f32>>>,
}

impl Recorder {
    pub fn new() -> Self {
        Self {
            is_recording: false,
            buffer: Arc::new(Mutex::new(Vec::new())),
        }
    }

    pub fn start(&mut self) {
        self.is_recording = true;
        self.buffer.lock().unwrap().clear();
    }

    pub fn stop(&mut self) -> Vec<f32> {
        self.is_recording = false;
        self.buffer.lock().unwrap().clone()
    }

    pub fn push_samples(&self, samples: &[f32]) {
        if self.is_recording {
            self.buffer.lock().unwrap().extend_from_slice(samples);
        }
    }
}
