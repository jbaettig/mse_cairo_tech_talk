use geometry::traits::Geometry;

#[derive(Drop)]
pub struct Rectangle {
    pub height: u64,
    pub width: u64,
}

pub impl RectangleImpl of Geometry<Rectangle> {
    fn boundary(self: @Rectangle) -> u64 {
        2 * (*self.height + *self.width)
    }

    fn area(self: @Rectangle) -> u64 {
        *self.height * *self.width
    }
}
