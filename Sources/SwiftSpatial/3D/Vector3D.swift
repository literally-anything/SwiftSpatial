public import Foundation
public import simd
public import RealModule

/// A three-component vector.
public struct Vector3D: Sendable, Codable, Hashable {
    /// The raw simd three-component vector that contains the x, y, and z components.
    public var vector: SIMD3<Double>
    /// The x component value.
    @inlinable public var x: Double {
        get { vector.x }
        set(newValue) { vector.x = newValue }
    }
    /// The y component value.
    @inlinable public var y: Double {
        get { vector.y }
        set(newValue) { vector.y = newValue }
    }
    /// The z component value.
    @inlinable public var z: Double {
        get { vector.z }
        set(newValue) { vector.z = newValue }
    }
    /// The square of the length of the vector.
    @inlinable public var lengthSquared: Double {
        (vector * vector).sum()
    }
    /// The length of the vector.
    @inlinable public var length: Double {
        lengthSquared.squareRoot()
    }
    /// A new vector that represents the normalized copy of the current vector.
    @inlinable public var normalized: Vector3D {
        var v = self
        v.normalize()
        return v
    }
    
    /// Creates a vector with all component values initialized to 0.
    @inlinable public init() {
        self.init(vector: .zero)
    }
    /// Creates a vector from the specified double-percision values.
    /// - Parameters:
    ///     - x: A double-precision value that specifies the x component.
    ///     - y: A double-precision value that specifies the y component.
    ///     - z: A double-precision value that specifies the z component.
    @inlinable public init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.init(vector: .init(x: x, y: y, z: z))
    }
    /// Creates a vector from the specified floating-point values.
    /// - Parameters:
    ///     - x: A floating-point value that specifies the x component.
    ///     - y: A floating-point value that specifies the y component.
    ///     - z: A floating-point value that specifies the z component.
    @inlinable public init<T>(x: T, y: T, z: T) where T : BinaryFloatingPoint {
        self.init(x: Double(x), y: Double(y), z: Double(z))
    }
    /// Creates a vector from the specified single-percision vector.
    /// - Parameters:
    ///     - xyz: A single-precision vector that specifies the component values.
    @inlinable public init(_ xyz: SIMD3<Float>) {
        self.init(x: Double(xyz.x),
                  y: Double(xyz.y),
                  z: Double(xyz.z))
    }
    /// Creates a vector from the specified double-percision vector.
    /// - Parameters:
    ///     - xyz: A double-percision vector that specifies the component values.
    @inlinable public init(_ xyz: SIMD3<Double>) {
        self.init(vector: xyz)
    }
    /// Creates a vector from the specified Spatial point structure.
    /// - Parameters:
    ///     - point: A point structure that specifies the component values.
    @inlinable public init(_ point: Point3D) {
        self.init(vector: point.vector)
    }
    /// Creates a vector from the specified Spatial size structure.
    /// - Parameters:
    ///     - size: A size structure that specifies the component values.
    @inlinable public init(_ size: Size3D) {
        self.init(vector: size.vector)
    }
//    /// Creates a vector from the specified Spatial spherical coordinates structure.
//    /// - Parameters:
//    ///     - coords: A spherical coordinate that specifies the component values.
//    @inlinable public init(_ coords: SphericalCoordinates3D) {
//    }
    /// Creates a vector from the specified Spatial rotation axis.
    /// - Parameters:
    ///     - axis: A rotation axis that specifies the element values.
    @inlinable public init(_ axis: RotationAxis3D) {
        self.init(vector: axis.vector)
    }
    /// Creates a vector from the specified double-percision vector.
    /// - Parameters:
    ///     - vector: A double-percision vector that specifies the component values.
    @inlinable public init(vector: SIMD3<Double>) {
        self.vector = vector
    }
    
    /// Returns the rotation around the origin from the first vector to the second vector.
    /// - Parameters:
    ///     - other: The second vector that the function computes the rotation to.
    /// - Returns: The rotation between two vectors.
    @inlinable public func rotation(to other: Vector3D) -> Rotation3D {
        let angle = acos(dot(other) / (length * other.length))
        let axis = cross(other).vector
        
        return Rotation3D(quaternion: .init(angle: angle, axis: axis))
    }
    /// Calculates the dot product of the vector and the specified vector.
    /// - Parameters:
    ///     - other: The second vector.
    /// - Returns: The dot product of the vector and the specified vector.
    @inlinable public func dot(_ other: Vector3D) -> Double {
        (other.vector * vector).sum()
    }
    /// Calculates the cross product of the vector and the specified vector.
    /// - Parameters:
    ///     - other: The second vector.
    /// - Returns: The cross product of the vector and the specified vector.
    @inlinable public func cross(_ other: Vector3D) -> Vector3D {
        .init(x: y * other.z - z * other.y,
              y: z * other.x - x * other.z,
              z: x * other.y - y * other.x)
    }
    /// Normalizes the mutable vector.
    @inlinable public mutating func normalize() {
        vector /= length
    }
    /// Returns the vector projected onto the specified vector.
    /// - Parameters:
    ///     - other: The second vector.
    /// - Returns: The vector projected onto the specified vector.
    @inlinable public func projected(_ other: Vector3D) -> Vector3D {
        (dot(other) / other.lengthSquared) * other
    }
    /// Returns the reflection direction of the incident vector and a specified unit normal vector.
    /// - Parameters:
    ///     - normal: The unit normal vector.
    /// - Returns: The reflection direction of the incident vector and a specified unit normal vector.
    @inlinable public func reflected(_ normal: Vector3D) -> Vector3D {
        .init(vector: vector - 2 * dot(normal) * normal.vector)
    }
}

