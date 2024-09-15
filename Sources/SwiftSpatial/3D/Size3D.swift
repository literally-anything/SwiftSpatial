public import simd

/// A size that describes width, height, and depth in a 3D coordinate system.
public struct Size3D: Sendable, Codable, Hashable {
    /// A simd three-element vector that contains the width, height, and depth values.
    public var vector: SIMD3<Double>
    /// The width value.
    @inlinable public var width: Double {
        get { vector.x }
        set(newValue) { vector.x = newValue }
    }
    /// The height value.
    @inlinable public var height: Double {
        get { vector.y }
        set(newValue) { vector.y = newValue }
    }
    /// The depth value.
    @inlinable public var depth: Double {
        get { vector.z }
        set(newValue) { vector.z = newValue }
    }
    
    /// Creates a size structure.
    @inlinable public init() {
        self.init(vector: .zero)
    }
    /// Creates a size structure from the specified floating-point values.
    /// - Parameters:
    ///     - width: A floating-point value that specifies the width.
    ///     - height: A floating-point value that specifies the height.
    ///     - depth: A floating-point value that specifies the depth.
    @inlinable public init<T>(
        width: T,
        height: T,
        depth: T
    ) where T : BinaryFloatingPoint {
        self.init(width: Double(width),
                  height: Double(height),
                  depth: Double(depth))
    }
    /// Creates a size structure from the specified double-precision values.
    /// - Parameters:
    ///     - width: A double-precision value that specifies the width.
    ///     - height: A double-precision value that specifies the height.
    ///     - depth: A double-precision value that specifies the depth.
    @inlinable public init(
        width: Double = 0,
        height: Double = 0,
        depth: Double = 0
    ) {
        self.init(vector: .init(x: width,
                                y: height,
                                z: depth))
    }
    /// Creates a size structure from the specified single-precision vector.
    /// - Parameters:
    ///     - xyz: A single-precision vector that specifies the dimensions.
    @inlinable public init(_ xyz: SIMD3<Float>) {
        self.init(vector: .init(x: Double(xyz.x),
                                y: Double(xyz.y),
                                z: Double(xyz.z)))
    }
    /// Creates a size structure from the specified double-precision vector.
    /// - Parameters:
    ///     - xyz: A double-precision vector that specifies the dimensions.
    @inlinable public init(_ xyz: SIMD3<Double>) {
        self.init(vector: xyz)
    }
    /// Creates a size structure from the specified Spatial point.
    /// - Parameters:
    ///     - point: A point structure that specifies the dimensions.
    @inlinable public init(_ point: Point3D) {
        self.init(vector: point.vector)
    }
    /// Creates a size structure from the specified Spatial vector.
    /// - Parameters:
    ///     - xyz: A vector that specifies the dimensions.
    @inlinable public init(_ xyz: Vector3D) {
        self.init(vector: xyz.vector)
    }
    /// Creates a size structure from the specified double-precision vector.
    /// - Parameters:
    ///     - vector: A double-precision vector that specifies the dimensions.
    public init(vector: SIMD3<Double>) {
        self.vector = vector
    }
    
    /// Returns a Boolean value that indicates whether two sizes are approximately equal within a threshold.
    /// - Parameters:
    ///     - other: The other size to compare with.
    ///     - tolerance: The tolerance for what is considered equal.
    /// - Returns: A Boolean indicating whether the two sizes are approximately equal.
    @inlinable public func isApproximatelyEqual(
        to other: Size3D,
        tolerance: Double = .ulpOfOne.squareRoot()
    ) -> Bool {
        width.isAlmostEqual(to: other.width, tolerance: tolerance)
        && height.isAlmostEqual(to: other.height, tolerance: tolerance)
        && depth.isAlmostEqual(to: other.depth, tolerance: tolerance)
    }
}

