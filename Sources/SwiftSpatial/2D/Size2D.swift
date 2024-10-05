public import simd
public import RealModule

/// A size that describes width and height in a 2D coordinate system.
public struct Size2D: Sendable, Codable, Hashable {
    /// A simd two-element vector that contains the width and height values.
    public var vector: SIMD2<Double>
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
    
    /// Creates a size structure.
    @inlinable public init() {
        self.init(vector: .zero)
    }
    /// Creates a size structure from the specified floating-point values.
    /// - Parameters:
    ///     - width: A floating-point value that specifies the width.
    ///     - height: A floating-point value that specifies the height.
    @inlinable public init<T>(
        width: T,
        height: T
    ) where T : BinaryFloatingPoint {
        self.init(width: Double(width),
                  height: Double(height))
    }
    /// Creates a size structure from the specified double-precision values.
    /// - Parameters:
    ///     - width: A double-precision value that specifies the width.
    ///     - height: A double-precision value that specifies the height.
    @inlinable public init(
        width: Double = 0,
        height: Double = 0
    ) {
        self.init(vector: .init(x: width,
                                y: height))
    }
    /// Creates a size structure from the specified single-precision vector.
    /// - Parameters:
    ///     - xy: A single-precision vector that specifies the dimensions.
    @inlinable public init(_ xy: SIMD2<Float>) {
        self.init(vector: .init(x: Double(xy.x),
                                y: Double(xy.y)))
    }
    /// Creates a size structure from the specified double-precision vector.
    /// - Parameters:
    ///     - xy: A double-precision vector that specifies the dimensions.
    @inlinable public init(_ xy: SIMD2<Double>) {
        self.init(vector: xy)
    }
    /// Creates a size structure from the specified 2D point.
    /// - Parameters:
    ///     - point: A point structure that specifies the dimensions.
    @inlinable public init(_ point: Point2D) {
        self.init(vector: point.vector)
    }
    /// Creates a size structure from the specified 2D vector.
    /// - Parameters:
    ///     - xyz: A vector that specifies the dimensions.
    @inlinable public init(_ xyz: Vector2D) {
        self.init(vector: xyz.vector)
    }
    /// Creates a size structure from the specified double-precision vector.
    /// - Parameters:
    ///     - vector: A double-precision vector that specifies the dimensions.
    @inlinable public init(vector: SIMD2<Double>) {
        self.vector = vector
    }
}

extension Size2D: ExpressibleByArrayLiteral {
    /// Initialize the size using an array of components.
    /// The array should only ever be of length 2.
    /// - Parameters:
    ///     - elements: The array of length 2 that defines the width and height components.
    @inlinable public init(arrayLiteral elements: Double...) {
        assert(elements.count == 2, "Size2D only has 2 elements.")

        self.init(width: elements.first!, height: elements.last!)
    }
}

extension Size2D: ApproximatelyEquatable {
    @inlinable public func isApproximatelyEqual(to other: Size2D,
                                                relativeTolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        width.isApproximatelyEqual(to: other.width, relativeTolerance: relativeTolerance) &&
        height.isApproximatelyEqual(to: other.height, relativeTolerance: relativeTolerance)
    }

