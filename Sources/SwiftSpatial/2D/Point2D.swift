import simd
public import RealModule

/// A point in a 2D coordinate system.
public struct Point2D: Sendable, Codable, Hashable {
    /// The raw simd three-element vector that contains the x, y, and z coordinates.
    public var vector: SIMD2<Double>
    /// The x coordinate value.
    @inlinable public var x: Double {
        get { vector.x }
        set(newValue) { vector.x = newValue }
    }
    /// The y coordinate value.
    @inlinable public var y: Double {
        get { vector.y }
        set(newValue) { vector.y = newValue }
    }
    
    /// Creates a point that is zero.
    @inlinable public init() {
        self.init(vector: .zero)
    }
    /// Creates a point from the specified double-precision values.
    /// - Parameters:
    ///     - x: A double-precision value that specifies the x coordinate value.
    ///     - y: A double-precision value that specifies the y coordinate value.
    @inlinable public init(x: Double = 0, y: Double = 0) {
        self.init(vector: .init(x: x, y: y))
    }
    /// Creates a point from the specified floating-point values.
    /// - Parameters:
    ///     - x: A floating-point value that specifies the x coordinate value.
    ///     - y: A floating-point value that specifies the y coordinate value.
    @inlinable public init<T>(x: T, y: T) where T : BinaryFloatingPoint {
        self.init(x: Double(x), y: Double(y))
    }
    /// Creates a point from the specified single-precision vector.
    /// - Parameters:
    ///     - xyz: A single-precision vector that specifies the coordinates.
    @inlinable public init(_ xyz: SIMD2<Float>) {
        self.init(x: Double(xyz.x),
                  y: Double(xyz.y))
    }
    /// Creates a point from the specified double-precision vector.
    /// - Parameters:
    ///     - xyz: A double-precision vector that specifies the coordinates.
    @inlinable public init(_ xyz: SIMD2<Double>) {
        self.init(vector: xyz)
    }
    /// Creates a point from the specified Spatial vector.
    /// - Parameters:
    ///     - xyz: A vector that specifies the coordinates.
    @inlinable public init(_ xyz: Vector2D) {
        self.init(vector: xyz.vector)
    }
    /// Creates a point from the specified Spatial size structure.
    /// - Parameters:
    ///     - size: A size structure that specifies the coordinates.
    @inlinable public init(_ size: Size2D) {
        self.init(vector: size.vector)
    }
    /// Creates a point from the specified 2D polar coordinates structure.
    /// - Parameters:
    ///     - polar: A polar coordinates structure to convert.
    @inlinable public init(_ polar: PolarCoordinates2D) {
        self.init(vector: .init(
            x: polar.angle.cos * polar.magnitude,
            y: polar.angle.sin * polar.magnitude
        ))
    }
    /// Creates a point from the specified double-precision vector.
    /// - Parameters:
    ///     - vector: A double-precision vector that specifies the coordinates.
    @inlinable public init(vector: SIMD2<Double>) {
        self.vector = vector
    }
    
    /// Returns the euclidian distance between two points.
    /// - Parameters:
    ///     - other: The second point that the function measures the distance to.
    /// - Returns: The euclidian distance between the two points.
    @inlinable public func distance(to other: Point2D) -> Double {
        let difference = other.vector - vector
        return (difference * difference).sum().squareRoot()
    }
}

extension Point2D: ExpressibleByArrayLiteral {
    @inlinable public init(arrayLiteral elements: Double...) {
        assert(elements.count == 2, "Point2D only has 2 elements.")

        self.init(x: elements.first!, y: elements.last!)
    }
}

extension Point2D: ApproximatelyEquatable {
    @inlinable public func isApproximatelyEqual(to other: Point2D,
                                                relativeTolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        x.isApproximatelyEqual(to: other.x, relativeTolerance: relativeTolerance) &&
        y.isApproximatelyEqual(to: other.y, relativeTolerance: relativeTolerance)
    }

