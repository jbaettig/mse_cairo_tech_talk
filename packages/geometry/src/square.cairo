use geometry::traits::Geometry;

#[derive(Drop)]
pub struct Square {
    pub side: u64,
}

pub impl SquareImpl of Geometry<Square> {
    fn boundary(self: @Square) -> u64 {
        4 * *self.side
    }

    fn area(self: @Square) -> u64 {
        *self.side * *self.side
    }
}