extension Size3D: AdditiveArithmetic {
    /// Returns the size unchanged.
    /// - Parameters:
    ///     - size: The value that the operator returns.
    @inlinable public static prefix func + (size: Size3D) -> Size3D {
        size
    }
    /// Returns a size that’s the element-wise sum of two sizes.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Size3D, rhs: Size3D) -> Size3D {
        var s = lhs
        s += rhs
        return s
    }
    /// Adds two size structures and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Size3D, rhs: Size3D) {
        lhs.vector += rhs.vector
    }
    /// Adds a size and a vector, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Size3D, rhs: Vector3D) {
        lhs.vector += rhs.vector
    }
    
    /// Returns a size that’s the element-wise negation of the size.
    /// - Parameters:
    ///     - size: The value that the operator negates.
    @inlinable public static prefix func - (size: Size3D) -> Size3D {
        var s = size
        s.vector = -s.vector
        return s
    }
    /// Returns a size that’s the element-wise difference of two points.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Size3D, rhs: Size3D) -> Size3D {
        var s = lhs
        s -= rhs
        return s
    }
    /// Subtracts a size from a size and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Size3D, rhs: Size3D) {
        lhs.vector -= rhs.vector
    }
    /// Subtracts a size from a vector and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Size3D, rhs: Vector3D) {
        lhs.vector -= rhs.vector
    }
    
    /// Returns a size that’s the product of a size and a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Size3D, rhs: Double) -> Size3D {
        var s = lhs
        s *= rhs
        return s
    }
    /// Returns a size that’s the product of a scalar value and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Double, rhs: Size3D) -> Size3D {
        var s = rhs
        s *= lhs
        return s
    }
//    /// Returns the size that results from applying the affine transform to the size.
//    /// - Parameters:
//    ///     - lhs: The left-hand-side value.
//    ///     - rhs: The right-hand-side value.
//    @inlinable public static func * (lhs: AffineTransform3D, rhs: Size3D) -> Size3D {
//    }
//    /// Returns the size that results from applying the projective transform to the size.
//    /// - Parameters:
//    ///     - lhs: The left-hand-side value.
//    ///     - rhs: The right-hand-side value.
//    @inlinable public static func * (lhs: ProjectiveTransform3D, rhs: Size3D) -> Size3D {
//    }
    /// Returns a new size after applying the pose to the size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Pose3D, rhs: Size3D) -> Size3D {
        rhs.applying(lhs)
    }
    /// Multiplies a size and a double-precision value, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout Size3D, rhs: Double) {
        lhs.vector *= rhs
    }
    
    @inlinable public static func / (lhs: Size3D, rhs: Double) -> Size3D {
        var s = lhs
        s /= rhs
        return s
    }
    /// Divides a size by a scalar vaue and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func /= (lhs: inout Size3D, rhs: Double) {
        lhs.vector /= rhs
    }
}

extension Size3D: Primitive3D {
    /// The size structure with the zero value.
    public static let zero: Size3D = .init()
    /// The size structure with width, height, and depth values of one.
    public static let one: Size3D = .init(vector: .one)
    /// The size structure with infinite width, height, and depth values.
    public static let infinity: Size3D = .init(width: .infinity, height: .infinity, depth: .infinity)
    
