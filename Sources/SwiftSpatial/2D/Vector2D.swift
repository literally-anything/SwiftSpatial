import Foundation
import simd

/// A three-component vector.
public struct Vector2D: Sendable, Codable, Hashable {
    /// The raw simd three-component vector that contains the x and y components.
    public var vector: SIMD2<Double>
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
    /// The square of the length of the vector.
    @inlinable public var lengthSquared: Double {
        (vector * vector).sum()
    }
    /// The length of the vector.
    @inlinable public var length: Double {
        lengthSquared.squareRoot()
    }
    /// A new vector that represents the normalized copy of the current vector.
    @inlinable public var normalized: Vector2D {
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
    @inlinable public init(x: Double = 0, y: Double = 0) {
        self.init(vector: .init(x: x, y: y))
    }
    /// Creates a vector from the specified floating-point values.
    /// - Parameters:
    ///     - x: A floating-point value that specifies the x component.
    ///     - y: A floating-point value that specifies the y component.
    @inlinable public init<T>(x: T, y: T) where T : BinaryFloatingPoint {
        self.init(x: Double(x), y: Double(y))
    }
    /// Creates a vector from the specified single-percision vector.
    /// - Parameters:
    ///     - xyz: A single-precision vector that specifies the component values.
    @inlinable public init(_ xyz: SIMD2<Float>) {
        self.init(x: Double(xyz.x),
                  y: Double(xyz.y))
    }
    /// Creates a vector from the specified double-percision vector.
    /// - Parameters:
    ///     - xyz: A double-percision vector that specifies the component values.
    @inlinable public init(_ xyz: SIMD2<Double>) {
        self.init(vector: xyz)
    }
    /// Creates a vector from the specified Spatial point structure.
    /// - Parameters:
    ///     - point: A point structure that specifies the component values.
    @inlinable public init(_ point: Point2D) {
        self.init(vector: point.vector)
    }
    /// Creates a vector from the specified 2D size structure.
    /// - Parameters:
    ///     - size: A size structure that specifies the component values.
    @inlinable public init(_ size: Size2D) {
        self.init(vector: size.vector)
    }
    /// Creates a unit vector from the specified 2D angle.
    /// - Parameters:
    ///     - angle: The angle that specifies the direction..
    @inlinable public init(_ angle: Angle2D) {
        self.init(vector: .init(x: angle.cos,
                                y: angle.sin))
    }
    /// Creates a vector from the specified double-percision vector.
    /// - Parameters:
    ///     - vector: A double-percision vector that specifies the component values.
    @inlinable public init(vector: SIMD2<Double>) {
        self.vector = vector
    }
    
//    /// Returns the rotation around the origin from the first vector to the second vector.
//    /// - Parameters:
//    ///     - other: The second vector that the function computes the rotation to.
//    /// - Returns: The rotation between two vectors.
//    @inlinable public func rotation(to other: Vector2D) -> Rotation2D {
//        let angle = acos(dot(other) / (length * other.length))
//        let axis = cross(other).vector
//        
//        return Rotation3D(quaternion: .init(angle: angle, axis: axis))
//    }
    /// Calculates the dot product of the vector and the specified vector.
    /// - Parameters:
    ///     - other: The second vector.
    /// - Returns: The dot product of the vector and the specified vector.
    @inlinable public func dot(_ other: Vector2D) -> Double {
        (other.vector * vector).sum()
    }
//    /// Calculates the cross product of the vector and the specified vector.
//    /// - Parameters:
//    ///     - other: The second vector.
//    /// - Returns: The cross product of the vector and the specified vector.
//    @inlinable public func cross(_ other: Vector3D) -> Vector3D {
//        .init(x: y * other.z - z * other.y,
//              y: z * other.x - x * other.z,
//              z: x * other.y - y * other.x)
//    }
    /// Normalizes the mutable vector.
    @inlinable public mutating func normalize() {
        vector /= length
    }
    /// Returns the vector projected onto the specified vector.
    /// - Parameters:
    ///     - other: The second vector.
    /// - Returns: The vector projected onto the specified vector.
    @inlinable public func projected(_ other: Vector2D) -> Vector2D {
        (dot(other) / other.lengthSquared) * other
    }
    /// Returns the reflection direction of the incident vector and a specified unit normal vector.
    /// - Parameters:
    ///     - normal: The unit normal vector.
    /// - Returns: The reflection direction of the incident vector and a specified unit normal vector.
    @inlinable public func reflected(_ normal: Vector2D) -> Vector2D {
        .init(vector: vector - 2 * dot(normal) * normal.vector)
    }
    
    /// Returns a Boolean value that indicates whether two values are approximately equal within a threshold.
    /// - Parameters:
    ///     - other: The other vector value to compare with.
    ///     - tolerance: The tolerance for what is considered equal.
    /// - Returns: A Boolean indicating whether the two vectors are approximately equal.
    @inlinable public func isApproximatelyEqual(
        to other: Vector2D,
        tolerance: Double = .ulpOfOne.squareRoot()
    ) -> Bool {
        x.isAlmostEqual(to: other.x, tolerance: tolerance)
        && y.isAlmostEqual(to: other.y, tolerance: tolerance)
    }
}

extension Vector2D: AdditiveArithmetic {
    /// Returns a the specified vector unchanged.
    /// - Parameters:
    ///     - vector: The vector that gets returned.
    @inlinable public static prefix func + (vector: Vector2D) -> Vector2D {
        vector
    }
    /// Returns a vector that’s the element-wise sum of two vectors.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        var v = lhs
        v.vector += rhs.vector
        return v
    }
    /// Returns a size that’s the element-wise sum of a vector and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Vector2D, rhs: Size2D) -> Size2D {
        var s = rhs
        s.vector += lhs.vector
        return s
    }
    /// Returns a size that’s the element-wise sum of a vector and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Size2D, rhs: Vector2D) -> Size2D {
        var s = lhs
        s.vector += rhs.vector
        return s
    }
    /// Returns a point that’s the element-wise sum of a vector and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Vector2D, rhs: Point2D) -> Point2D {
        var v = rhs
        v.vector += lhs.vector
        return v
    }
    /// Returns a point that’s the element-wise sum of a vector and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Point2D, rhs: Vector2D) -> Point2D {
        var v = lhs
        v.vector += rhs.vector
        return v
    }
    /// Adds two vectors and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Vector2D, rhs: Vector2D) {
        lhs.vector += rhs.vector
    }
    
    /// Returns a vector that’s the element-wise negation of the vector.
    /// - Parameters:
    ///     - vector: The value that the operator negates.
    @inlinable public static prefix func - (vector: Vector2D) -> Vector2D {
        .init(vector: -vector.vector)
    }
    /// Returns a size that’s the element-wise difference of two vectors.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        var v = lhs
        v.vector -= rhs.vector
        return v
    }
    /// Returns a size that’s the element-wise difference of a vector and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Vector2D, rhs: Size2D) -> Size2D {
        var v = rhs
        v.vector -= lhs.vector
        return v
    }
    /// Returns a size that’s the element-wise difference of a vector and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Size2D, rhs: Vector2D) -> Size2D {
        var v = lhs
        v.vector -= rhs.vector
        return v
    }
    /// Returns a point that’s the element-wise difference of a vector and a point.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Vector2D, rhs: Point2D) -> Point2D {
        var v = rhs
        v.vector -= lhs.vector
        return v
    }
    /// Returns a point that’s the element-wise difference of a point and a vector.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Point2D, rhs: Vector2D) -> Point2D {
        var v = lhs
        v.vector -= rhs.vector
        return v
    }
    /// Subtracts a vector from a vector and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Vector2D, rhs: Vector2D) {
        lhs.vector -= rhs.vector
    }
    
    /// Returns a vector that’s the product of a vector and a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Vector2D, rhs: Double) -> Vector2D {
        var v = lhs
        v.vector *= rhs
        return v
    }
    /// Returns a vector that’s the product of a scalar value and a vector.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Double, rhs: Vector2D) -> Vector2D {
        var v = rhs
        v.vector *= lhs
        return v
    }
