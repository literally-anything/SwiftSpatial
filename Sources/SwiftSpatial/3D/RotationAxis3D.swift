public import RealModule

/// A 3D rotation axis.
public struct RotationAxis3D: Sendable, Codable, Hashable {
    /// A simd three-element vector that contains the x-, y-, and z-coordinate values.
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
    
    /// Creates a rotation axis with all zeros.
    @inlinable public init() {
        self.init(vector: .zero)
    }
    /// Creates a rotation axis from the specified double-precision values.
    /// - Parameters:
    ///     - x: A double-precision value that specifies the x coordinate value.
    ///     - y: A double-precision value that specifies the y coordinate value.
    ///     - z: A double-precision value that specifies the z coordinate value.
    @inlinable public init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.init(vector: .init(x: x, y: y, z: z))
    }
    /// Creates a rotation axis from the specified floating-point values.
    /// - Parameters:
    ///     - x: A floating-point value that specifies the x coordinate value.
    ///     - y: A floating-point value that specifies the y coordinate value.
    ///     - z: A floating-point value that specifies the z coordinate value.
    @inlinable public init<T>(x: T, y: T, z: T) where T : BinaryFloatingPoint {
        self.init(x: Double(x),
                  y: Double(y),
                  z: Double(z))
    }
    /// Creates a rotation axis from the specified single-precision vector.
    /// - Parameters:
    ///     - xyz: A single-precision vector that specifies the coordinates.
    @inlinable public init(_ xyz: SIMD3<Float>) {
        self.init(x: xyz.x, y: xyz.y, z: xyz.z)
    }
    /// Creates a rotation axis from the specified double-precision vector.
    /// - Parameters:
    ///     - xyz: A double-precision vector that specifies the coordinates.
    @inlinable public init(_ xyz: SIMD3<Double>) {
        self.init(vector: xyz)
    }
    /// Creates a rotation axis from a Spatial vector.
    /// - Parameters:
    ///     - xyz: A Spatial vector that specifies the coordinates.
    @inlinable public init(_ xyz: Vector3D) {
        self.init(vector: xyz.vector)
    }
    /// Creates a rotation axis from a three-element double-precision vector.
    /// - Parameters:
    ///     - vector: A double-precision vector that specifies the coordinates.
    @inlinable public init(vector: SIMD3<Double>) {
        self.vector = vector
    }
}

extension RotationAxis3D: ExpressibleByArrayLiteral {
    /// Initialize the rotation axis using an array of components.
    /// The array should only ever be of length 3.
    /// - Parameters:
    ///     - arrayLiteral: The array of length 3 that defines the x, y, and z components.
    @inlinable public init(arrayLiteral elements: Double...) {
        assert(elements.count == 3, "RotationAxis3D only has 3 elements.")

        self.init(x: elements[0], y: elements[1], z: elements[2])
    }
}

extension RotationAxis3D: ApproximatelyEquatable {
    @inlinable public func isApproximatelyEqual(to other: RotationAxis3D,
                                                relativeTolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        x.isApproximatelyEqual(to: other.x, relativeTolerance: relativeTolerance) &&
        y.isApproximatelyEqual(to: other.y, relativeTolerance: relativeTolerance) &&
        z.isApproximatelyEqual(to: other.z, relativeTolerance: relativeTolerance)
    }

    @inlinable public func isApproximatelyEqual(to other: RotationAxis3D,
                                                absoluteTolerance: Double, relativeTolerance: Double = 0) -> Bool {
        x.isApproximatelyEqual(to: other.x, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance) &&
        y.isApproximatelyEqual(to: other.y, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance) &&
        z.isApproximatelyEqual(to: other.z, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}

extension RotationAxis3D {
    /// The x-axis, expressed in unit coordinates.
    public static let x: RotationAxis3D = .init(x: 1)
    /// The y-axis, expressed in unit coordinates.
    public static let y: RotationAxis3D = .init(y: 1)
    /// The z-axis, expressed in unit coordinates.
    public static let z: RotationAxis3D = .init(z: 1)
    /// The xy-axis, expressed in unit coordinates.
    public static let xy: RotationAxis3D = .init(x: 1, y: 1)
    /// The yz-axis, expressed in unit coordinates.
    public static let yz: RotationAxis3D = .init(y: 1, z: 1)
    /// The xz-axis, expressed in unit coordinates.
    public static let xz: RotationAxis3D = .init(x: 1, z: 1)
    /// The xyz-axis, expressed in unit coordinates.
    public static let xyz: RotationAxis3D = .init(vector: .one)
    /// The rotation axis with the zero value.
    public static let zero: RotationAxis3D = .init()
}

extension RotationAxis3D: SIMDStorage {
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

extension RotationAxis3D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the rotation axis.
    @inlinable public var description: String { "(x: \(x), y: \(y), z: \(z))" }
    /// A textual representation of the rotation axis for debugging.
    @inlinable public var debugDescription: String { description }
}