    /// A Boolean value that indicates whether the size is zero.
    @inlinable public var isZero: Bool {
        width.isZero
        && height.isZero
        && depth.isZero
    }
    /// A Boolean value that indicates whether all of the dimensions of the size structure are finite.
    @inlinable public var isFinite: Bool {
        width.isFinite
        && height.isFinite
        && depth.isFinite
    }
    /// A Boolean value that indicates whether the size structure contains any NaN values.
    @inlinable public var isNaN: Bool {
        width.isNaN
        || height.isNaN
        || depth.isNaN
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

extension Size3D: Scalable3D {
    /// Scale using the specified size structure.
    @inlinable public mutating func scale(by size: Size3D) {
        assert(size.isFinite)
        
        vector *= size.vector
    }
    /// Scale using the specified double-precision values.
    /// - Parameters:
    ///     - x: The double-precision value that specifies the scale along the width dimension.
    ///     - y: The double-precision value that specifies the scale along the height dimension.
    ///     - z: The double-precision value that specifies the scale along the depth dimension.
    @inlinable public mutating func scaleBy(x: Double, y: Double, z: Double) {
        assert(x.isFinite && y.isFinite && z.isFinite)
        
        vector *= SIMD3<Double>(x: x, y: y, z: z)
    }
    /// Uniformly scale using the specified double-precision value.
    /// - Parameters:
    ///     - scale: The double-precision value that specifies the uniform scale.
    @inlinable public mutating func uniformlyScale(by scale: Double) {
        assert(scale.isFinite)
        
        vector *= scale
    }
}

extension Size3D: Rotatable3D {
    @inlinable public mutating func rotate(by quaternion: simd_quatd) {
        assert(quaternion.length.isAlmostEqual(to: 1))
        
        vector = quaternion.act(vector)
    }
}

extension Size3D: Shearable3D {
}

extension Size3D: Volumetric3D {    
    /// The size value.
    @inlinable public var size: Size3D {
        self
    }
    
    /// Returns a Boolean value that indicates whether the size contains the specified size.
    /// - Parameters:
    ///     - other: The size that the function compares against.
    /// - Returns: A Boolean value that indicates whether the size contains the specified size.
    @inlinable public func contains(_ other: Size3D) -> Bool {
        assert(other.isFinite)
        
        let mask = vector .>= other.vector
        return all(mask)
    }
    
    /// Returns a Boolean value that indicates whether the size contains the specified point.
    /// - Parameters:
    ///     - point: The point that the function compares against.
    /// - Returns: A Boolean value that indicates whether the size contains the specified point.
    @inlinable public func contains(point: Point3D) -> Bool {
        assert(point.isFinite && !point.isNaN)
        
        let high = simd_max(vector, .zero)
        let low = simd_min(vector, .zero)
        
        let sizeMask = high .>= point.vector
        let zeroMask = low .<= point.vector
        
        let mask = sizeMask .& zeroMask
        return all(mask)
    }
    
    /// Returns a Boolean value that indicates whether the size contains any of the the specified points
    /// - Parameters:
    ///     - points: The array of points that the function compares against.
    /// - Returns: A Boolean value that indicates whether the size contains at least one of the specified points.
    @inlinable public func contains(anyOf points: [Point3D]) -> Bool {
        assert(!points.isEmpty)
        
        for point in points {
            if contains(point: point) {
                return true
            }
        }
        return false
    }
    
    /// Sets the size to the intersection of itself and the specified size.
    /// - Parameters:
    ///     - other: The size that the function compares against.
    @inlinable public mutating func formIntersection(_ other: Size3D) {
        vector = simd_min(vector, other.vector)
    }
    /// Sets the size to the union of itself and the specified size.
    /// - Parameters:
    ///     - other: The size that the function compares against.
    @inlinable public mutating func formUnion(_ other: Size3D) {
        vector = simd_max(vector, other.vector)
    }
    
    /// Returns the intersection of two sizes.
    /// - Parameters:
    ///     - other: The size that the function compares against.
    /// - Returns: A new size that is the intersection of two sizes.
    @inlinable public func intersection(_ other: Size3D) -> Size3D? {
        var s = self
        s.formIntersection(other)
        return s
    }
    /// Returns the smallest size that contains two sizes.
    /// - Parameters:
    ///     - other: The size that the function compares against.
    /// - Returns: A new size that is the union of two sizes.
    @inlinable public func union(_ other: Size3D) -> Size3D {
        var s = self
        s.formUnion(other)
        return s
    }
}

extension Size3D: SIMDStorage {
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

extension Size3D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the size.
    @inlinable public var description: String { "(width: \(width), height: \(height), depth: \(depth))" }
    /// A textual representation of the size for debugging.
    @inlinable public var debugDescription: String { description }
}