//    /// Returns a new vector after applying the pose to the vector.
//    /// - Parameters:
//    ///     - lhs: The left-hand-side value.
//    ///     - rhs: The right-hand-side value.
//    @inlinable public static func * (lhs: Pose2D, rhs: Vector2D) -> Vector2D {
//        rhs.applying(lhs)
//    }
    /// Multiplies a vector and a double-precision value, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout Vector2D, rhs: Double) {
        lhs.vector *= rhs
    }
    
    /// Returns a vector with each element divided by a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func / (lhs: Vector2D, rhs: Double) -> Vector2D {
        var v = lhs
        v.vector /= rhs
        return v
    }
    /// Divides a vector by a scalar value and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func /= (lhs: inout Vector2D, rhs: Double) {
        lhs.vector /= rhs
    }
}

extension Vector2D {//: Primitive2D {
    /// A vector that contains the values 1, 0.
    public static let right: Vector2D = .init(x: 1, y: 0)
    /// A vector that contains the values 0, 1.
    public static let up: Vector2D = .init(x: 0, y: 1)
    /// A vector that contains all infinities.
    public static let infinity: Vector2D = .init(x: .infinity, y: .infinity)
    /// A vector that contains all zeros.
    public static let zero: Vector2D = .init()

    /// A Boolean value that indicates whether the vector is zero.
    @inlinable public var isZero: Bool {
        x.isZero
        && y.isZero
    }
    /// A Boolean value that indicates whether all the components of the vector are finite.
    @inlinable public var isFinite: Bool {
        x.isFinite
        && y.isFinite
    }
    /// A Boolean value that indicates whether the vector contains any NaN values.
    @inlinable public var isNaN: Bool {
        x.isNaN
        || y.isNaN
    }
    
//    @inlinable public mutating func apply(_ pose: Pose2D) {
//        vector += pose.position.vector
//        rotate(by: pose.rotation)
//    }

//    @inlinable public mutating func apply(_ scaledPose: ScaledPose2D) {
//        vector += scaledPose.position.vector
//        rotate(by: scaledPose.rotation)
//        vector *= scaledPose.scale
//    }
}

