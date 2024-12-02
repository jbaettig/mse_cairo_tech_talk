use geometry::traits::Geometry;
use geometry::traits::CircleGeometry;

pub const PI: u64 = 3_u64; // sorry!

// annotation implements the drop trait
#[derive(Drop)]
pub struct Circle {
    pub radius: u64,
}

// circle also implements the Geometry trait
pub impl CircleImpl of Geometry<Circle> {
    fn boundary(self: @Circle) -> u64 {
        // the '*' refers to the 'despan' operator
        // which serves as the oposite of the 'snapshot'.
        // It enables us to return a u64 instead of an @u64.
        2 * PI * *self.radius
    }

    fn area(self: @Circle) -> u64 {
        PI * *self.radius * *self.radius
    }
}

// we can implement multiple traits for a type
pub impl CircleExtendedImpl of CircleGeometry<Circle> {
    fn diameter(self: @Circle) -> u64 {
        2 * *self.radius
    }
}
