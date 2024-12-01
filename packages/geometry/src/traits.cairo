pub trait Geometry<T> {
    // takes a 'snapshot' (immutable view) of
    // type T at a certain point in time
    fn boundary(self: @T) -> u64;
    fn area(self: @T) -> u64;
}

pub trait CircleGeometry<T> {
    fn diameter(self: @T) -> u64;
}