extension Vector3D: ExpressibleByArrayLiteral {
    /// Initialize the vector using an array of components.
    /// The array should only ever be of length 3.
    /// - Parameters:
    ///     - arrayLiteral: The array of length 3 that defines the x, y, and z components.
    @inlinable public init(arrayLiteral elements: Double...) {
        assert(elements.count == 3, "Vector3D only has 3 elements.")

        self.init(x: elements[0], y: elements[1], z: elements[2])
    }
}

extension Vector3D: ApproximatelyEquatable {
    @inlinable public func isApproximatelyEqual(to other: Vector3D,
                                                relativeTolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        dot(other).isApproximatelyEqual(to: 1, relativeTolerance: relativeTolerance)
    }

    @inlinable public func isApproximatelyEqual(to other: Vector3D,
                                                absoluteTolerance: Double, relativeTolerance: Double = 0) -> Bool {
        dot(other).isApproximatelyEqual(to: 1, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}

extension Vector3D: AdditiveArithmetic {
    /// Returns a the specified vector unchanged.
    /// - Parameters:
    ///     - vector: The vector that gets returned.
    @inlinable public static prefix func + (vector: Vector3D) -> Vector3D {
        vector
    }
    /// Returns a vector that’s the element-wise sum of two vectors.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        var v = lhs
        v.vector += rhs.vector
        return v
    }
    /// Returns a size that’s the element-wise sum of a vector and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Vector3D, rhs: Size3D) -> Size3D {
        var s = rhs
        s.vector += lhs.vector
        return s
    }
    /// Returns a size that’s the element-wise sum of a vector and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Size3D, rhs: Vector3D) -> Size3D {
        var s = lhs
        s.vector += rhs.vector
        return s
    }
    /// Returns a point that’s the element-wise sum of a vector and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Vector3D, rhs: Point3D) -> Point3D {
        var v = rhs
        v.vector += lhs.vector
        return v
    }
    /// Returns a point that’s the element-wise sum of a vector and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Point3D, rhs: Vector3D) -> Point3D {
        var v = lhs
        v.vector += rhs.vector
        return v
    }
    /// Adds two vectors and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Vector3D, rhs: Vector3D) {
        lhs.vector += rhs.vector
    }
    
    /// Returns a vector that’s the element-wise negation of the vector.
    /// - Parameters:
    ///     - vector: The value that the operator negates.
    @inlinable public static prefix func - (vector: Vector3D) -> Vector3D {
        .init(vector: -vector.vector)
    }
    /// Returns a size that’s the element-wise difference of two vectors.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Vector3D, rhs: Vector3D) -> Vector3D {
        var v = lhs
        v.vector -= rhs.vector
        return v
    }
    /// Returns a size that’s the element-wise difference of a vector and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Vector3D, rhs: Size3D) -> Size3D {
        var v = rhs
        v.vector -= lhs.vector
        return v
    }
    /// Returns a size that’s the element-wise difference of a vector and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Size3D, rhs: Vector3D) -> Size3D {
        var v = lhs
        v.vector -= rhs.vector
        return v
    }
    /// Returns a point that’s the element-wise difference of a vector and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Vector3D, rhs: Point3D) -> Point3D {
        var v = rhs
        v.vector -= lhs.vector
        return v
    }
    /// Returns a point that’s the element-wise difference of a point and a vector.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Point3D, rhs: Vector3D) -> Point3D {
        var v = lhs
        v.vector -= rhs.vector
        return v
    }
    /// Subtracts a vector from a vector and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Vector3D, rhs: Vector3D) {
        lhs.vector -= rhs.vector
    }
    
    /// Returns a vector that’s the product of a vector and a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Vector3D, rhs: Double) -> Vector3D {
        var v = lhs
        v.vector *= rhs
        return v
    }
    /// Returns a vector that’s the product of a scalar value and a vector.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Double, rhs: Vector3D) -> Vector3D {
        var v = rhs
        v.vector *= lhs
        return v
    }
