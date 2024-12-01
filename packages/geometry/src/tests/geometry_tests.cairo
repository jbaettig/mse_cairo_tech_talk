use geometry::traits::{Geometry, CircleGeometry};

use geometry::rectangle::Rectangle;
use geometry::square::Square;
use geometry::circle::{Circle, PI};

#[test]
fn test_rectangle_boundary() {
    let rectangle = Rectangle { height: 50_u64, width: 100_u64 };

    // test rectangle boundary
    let boundary = 2 * rectangle.height + 2 * rectangle.width;
    assert_eq!(boundary, rectangle.boundary());

    // we could still use 'rectangle' here since boundary()
    // providede by the Geometry trait takes a snapshot.
}

#[test]
fn test_rectangle_area() {
    let rectangle = Rectangle { height: 50_u64, width: 100_u64 };

    // test rectangle area
    let area = rectangle.height * rectangle.width;
    assert_eq!(area, rectangle.area());
}

#[test]
fn test_square_boundary() {
    let square = Square { side: 50_u64 };

    // test square boundary
    let boundary = 4 * square.side;
    assert_eq!(boundary, square.boundary());
}

#[test]
fn test_square_area() {
    let square = Square { side: 50_u64 };

    // test square area
    let area = square.side * square.side;
    assert_eq!(area, square.area());
}


fn test_circle_boundary() {
    let circle = Circle { radius: 15_u64 };

    // test circle boundary
    let boundary = 2 * PI * circle.radius;
    assert_eq!(boundary, circle.boundary());
}

#[test]
fn test_circle_area() {
    let circle = Circle { radius: 15_u64 };

    // test circle area
    let area = PI * circle.radius * circle.radius;
    assert_eq!(area, circle.area());
}

#[test]
fn test_circle_diameter() {
    let circle = Circle { radius: 15_u64 };

    // test circle diameter
    let diameter = 2 * circle.radius;
    assert_eq!(diameter, circle.diameter());
}
