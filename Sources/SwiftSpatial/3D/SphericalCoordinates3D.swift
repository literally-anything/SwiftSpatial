public import simd

/// A structure that defines spherical coordinates in radial, inclination, azimuthal order.
public struct SphericalCoordinates3D: Sendable, Codable, Hashable {
    /// The distance to the origin.
    public var radius: Double
    /// The inclination angle, in radians.
    public var inclination: Angle2D
    /// The azimuthal angle, in radians.
    public var azimuth: Angle2D
    /// A simd three-element vector that contains the radius, inclination, and azimuth values.
    @inlinable public var vector: simd_double3 {
        get {
            .init(radius, inclination.radians, azimuth.radians)
        }
        set(newValue) {
            radius = newValue.x
            inclination = .init(radians: newValue.y)
            azimuth = .init(radians: newValue.z)
        }
    }
//    /// The point converted to cartesian coordinates
//    @inlinable public var cartesian: Point3D {
//    }
    
    /// Creates a spherical coordinates structure.
    @inlinable public init() {
        self.init(radius: 0, inclination: 0, azimuth: 0)
    }
    /// Creates a new spherical coordinates structure from the specified Cartesian coordinates represented by a simd vector.
    /// - Parameters:
    ///     - vector: A vector containing the Cartesian coordinates to convert.
    @inlinable public init(_ vector: SIMD3<Double>) {
        self.init(vector: vector)
    }
    /// Creates a new spherical coordinates structure from the specified Cartesian coordinates represented by a Spatial vector.
    /// - Parameters:
    ///     - vector: A vector containing the Cartesian coordinates to convert.
    @inlinable public init(_ vector: Vector3D) {
        self.init(vector: vector.vector)
    }
    /// Creates a spherical coordinates structure from the Cartesian coordinates represented by the specified Spatial point.
    /// - Parameters:
    ///     - point: A point containing the Cartesian coordinates to convert.
    @inlinable public init(_ point: Point3D) {
        self.init(x: point.x, y: point.y, z: point.z)
    }
    /// Creates a new spherical coordinates structure from the specified Cartesian coordinates.
    /// - Parameters:
    ///     - x: The Cartesian x-coordinate.
    ///     - y: The Cartesian y-coordinate.
    ///     - z: The Cartesian z-coordinate.
    @inlinable public init(x: Double, y: Double, z: Double) {
        self.init(vector: .init(x, y, z))
    }
    /// Creates a new spherical coordinates structure from the specified Cartesian coordinates represented by a simd vector.
    /// - Parameters:
    ///     - vector: A vector containing the Cartesian coordinates to convert.
    @inlinable public init(vector: SIMD3<Double>) {
//        let squared = vector * vector
//        let squaredLength = sqrt(squared.sum())
        let squaredLength = sqrt(pow(vector.x, 2) + pow(vector.y, 2) + pow(vector.z, 2))
        self.init(radius: squaredLength,
                  inclination: .init(radians: acos(vector.y / squaredLength)),
                  azimuth: .init(radians: atan2(vector.z, vector.x)))
    }
    /// Creates a new spherical coordinates structure with the specified radius, inclination, and azimuth.
    /// - Parameters:
    ///     - radius: The distance from the origin.
    ///     - inclination: The angle of inclination.
    ///     - azimuth: The azimuth angle.
    @inlinable public init(radius: Double, inclination: Angle2D, azimuth: Angle2D) {
        self.radius = radius
        self.inclination = inclination
        self.azimuth = azimuth
    }
    
    /// Returns a Boolean value that indicates whether two values are approximately equal within a threshold.
    /// - Parameters:
    ///     - other: The other spherical coordinate to compare with.
    ///     - tolerance: The tolerance for what is considered equal.
    /// - Returns: A Boolean indicating whether the two spherical coordinates are approximately equal.
    @inlinable public func isApproximatelyEqual(
        to other: SphericalCoordinates3D,
        tolerance: Double = .ulpOfOne.squareRoot()
    ) -> Bool {
        radius.isAlmostEqual(to: other.radius, tolerance: tolerance)
        && inclination.isApproximatelyEqual(to: other.inclination, tolerance: tolerance)
        && azimuth.isApproximatelyEqual(to: other.azimuth, tolerance: tolerance)
    }
}

extension SphericalCoordinates3D {
    public static let zero: SphericalCoordinates3D = .init()
}

extension SphericalCoordinates3D: CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable public var description: String { "(radius: \(radius), inclination: \(inclination), azimuth: \(azimuth))" }
    @inlinable public var debugDescription: String { description }
}