//extension Vector2D: Rotatable2D {
//    /// Rotates the vector by the specified quaternion.
//    /// - Parameters:
//    ///     - quaternion: The double-precision quaternion that specifies the rotation.
//    @inlinable public mutating func rotate(by quaternion: simd_quatd) {
//        assert(quaternion.length.isAlmostEqual(to: 1))
//        
//        vector = quaternion.act(vector)
//    }
//}

extension Vector2D: Scalable2D {
    /// Scales the vector using the specified size structure.
    /// - Parameters:
    ///     - size: The size structure to scale using.
    public mutating func scale(by size: Size2D) {
        assert(size.isFinite)
        
        vector *= size.vector
    }
    /// Scales the vector using the specified double-precision values.
    /// - Parameters:
    ///     - x: The double-precision value that specifies the scale for the x component.
    ///     - y: The double-precision value that specifies the scale for the y component.
    @inlinable public mutating func scaleBy(x: Double, y: Double) {
        assert(x.isFinite && y.isFinite)
        
        vector *= SIMD2<Double>(x: x, y: y)
    }
    /// Uniformly scales the vector using the specified double-precision value.
    /// - Parameters:
    ///     - scale: The double-precision value that specifies the uniform scale.
    @inlinable public mutating func uniformlyScale(by scale: Double) {
        assert(scale.isFinite)
        
        vector *= scale
    }
}

extension Vector2D: SIMDStorage {
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

extension Vector2D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the vector.
    @inlinable public var description: String { "(x: \(x), y: \(y))" }
    /// A textual representation of the vector for debugging.
    @inlinable public var debugDescription: String { description }
}