    @inlinable public func isApproximatelyEqual(to other: Point2D,
                                                absoluteTolerance: Double, relativeTolerance: Double = 0) -> Bool {
        x.isApproximatelyEqual(to: other.x, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance) &&
        y.isApproximatelyEqual(to: other.y, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}

extension Point2D: Primitive2D {
    /// The point with infinite x- and y-coordinate values.
    public static let infinity: Point2D = .init(x: .infinity, y: .infinity)
    /// The point with the zero value.
    public static let zero: Point2D = .init()

    /// A Boolean value that indicates whether the point is zero.
    @inlinable public var isZero: Bool {
        x.isZero
        && y.isZero
    }
    /// A Boolean value that indicates whether all of the coordinates of the point are finite.
    @inlinable public var isFinite: Bool {
        x.isFinite
        && y.isFinite
    }
    /// A Boolean value that indicates whether the point contains any NaN values.
    @inlinable public var isNaN: Bool {
        x.isNaN
        || y.isNaN
    }

    @inlinable public mutating func apply(_ pose: Pose2D) {
        vector += pose.position.vector
        self.rotate(by: pose.angle)
    }
    
//    @inlinable public mutating func apply(_ scaledPose: ScaledPose2D) {
//        vector += scaledPose.position.vector
//        rotate(by: scaledPose.rotation)
//        vector *= scaledPose.scale
//    }
}

extension Point2D: Translatable2D {
    /// Offsets the point by the specified vector.
    /// - Parameters:
    ///     - vector: The vector that defines the translation.
    @inlinable public mutating func translate(by vector: Vector2D) {
        assert(vector.isFinite)
        
        self += vector
    }
}

extension Point2D: Rotatable2D {
    @inlinable public mutating func rotate(by angle: Angle2D) {
        rotate(by: angle, around: .zero)
    }
    /// Rotates the point by an angle around the specified point.
    /// - Parameters:
    ///     - angle: The angle that specifies the rotation.
    ///     - pivot: A point that defines the rotation pivot.
    @inlinable public mutating func rotate(
        by angle: Angle2D,
        around pivot: Point2D
    ) {
        let angleCos = angle.cos
        let angleSin = angle.sin
        vector = .init(
            x: angleCos * (x - pivot.x) - angleSin * (y - pivot.y) + pivot.x,
            y: angleSin * (x - pivot.x) + angleCos * (y - pivot.y) + pivot.y
        )
    }
    @inlinable public mutating func flip(along axis: Axis2D) {
        switch axis {
        case .x:
            x.negate()
        case .y:
            y.negate()
        }
    }
    
    /// Returns the point rotated by an angle around the specified point.
    /// - Parameters:
    ///     - angle: The angle that specifies the rotation.
    ///     - pivot: A point that defines the rotation pivot.
    @inlinable public func rotated(
        by angle: Angle2D,
        around pivot: Point2D
    ) -> Point2D {
        var point = self
        point.rotate(by: angle, around: pivot)
        return point
    }
}

extension Point2D {
    /// Returns a the specified point unchanged.
    /// - Parameters:
    ///     - point: The point that gets returned.
    @inlinable public static prefix func + (point: Point2D) -> Point2D {
        point
    }
    /// Returns a point that’s the element-wise sum of a point and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Point2D, rhs: Size2D) -> Point2D {
        var p = lhs
        p += rhs
        return p
    }
    /// Returns a point that’s the element-wise sum of a size and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Size2D, rhs: Point2D) -> Point2D {
        var p = rhs
        p += lhs
        return p
    }
    /// Adds a point and a vector, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Point2D, rhs: Vector2D) {
        lhs.vector += rhs.vector
    }
    /// Adds a point and a size, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Point2D, rhs: Size2D) {
        lhs.vector += rhs.vector
    }
    
    /// Returns a point that’s the element-wise negation of the point.
    /// - Parameters:
    ///     - point: The value that the operator negates.
    @inlinable public static prefix func - (point: Point2D) -> Point2D {
        .init(vector: -point.vector)
    }
    /// Returns a point that’s the element-wise difference of a point and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Point2D, rhs: Size2D) -> Point2D {
        var p = lhs
        p -= rhs
        return p
    }
    /// Returns a point that’s the element-wise difference of a size and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Size2D, rhs: Point2D) -> Point2D {
        var p = rhs
        p -= lhs
        return p
    }
    /// Returns a vector that’s the element-wise difference of two points.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Point2D, rhs: Point2D) -> Vector2D {
        .init(vector: lhs.vector - rhs.vector)
    }
    /// Subtracts a vector from a point and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Point2D, rhs: Vector2D) {
        lhs.vector -= rhs.vector
    }
    /// Subtracts a size from a point and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Point2D, rhs: Size2D) {
        lhs.vector -= rhs.vector
    }
    
    /// Returns a point that’s the product of a point and a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Point2D, rhs: Double) -> Point2D {
        var p = lhs
        p.vector *= rhs
        return p
    }
    /// Returns a point that’s the product of a scalar value and a vector.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Double, rhs: Point2D) -> Point2D {
        var p = rhs
        p.vector *= lhs
        return p
    }
//    /// Returns the point that results from applying the affine transform to the point.
//    /// - Parameters:
//    ///     - lhs: The left-hand-side value.
//    ///     - rhs: The right-hand-side value.
//    @inlinable public static func * (lhs: AffineTransform3D, rhs: Point3D) -> Point3D {
//    }
//    /// Returns the point that results from applying the projective transform to the point.
//    /// - Parameters:
//    ///     - lhs: The left-hand-side value.
//    ///     - rhs: The right-hand-side value.
//    @inlinable public static func * (lhs: ProjectiveTransform3D, rhs: Point3D) -> Point3D {
//    }
    /// Returns a new point after applying the pose to the point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Pose2D, rhs: Point2D) -> Point2D {
        rhs.applying(lhs)
    }
    /// Multiplies a point and a double-precision value, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout Point2D, rhs: Double) {
        lhs.vector *= rhs
    }
    
    /// Returns a point with each element divided by a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func / (lhs: Point2D, rhs: Double) -> Point2D {
        var p = lhs
        p.vector /= rhs
        return p
    }
    /// Divides a point by a scalar value and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func /= (lhs: inout Point2D, rhs: Double) {
        lhs.vector /= rhs
    }
}

extension Point2D: SIMDStorage {
    @inlinable public var scalarCount: Int { 2 }
    @inlinable public subscript(index: Int) -> Double {
        get {
            vector[index]
        }
        set(newValue) {
            vector[index] = newValue
        }
    }
}

extension Point2D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the point.
    @inlinable public var description: String { "Point2D(x: \(x), y: \(y))" }
    /// A textual representation of the point for debugging.
    @inlinable public var debugDescription: String { description }
}
