public import simd

/// A ray in a 3D coordinate system.
public struct Ray3D: Sendable, Codable, Hashable {
    /// The origin of the ray.
    public var origin: Point3D
    /// var direction: Vector3D
    public var direction: Vector3D
    
    /// Creates a ray structure.
    @inlinable public init() {
        self.init(origin: .zero, direction: .zero)
    }
    
    /// Creates a ray with the specified origin and the specified direction from single-precision vectors.
    /// - Parameters:
    ///     - origin: A vector that specifies the ray’s origin.
    ///     - direction: A vector that specifies the ray’s direction.
    @inlinable public init(origin: SIMD3<Float> = .zero, direction: SIMD3<Float>) {
        self.init(origin: Point3D(origin), direction: Vector3D(direction))
    }
    
    /// Creates a ray with the specified origin and the specified direction from double-precision vectors.
    /// - Parameters:
    ///     - origin: A vector that specifies the ray’s origin.
    ///     - direction: A vector that specifies the ray’s direction.
    @inlinable public init(origin: SIMD3<Double> = .zero, direction: SIMD3<Double>) {
        self.init(origin: Point3D(origin), direction: Vector3D(direction))
    }
    
    /// Creates a ray with the specified origin and the specified direction from Spatial primitives.
    /// - Parameters:
    ///     - origin: A point that specifies the ray’s origin.
    ///     - direction: A vector that specifies the ray’s direction.
    public init(origin: Point3D, direction: Vector3D) {
        self.origin = origin
        self.direction = direction
    }
}

extension Ray3D: Primitive3D {
    public static let zero: Ray3D = .init()
    public static let infinity: Ray3D = .init(origin: .infinity, direction: .infinity)
    
    @inlinable public var isZero: Bool {
        origin.isZero && direction.isZero
    }
    
    @inlinable public var isFinite: Bool {
        origin.isFinite && direction.isFinite
    }
    
    @inlinable public var isNaN: Bool {
        origin.isNaN || direction.isNaN
    }
    
    @inlinable public mutating func apply(_ pose: Pose3D) {
        origin.translate(by: .init(pose.position))
        direction.rotate(by: pose.rotation)
    }
    
    @inlinable public mutating func apply(_ scaledPose: ScaledPose3D) {
        origin.translate(by: .init(scaledPose.position))
        direction.rotate(by: scaledPose.rotation)
        direction.uniformlyScale(by: scaledPose.scale)
    }
}

extension Ray3D: Translatable3D {
    public mutating func translate(by vector: Vector3D) {
        origin.translate(by: vector)
    }
}

extension Ray3D: Rotatable3D {
    @inlinable public mutating func rotate(by quaternion: simd_quatd) {
        direction.rotate(by: quaternion)
    }
}

extension Ray3D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the ray.
    @inlinable public var description: String { "(origin: \(origin), direction: \(direction))" }
    /// A textual representation of the ray for debugging.
    @inlinable public var debugDescription: String { description }
}
