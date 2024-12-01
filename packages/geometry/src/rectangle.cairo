use geometry::traits::Geometry;

// annotation implements the drop trait
// this is needed since there is no garbage collection
#[derive(Drop)]
pub struct Rectangle {
    pub height: u64,
    pub width: u64,
}

pub impl RectangleImpl of Geometry<Rectangle> {
    fn boundary(self: @Rectangle) -> u64 {
        // the '*' reffers to the 'despan' operator
        // which serves as the oposite of the 'snapshot'.
        // It enables us to return a u64 instead of an @u64.
        2 * (*self.height + *self.width)
    }

    fn area(self: @Rectangle) -> u64 {
        *self.height * *self.width
    }
}