    @inlinable public func isApproximatelyEqual(to other: Size2D,
                                                absoluteTolerance: Double, relativeTolerance: Double = 0) -> Bool {
        width.isApproximatelyEqual(to: other.width, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance) &&
        height.isApproximatelyEqual(to: other.height, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}

extension Size2D: Primitive2D {
    /// The size structure with the zero value.
    public static let zero: Size2D = .init()
    /// The size structure with width and height values of one.
    public static let one: Size2D = .init(vector: .one)
    /// The size structure with infinite width and height values.
    public static let infinity: Size2D = .init(width: .infinity, height: .infinity)
    
    /// A Boolean value that indicates whether the size is zero.
    @inlinable public var isZero: Bool {
        width.isZero
        && height.isZero
    }
    /// A Boolean value that indicates whether all of the dimensions of the size structure are finite.
    @inlinable public var isFinite: Bool {
        width.isFinite
        && height.isFinite
    }
    /// A Boolean value that indicates whether the size structure contains any NaN values.
    @inlinable public var isNaN: Bool {
        width.isNaN
        || height.isNaN
    }
    
    @inlinable public mutating func apply(_ pose: Pose2D) {
        vector += pose.position.vector
        self.rotate(by: pose.angle)
    }
    
    @inlinable public mutating func apply(_ scaledPose: ScaledPose2D) {
        vector += scaledPose.position.vector
        rotate(by: scaledPose.angle)
        vector *= scaledPose.scale
    }
}

extension Size2D: Scalable2D {
    /// Scale using the specified size structure.
    @inlinable public mutating func scale(by size: Size2D) {
        assert(size.isFinite)
        
        vector *= size.vector
    }
    /// Scale using the specified double-precision values.
    /// - Parameters:
    ///     - x: The double-precision value that specifies the scale along the width dimension.
    ///     - y: The double-precision value that specifies the scale along the height dimension.
    @inlinable public mutating func scaleBy(x: Double, y: Double) {
        vector *= SIMD2<Double>(x: x, y: y)
    }
    /// Uniformly scale using the specified double-precision value.
    /// - Parameters:
    ///     - scale: The double-precision value that specifies the uniform scale.
    @inlinable public mutating func uniformlyScale(by scale: Double) {
        vector *= scale
    }
}

extension Size2D: Rotatable2D {
    @inlinable public mutating func rotate(by angle: Angle2D) {
        let length = (vector * vector).sum().squareRoot()
        let newAngle = angle + .atan2(y: height, x: width)
        
        width = length * newAngle.cos
        height = length * newAngle.sin
    }
    
    @inlinable public mutating func flip(along axis: Axis2D) {
        switch axis {
        case .x:
            width = -width
        case .y:
            height = -height
        }
    }
}

extension Size2D: Volumetric2D {
    /// Returns a Boolean value that indicates whether the size contains the specified size.
    /// - Parameters:
    ///     - other: The size that the function compares against.
    /// - Returns: A Boolean value that indicates whether the size contains the specified size.
    @inlinable public func contains(_ other: Size2D) -> Bool {
        let mask = vector .>= other.vector
        return all(mask)
    }
    
    /// Returns a Boolean value that indicates whether the size contains the specified point.
    /// - Parameters:
    ///     - point: The point that the function compares against.
    /// - Returns: A Boolean value that indicates whether the size contains the specified point.
    @inlinable public func contains(point: Point2D) -> Bool {
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
    @inlinable public func contains(anyOf points: [Point2D]) -> Bool {
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
    @inlinable public mutating func formIntersection(_ other: Size2D) {
        if width.sign == other.width.sign &&
           height.sign == other.height.sign {
            vector = simd_min(simd_abs(vector), simd_abs(other.vector))
        }
    }
    /// Sets the size to the union of itself and the specified size.
    /// - Parameters:
    ///     - other: The size that the function compares against.
    @inlinable public mutating func formUnion(_ other: Size2D) {
        let min = simd_min(vector, other.vector)
        let max = simd_max(vector, other.vector)
        vector = max - min
    }

    /// Returns the intersection of two sizes.
    /// - Parameters:
    ///     - other: The size that the function compares against.
    /// - Returns: A new size that is the intersection of two sizes.
    @inlinable public func intersection(_ other: Size2D) -> Size2D? {
        if width.sign == other.width.sign &&
           height.sign == other.height.sign {
            return .init(vector: simd_min(simd_abs(vector), simd_abs(other.vector)))
        }
        return nil
    }
    /// Returns the smallest size that contains two sizes.
    /// - Parameters:
    ///     - other: The size that the function compares against.
    /// - Returns: A new size that is the union of two sizes.
    @inlinable public func union(_ other: Size2D) -> Size2D {
        var s = self
        s.formUnion(other)
        return s
    }
}

extension Size2D: AdditiveArithmetic {
    /// Returns the size unchanged.
    /// - Parameters:
    ///     - size: The value that the operator returns.
    @inlinable public static prefix func + (size: Size2D) -> Size2D {
        size
    }
    /// Returns a size that’s the element-wise sum of two sizes.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func + (lhs: Size2D, rhs: Size2D) -> Size2D {
        var s = lhs
        s += rhs
        return s
    }
    /// Adds two size structures and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Size2D, rhs: Size2D) {
        lhs.vector += rhs.vector
    }
    /// Adds a size and a vector, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func += (lhs: inout Size2D, rhs: Vector2D) {
        lhs.vector += rhs.vector
    }
    
    /// Returns a size that’s the element-wise negation of the size.
    /// - Parameters:
    ///     - size: The value that the operator negates.
    @inlinable public static prefix func - (size: Size2D) -> Size2D {
        var s = size
        s.vector = -s.vector
        return s
    }
    /// Returns a size that’s the element-wise difference of two points.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func - (lhs: Size2D, rhs: Size2D) -> Size2D {
        var s = lhs
        s -= rhs
        return s
    }
    /// Subtracts a size from a size and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Size2D, rhs: Size2D) {
        lhs.vector -= rhs.vector
    }
    /// Subtracts a size from a vector and stores the difference in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func -= (lhs: inout Size2D, rhs: Vector2D) {
        lhs.vector -= rhs.vector
    }
    
    /// Returns a size that’s the product of a size and a scalar value.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Size2D, rhs: Double) -> Size2D {
        var s = lhs
        s *= rhs
        return s
    }
    /// Returns a size that’s the product of a scalar value and a size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Double, rhs: Size2D) -> Size2D {
        var s = rhs
        s *= lhs
        return s
    }
    /// Returns a new size after applying the pose to the size.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Pose2D, rhs: Size2D) -> Size2D {
        rhs.applying(lhs)
    }
    /// Multiplies a size and a double-precision value, and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout Size2D, rhs: Double) {
        lhs.vector *= rhs
    }
    
    @inlinable public static func / (lhs: Size2D, rhs: Double) -> Size2D {
        var s = lhs
        s /= rhs
        return s
    }
    /// Divides a size by a scalar vaue and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func /= (lhs: inout Size2D, rhs: Double) {
        lhs.vector /= rhs
    }
}

extension Size2D: SIMDStorage {
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

extension Size2D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the size.
    @inlinable public var description: String { "(width: \(width), height: \(height))" }
    /// A textual representation of the size for debugging.
    @inlinable public var debugDescription: String { description }
}

