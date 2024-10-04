public import Foundation
public import RealModule

/// A point in a 2D coordinate system represented by a magnitude and an angle.
public struct PolarCoordinates2D: Sendable, Codable, Hashable {
    /// The angle of the point.
    public var angle: Angle2D
    /// The magnitude or distance to the point.
    public var magnitude: Double

    /// Initiaalize from the specified 2D point.
    /// - Parameters:
    ///     - point: The point to initialize from.
    @inlinable public init(_ point: Point2D) {
        self.init(vector: point.vector)
    }
    /// Initiaalize from the specified 2D vector.
    /// - Parameters:
    ///     - vector: The vector to initialize from.
    @inlinable public init(_ vector: Vector2D) {
        self.init(vector: vector.vector)
    }
    /// Initiaalize from the specified 2D size.
    /// - Parameters:
    ///     - size: The size to initialize from.
    @inlinable public init(_ size: Size2D) {
        self.init(vector: size.vector)
    }
    /// Initiaalize from the specified SIMD vector with x and y coordinates.
    /// - Parameters:
    ///     - vector: The SIMD vector to use as x and y coodinates.
    @inlinable public init(vector: SIMD2<Double>) {
        self.init(angle: .atan2(y: vector.y, x: vector.x),
                  magnitude: (vector * vector).sum().squareRoot())
    }
    /// Initiaalize from the specified x and y coordinates.
    /// - Parameters:
    ///     - x: The x coordinate.
    ///     - y: The y coordinate.
    @inlinable public init(x: Double, y: Double) {
        self.init(angle: .atan2(y: y, x: x),
                  magnitude: sqrt(pow(x, 2) + pow(y, 2)))
    }
    /// Initialize the polar coodinates with an angle and a magnitude.
    @inlinable public init(angle: Angle2D, magnitude: Double) {
        self.angle = angle
        self.magnitude = magnitude
    }
}

extension PolarCoordinates2D: ApproximatelyEquatable {
    @inlinable public func isApproximatelyEqual(to other: PolarCoordinates2D,
                                                relativeTolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        angle.isApproximatelyEqual(to: other.angle, relativeTolerance: relativeTolerance) &&
        magnitude.isApproximatelyEqual(to: other.magnitude, relativeTolerance: relativeTolerance)
    }
    
    @inlinable public func isApproximatelyEqual(to other: PolarCoordinates2D,
                                                absoluteTolerance: Double, relativeTolerance: Double = 0) -> Bool {
        angle.isApproximatelyEqual(to: other.angle, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance) &&
        magnitude.isApproximatelyEqual(to: other.magnitude, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}

extension PolarCoordinates2D: Rotatable2D {
    @inlinable public mutating func rotate(by angle: Angle2D) {
        self.angle.rotate(by: angle)
    }
    
    @inlinable public mutating func flip(along axis: Axis2D) {
        angle.flip(along: axis)
    }
}

extension PolarCoordinates2D: Scalable2D {
    @inlinable public mutating func scale(by size: Size2D) {
        let cos = angle.cos
        let sin = angle.sin
        
        angle = .atan2(y: sin * size.width, x: cos * size.height)

        let vector = SIMD2<Double>(x: cos, y: sin) * magnitude
        let newVector = size.vector * vector
        magnitude = (newVector * newVector).sum().squareRoot()
    }
    
    @inlinable public mutating func scaleBy(x: Double, y: Double) {
        let newX = angle.cos * x
        let newY = angle.sin * y

        angle = .atan2(y: newY, x: newX)
        magnitude = (pow(newX, 2) + pow(newY, 2)).squareRoot()
    }
    
    @inlinable public mutating func uniformlyScale(by scale: Double) {
        magnitude *= scale
    }
}

extension PolarCoordinates2D: CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable public var description: String { "PolarCoordinates2D(angle: \(angle), magnitude: \(magnitude))" }
    @inlinable public var debugDescription: String { description }
}
