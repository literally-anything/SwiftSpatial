public import simd
public import RealModule

/// A point in a 3D coordinate system.
public struct Point3D: Sendable, Codable, Hashable {
    /// The raw simd three-element vector that contains the x, y, and z coordinates.
    public var vector: SIMD3<Double>
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
    /// The z coordinate value.
    @inlinable public var z: Double {
        get { vector.z }
        set(newValue) { vector.z = newValue }
    }
    
    /// Creates a point that is zero.
    @inlinable public init() {
        self.init(vector: .zero)
    }
    /// Creates a point from the specified double-precision values.
    /// - Parameters:
    ///     - x: A double-precision value that specifies the x coordinate value.
    ///     - y: A double-precision value that specifies the y coordinate value.
    ///     - z: A double-precision value that specifies the z coordinate value.
    @inlinable public init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.init(vector: .init(x: x, y: y, z: z))
    }
    /// Creates a point from the specified floating-point values.
    /// - Parameters:
    ///     - x: A floating-point value that specifies the x coordinate value.
    ///     - y: A floating-point value that specifies the y coordinate value.
    ///     - z: A floating-point value that specifies the z coordinate value.
    @inlinable public init<T>(x: T, y: T, z: T) where T : BinaryFloatingPoint {
        self.init(x: Double(x), y: Double(y), z: Double(z))
    }
    /// Creates a point from the specified single-precision vector.
    /// - Parameters:
    ///     - xyz: A single-precision vector that specifies the coordinates.
    @inlinable public init(_ xyz: SIMD3<Float>) {
        self.init(x: Double(xyz.x),
                  y: Double(xyz.y),
                  z: Double(xyz.z))
    }
    /// Creates a point from the specified double-precision vector.
    /// - Parameters:
    ///     - xyz: A double-precision vector that specifies the coordinates.
    @inlinable public init(_ xyz: SIMD3<Double>) {
        self.init(vector: xyz)
    }
    /// Creates a point from the specified Spatial vector.
    /// - Parameters:
    ///     - xyz: A vector that specifies the coordinates.
    @inlinable public init(_ xyz: Vector3D) {
        self.init(vector: xyz.vector)
    }
    /// Creates a point from the specified Spatial size structure.
    /// - Parameters:
    ///     - size: A size structure that specifies the coordinates.
    @inlinable public init(_ size: Size3D) {
        self.init(vector: size.vector)
    }
//    /// Creates a Spatial point that represents the Cartesian coordinates of the specified spherical coordinates structure.
//    /// - Parameters:
//    ///     - coords: A spherical coordinate that specifies the coordinates.
//    @inlinable public init(_ coords: SphericalCoordinates3D) {
//    }
    /// Creates a point from the specified double-precision vector.
    /// - Parameters:
    ///     - vector: A double-precision vector that specifies the coordinates.
    @inlinable public init(vector: SIMD3<Double>) {
        self.vector = vector
    }
    
    /// Returns the euclidian distance between two points.
    /// - Parameters:
    ///     - other: The second point that the function measures the distance to.
    /// - Returns: The euclidian distance between the two points.
    @inlinable public func distance(to other: Point3D) -> Double {
        let difference = other.vector - vector
        return (difference * difference).sum().squareRoot()
    }
}

extension Point3D: ExpressibleByArrayLiteral {
    /// Initialize the point using an array of components.
    /// The array should only ever be of length 3.
    /// - Parameters:
    ///     - arrayLiteral: The array of length 3 that defines the x, y, and z components.
    @inlinable public init(arrayLiteral elements: Double...) {
        assert(elements.count == 3, "Point3D only has 3 elements.")

        self.init(x: elements[0], y: elements[1], z: elements[2])
    }
}

extension Point3D: ApproximatelyEquatable {
    @inlinable public func isApproximatelyEqual(to other: Point3D,
                                                relativeTolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        x.isApproximatelyEqual(to: other.x, relativeTolerance: relativeTolerance) &&
        y.isApproximatelyEqual(to: other.y, relativeTolerance: relativeTolerance) &&
        z.isApproximatelyEqual(to: other.z, relativeTolerance: relativeTolerance)
    }

