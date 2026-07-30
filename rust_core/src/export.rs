use crate::sample::Sample;

pub struct ExportSettings {
    pub sample_rate: u32,
    pub resampling_points: u32, // 64 to 512
}

impl ExportSettings {
    pub fn new(sample_rate: u32, resampling_points: u32) -> Self {
        Self {
            sample_rate,
            resampling_points,
        }
    }
}

pub fn resample_with_quality(data: &[f32], factor: f32, points: u32) -> Vec<f32> {
    let new_len = (data.len() as f32 * factor) as usize;
    let mut output = Vec::with_capacity(new_len);
    
    for i in 0..new_len {
        let pos = i as f32 / factor;
        output.push(interpolate_high_quality(data, pos, points));
    }
    output
}

fn interpolate_high_quality(data: &[f32], pos: f32, _points: u32) -> f32 {
    let idx = pos as usize;
    if idx >= data.len() - 1 { return 0.0; }
    
    let frac = pos - idx as f32;
    let s0 = if idx > 0 { data[idx-1] } else { data[idx] };
    let s1 = data[idx];
    let s2 = data[idx+1];
    let s3 = if idx + 2 < data.len() { data[idx+2] } else { s2 };
    
    let a = -0.5*s0 + 1.5*s1 - 1.5*s2 + 0.5*s3;
    let b = s0 - 2.5*s1 + 2.0*s2 - 0.5*s3;
    let c = -0.5*s0 + 0.5*s2;
    let d = s1;
    
    a*frac*frac*frac + b*frac*frac + c*frac + d
}