//    /// Returns the vector that results from applying the affine transform to the vector.
//    /// - Parameters:
//    ///     - lhs: The left-hand-side value.
//    ///     - rhs: The right-hand-side value.
//    @inlinable public static func * (lhs: AffineTransform3D, rhs: Vector3D) -> Vector3D {
//    }
//    /// Returns the vector that results from applying the projective transform to the vector.
//    /// - Parameters:
//    ///     - lhs: The left-hand-side value.
//    ///     - rhs: The right-hand-side value.
//    @inlinable public static func * (lhs: ProjectiveTransform3D, rhs: Vector3D) -> Vector3D {
//    }
    /// Returns a new vector after applying the pose to the vector.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Pose3D, rhs: Vector3D) -> Vector3D {
        rhs.applying(lhs)
    }
    /// Multiplies a vector and a double-precision value, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout Vector3D, rhs: Double) {
        lhs.vector *= rhs
    }
    
    /// Returns a vector with each element divided by a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func / (lhs: Vector3D, rhs: Double) -> Vector3D {
        var v = lhs
        v.vector /= rhs
        return v
    }
    /// Divides a vector by a scalar value and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func /= (lhs: inout Vector3D, rhs: Double) {
        lhs.vector /= rhs
    }
}

extension Vector3D: Primitive3D {
    /// A vector that contains the values 0, 0, 1.
    public static let forward: Vector3D = .init(x: 0, y: 0, z: 1)
    /// A vector that contains the values 1, 0, 0.
    public static let right: Vector3D = .init(x: 1, y: 0, z: 0)
    /// A vector that contains the values 0, 1, 0.
    public static let up: Vector3D = .init(x: 0, y: 1, z: 0)
    /// A vector that contains all infinities.
    public static let infinity: Vector3D = .init(x: .infinity, y: .infinity, z: .infinity)
    /// A vector that contains all zeros.
    public static let zero: Vector3D = .init()

    /// A Boolean value that indicates whether the vector is zero.
    @inlinable public var isZero: Bool {
        x.isZero
        && y.isZero
        && z.isZero
    }
    /// A Boolean value that indicates whether all the components of the vector are finite.
    @inlinable public var isFinite: Bool {
        x.isFinite
        && y.isFinite
        && z.isFinite
    }
    /// A Boolean value that indicates whether the vector contains any NaN values.
    @inlinable public var isNaN: Bool {
        x.isNaN
        || y.isNaN
        || z.isNaN
    }
    
    @inlinable public mutating func apply(_ pose: Pose3D) {
        vector += pose.position.vector
        rotate(by: pose.rotation)
    }
    
    @inlinable public mutating func apply(_ scaledPose: ScaledPose3D) {
        vector += scaledPose.position.vector
        rotate(by: scaledPose.rotation)
        vector *= scaledPose.scale
    }
}

extension Vector3D: Rotatable3D {
    /// Rotates the vector by the specified quaternion.
    /// - Parameters:
    ///     - quaternion: The double-precision quaternion that specifies the rotation.
    @inlinable public mutating func rotate(by quaternion: simd_quatd) {
//        assert(quaternion.length.isAlmostEqual(to: 1))
        
        vector = quaternion.act(vector)
    }
}

extension Vector3D: Scalable3D {
    /// Scales the vector using the specified size structure.
    /// - Parameters:
    ///     - size: The size structure to scale using.
    public mutating func scale(by size: Size3D) {
        assert(size.isFinite)
        
        vector *= size.vector
    }
    /// Scales the vector using the specified double-precision values.
    /// - Parameters:
    ///     - x: The double-precision value that specifies the scale for the x component.
    ///     - y: The double-precision value that specifies the scale for the y component.
    ///     - z: The double-precision value that specifies the scale for the z component.
    @inlinable public mutating func scaleBy(x: Double, y: Double, z: Double) {
        assert(x.isFinite && y.isFinite && z.isFinite)
        
        vector *= SIMD3<Double>(x: x, y: y, z: z)
    }
    /// Uniformly scales the vector using the specified double-precision value.
    /// - Parameters:
    ///     - scale: The double-precision value that specifies the uniform scale.
    @inlinable public mutating func uniformlyScale(by scale: Double) {
        assert(scale.isFinite)
        
        vector *= scale
    }
}

extension Vector3D: Shearable3D {
}

extension Vector3D: SIMDStorage {
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

extension Vector3D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the vector.
    @inlinable public var description: String { "(x: \(x), y: \(y), z: \(z))" }
    /// A textual representation of the vector for debugging.
    @inlinable public var debugDescription: String { description }
}