    @inlinable public func isApproximatelyEqual(to other: Point3D,
                                                absoluteTolerance: Double, relativeTolerance: Double = 0) -> Bool {
        x.isApproximatelyEqual(to: other.x, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance) &&
        y.isApproximatelyEqual(to: other.y, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance) &&
        z.isApproximatelyEqual(to: other.z, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}

extension Point3D: Primitive3D {
    /// The point with infinite x-, y-, and z-coordinate values.
    public static let infinity: Point3D = .init(x: .infinity, y: .infinity, z: .infinity)
    /// The point with the zero value.
    public static let zero: Point3D = .init()

    /// A Boolean value that indicates whether the point is zero.
    @inlinable public var isZero: Bool {
        x.isZero
        && y.isZero
        && z.isZero
    }
    /// A Boolean value that indicates whether all of the coordinates of the point are finite.
    @inlinable public var isFinite: Bool {
        x.isFinite
        && y.isFinite
        && z.isFinite
    }
    /// A Boolean value that indicates whether the point contains any NaN values.
    @inlinable public var isNaN: Bool {
        x.isNaN
        || y.isNaN
        || z.isNaN
    }
    
    @inlinable public mutating func apply(_ pose: Pose3D) {
        vector += pose.position.vector
        self.rotate(by: pose.rotation)
    }
    
    @inlinable public mutating func apply(_ scaledPose: ScaledPose3D) {
        vector += scaledPose.position.vector
        rotate(by: scaledPose.rotation)
        vector *= scaledPose.scale
    }
}

extension Point3D: Translatable3D {
    /// Offsets the point by the specified vector.
    /// - Parameters:
    ///     - vector: The vector that defines the translation.
    @inlinable public mutating func translate(by vector: Vector3D) {
        assert(vector.isFinite)
        
        self += vector
    }
}

extension Point3D: Rotatable3D {
    /// Rotates the point by the specified quaternion.
    /// - Parameters:
    ///     - quaternion: The double-precision quaternion that specifies the rotation.
    @inlinable public mutating func rotate(by quaternion: simd_quatd) {
        rotate(by: quaternion, around: .zero)
    }
    /// Rotates the point by a quaternion around the specified point.
    /// - Parameters:
    ///     - quaternion: The double-precision quaternion that specifies the rotation.
    ///     - pivot: A point that defines the rotation pivot.
    @inlinable public mutating func rotate(
        by quaternion: simd_quatd,
        around pivot: Point3D
    ) {
        vector = quaternion.act(vector - pivot.vector) + pivot.vector
    }
    
    /// Returns a point that results from rotating with the specified quaternion.
    /// - Parameters:
    ///     - quaternion: The double-precision quaternion that specifies the rotation.
    /// - Returns: The point that results from rotating with the specified quaternion.
    @inlinable public func rotated(by quaternion: simd_quatd) -> Point3D {
        rotated(by: quaternion, around: .zero)
    }
    /// Returns a point that results from rotating with a quaternion around the specified point.
    /// - Parameters:
    ///     - quaternion: The double-precision quaternion that specifies the rotation.
    ///     - pivot: A point that defines the rotation pivot.
    /// - Returns: The point that results from rotating with the specified quaternion.
    @inlinable public func rotated(
        by quaternion: simd_quatd,
        around pivot: Point3D
    ) -> Point3D {
        var p = self
        p.rotate(by: quaternion, around: pivot)
        return p
    }
}

extension Point3D {
    /// Returns a the specified point unchanged.
    /// - Parameters:
    ///     - point: The point that gets returned.
    @inlinable public static prefix func + (point: Point3D) -> Point3D {
        point
    }
    /// Returns a point that’s the element-wise sum of a point and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Point3D, rhs: Size3D) -> Point3D {
        var p = lhs
        p += rhs
        return p
    }
    /// Returns a point that’s the element-wise sum of a size and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Size3D, rhs: Point3D) -> Point3D {
        var p = rhs
        p += lhs
        return p
    }
    /// Adds a point and a vector, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Point3D, rhs: Vector3D) {
        lhs.vector += rhs.vector
    }
    /// Adds a point and a size, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Point3D, rhs: Size3D) {
        lhs.vector += rhs.vector
    }
    
    /// Returns a point that’s the element-wise negation of the point.
    /// - Parameters:
    ///     - point: The value that the operator negates.
    @inlinable public static prefix func - (point: Point3D) -> Point3D {
        .init(vector: -point.vector)
    }
    /// Returns a point that’s the element-wise difference of a point and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Point3D, rhs: Size3D) -> Point3D {
        var p = lhs
        p -= rhs
        return p
    }
    /// Returns a point that’s the element-wise difference of a size and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Size3D, rhs: Point3D) -> Point3D {
        var p = rhs
        p -= lhs
        return p
    }
    /// Returns a vector that’s the element-wise difference of two points.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Point3D, rhs: Point3D) -> Vector3D {
        .init(vector: lhs.vector - rhs.vector)
    }
    /// Subtracts a vector from a point and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Point3D, rhs: Vector3D) {
        lhs.vector -= rhs.vector
    }
    /// Subtracts a size from a point and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Point3D, rhs: Size3D) {
        lhs.vector -= rhs.vector
    }
    
    /// Returns a point that’s the product of a point and a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Point3D, rhs: Double) -> Point3D {
        var p = lhs
        p.vector *= rhs
        return p
    }
    /// Returns a point that’s the product of a scalar value and a vector.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Double, rhs: Point3D) -> Point3D {
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
    @inlinable public static func * (lhs: Pose3D, rhs: Point3D) -> Point3D {
        rhs.applying(lhs)
    }
    /// Multiplies a point and a double-precision value, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout Point3D, rhs: Double) {
        lhs.vector *= rhs
    }
    
    /// Returns a point with each element divided by a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func / (lhs: Point3D, rhs: Double) -> Point3D {
        var p = lhs
        p.vector /= rhs
        return p
    }
    /// Divides a point by a scalar value and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func /= (lhs: inout Point3D, rhs: Double) {
        lhs.vector /= rhs
    }
}

extension Point3D: SIMDStorage {
    @inlinable public var scalarCount: Int { 3 }
    @inlinable public subscript(index: Int) -> Double {
        get {
            vector[index]
        }
        set(newValue) {
            vector[index] = newValue
        }
    }
}

extension Point3D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the point.
    @inlinable public var description: String { "(x: \(x), y: \(y), z: \(z))" }
    /// A textual representation of the point for debugging.
    @inlinable public var debugDescription: String { description }
}
