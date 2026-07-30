#[derive(Clone, Debug)]
pub struct AutomationPoint {
    pub time: f32,  // Позиция в тактах (например, 1.0, 1.5)
    pub value: f32, // Значение от 0.0 до 1.0
    pub curve: f32, // Тип кривой (0.0 - линейная, >0 - выпуклая, <0 - вогнутая)
}

pub struct AutomationClip {
    pub points: Vec<AutomationPoint>,
    pub target_param_id: String,
}

impl AutomationClip {
    pub fn new(target_id: &str) -> Self {
        Self {
            points: Vec::new(),
            target_param_id: target_id.to_string(),
        }
    }

    pub fn add_point(&mut self, time: f32, value: f32, curve: f32) {
        self.points.push(AutomationPoint { time, value, curve });
        self.points.sort_by(|a, b| a.time.partial_cmp(&b.time).unwrap());
    }

    pub fn get_value_at(&self, time: f32) -> f32 {
        if self.points.is_empty() {
            return 0.0;
        }
        if time <= self.points[0].time {
            return self.points[0].value;
        }
        if time >= self.points.last().unwrap().time {
            return self.points.last().unwrap().value;
        }

        // Поиск сегмента
        for i in 0..self.points.len() - 1 {
            let p1 = &self.points[i];
            let p2 = &self.points[i + 1];
            if time >= p1.time && time <= p2.time {
                let t = (time - p1.time) / (p2.time - p1.time);
                return self.interpolate(p1.value, p2.value, t, p1.curve);
            }
        }
        0.0
    }

    fn interpolate(&self, v1: f32, v2: f32, t: f32, curve: f32) -> f32 {
        if curve == 0.0 {
            v1 + (v2 - v1) * t
        } else {
            // Упрощенная модель кривой (power function)
            if curve > 0.0 {
                v1 + (v2 - v1) * t.powf(1.0 + curve)
            } else {
                v1 + (v2 - v1) * (1.0 - (1.0 - t).powf(1.0 - curve))
            }
        }
    }
}
