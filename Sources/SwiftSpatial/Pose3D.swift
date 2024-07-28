import simd

/// A structure that contains a 3D position and a 3D rotation.
public struct Pose3D: Sendable, Codable, Hashable {
    /// The pose’s position.
    public var position: Point3D
    /// The pose’s rotation.
    public var rotation: Rotation3D
    /// The pose’s underlying matrix.
    @inlinable public var matrix: simd_double4x4 {
        var mat = rotation.matrix
        mat.columns.3.x = position.x
        mat.columns.3.y = position.y
        mat.columns.3.z = position.z
        return mat
    }
    /// The pose’s inverse.
    @inlinable public var inverse: Pose3D {
        var p = self
        p.invert()
        return p
    }
    
    /// Creates a pose structure.
    @inlinable public init() {
        self.init(position: .zero, rotation: .identity)
    }
    /// Creates a pose from the specified 4 x 4 single-precision matrix.
    /// - Parameters:
    ///     - matrix: The source single-precision matrix.
    @inlinable public init?(_ matrix: simd_float4x4) {
        self.init(matrix.toDouble())
    }
    /// Creates a pose from the specified 4 x 4 double-precision matrix.
    /// - Parameters:
    ///     - matrix: The source double-precision matrix.
    @inlinable public init?(_ matrix: simd_double4x4) {
        guard Self.scale(from: matrix).isNormal else {
            return nil
        }
        
        self.init(position: .init(matrix.columns.3.x, matrix.columns.3.y, matrix.columns.3.z),
                  rotation: .init(matrix))
    }
//    /// Returns a pose with a position and rotation defined by an affine transform.
//    /// - Parameters:
//    ///     - transform: The source transform. The function only considers the transform’s rotation and translation components.
//    init?(transform: AffineTransform3D) {}
//    /// Returns a pose with a position and rotation defined by a projective transform.
//    /// - Parameters:
//    ///     - transform: The source transform. The function only considers the transform’s rotation and translation components.
//    init?(transform: ProjectiveTransform3D) {}
    /// Creates a pose with the specified single-precision position vector and quaternion.
    /// - Parameters:
    ///     - position: A vector that specifies the position of the pose.
    ///     - rotation: A quaternion structure that specifies the rotation of the pose.
    @inlinable public init(position: simd_float3 = .zero, rotation: simd_quatf) {
        self.init(position: .init(position),
                  rotation: .init(rotation))
    }
    /// Creates a pose with the specified double-precision position vector and quaternion.
    /// - Parameters:
    ///     - position: A vector that specifies the position of the pose.
    ///     - rotation: A quaternion structure that specifies the rotation of the pose.
    @inlinable public init(position: simd_double3 = .zero, rotation: simd_quatd) {
        self.init(position: .init(vector: position),
                  rotation: .init(quaternion: rotation))
    }
    /// Creates a pose with the specified forward and up vectors.
    /// - Parameters:
    ///     - forward: The forward vector.
    ///     - up: The upward vector.
    @inlinable public init(forward: Vector3D, up: Vector3D = .up) {
        self.init(position: .zero,
                  rotation: .init(forward: forward, up: up))
    }
    /// Returns a pose at the specified position with the rotation towards the target.
    /// - Parameters:
    ///     - position: A point structure that specifies the position of the pose.
    ///     - target: The point that the pose orients towards.
    ///     - up: The up direction.
    @inlinable public init(
        position: Point3D = .zero,
        target: Point3D,
        up: Vector3D = .up
    ) {
        self.init(position: position,
                  rotation: .init(position: position,
                                  target: target,
                                  up: up))
    }
    /// Creates a pose with the specified scaled pose.
    /// - Parameters:
    ///     - scaledPose: A scaled pose structure to get the position and rotation from.
    @inlinable public init(_ scaledPose: ScaledPose3D) {
        self.init(position: scaledPose.position,
                  rotation: scaledPose.rotation)
    }
    /// Creates a pose with the specified Spatial position and rotation structures.
    /// - Parameters:
    ///     - position: A point structure that specifies the position of the pose.
    ///     - rotation: A rotation structure that specifies the rotation of the pose.
    public init(position: Point3D, rotation: Rotation3D) {
        self.position = position
        self.rotation = rotation
    }
    
    /// Returns a Boolean value that indicates whether two poses are equal within a specified tolerance.
    /// - Parameters:
    ///     - other: The right-hand side value.
    ///     - tolerance: A double-precision value that specifies the tolerance.
    /// - Returns: A Boolean indicating whether the two poses are equal within a specified tolerance.
    @inlinable public func isApproximatelyEqual(
        to other: Pose3D,
        tolerance: Double = .ulpOfOne.squareRoot()
    ) -> Bool {
        position.isApproximatelyEqual(to: other.position, tolerance: tolerance)
        && rotation.isApproximatelyEqual(to: other.rotation, tolerance: tolerance)
    }
    
    /// Sets the pose to it's inverse.
    @inlinable public mutating func invert() {
        position = -position
        rotation.invert()
    }
    
    /// Flips a pose along the specified axis.
    /// ToDo: This is completely wrong and doesn't work. Fix it.
    /// - Parameters:
    ///     - axis: An axis structure that specifies the flip axis.
    @inlinable public mutating func flip(along axis: Axis3D) {
        let reflectionMatrix: simd_double3x3
        switch axis {
        case .x:
            position.vector.x.negate()
            reflectionMatrix = .init(diagonal: .init(1, -1, -1))
        case .y:
            position.vector.y.negate()
            reflectionMatrix = .init(diagonal: .init(-1, 1, -1))
        case .z:
            position.vector.z.negate()
            reflectionMatrix = .init(diagonal: .init(-1, -1, 1))
        }
        let rotationMatrix = simd_matrix3x3(rotation.quaternion) * reflectionMatrix
        rotation.quaternion = .init(rotationMatrix)
    }
    /// Returns a pose that results from flipping it along the specified axis.
    /// ToDo: This is completely wrong and doesn't work. Fix it.
    /// - Parameters:
    ///     - axis: An axis structure that specifies the flip axis.
    /// - Returns: The pose flipped along the specified axis.
    @inlinable public func flipped(along axis: Axis3D) -> Pose3D {
        var p = self
        p.flip(along: axis)
        return p
    }
    
    @inlinable internal static func scale(from matrix: simd_double4x4) -> Double {
        let l1 = simd_length(matrix.columns.0.to3())
        let l2 = simd_length(matrix.columns.1.to3())
        let l3 = simd_length(matrix.columns.2.to3())
        
        if l1.isAlmostEqual(to: l2) && l2.isAlmostEqual(to: l3) {
            return l1
        }
        return .nan
    }
}

extension Pose3D {
    /// Returns the inverse of the pose.
    /// - Parameters:
    ///     - pose: The scaled pose to invert.
    @inlinable public static prefix func - (pose: Pose3D) -> Pose3D {
        pose.inverse
    }
    
    /// Returns the concatenation of two poses.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Pose3D, rhs: Pose3D) -> Pose3D {
        var p = lhs
        p *= rhs
        return p
    }
    /// Concatenates two poses and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout Pose3D, rhs: Pose3D) {
        lhs.position += Vector3D(rhs.position)
        lhs.rotation *= rhs.rotation
    }
    
    /// Returns a pose that represents the concatenation of two poses.
    /// - Parameters:
    ///     - transform: The second pose.
    @inlinable public func concatenating(_ transform: Pose3D) -> Pose3D {
        self * transform
    }
    /// Returns a pose that represents the concatenation of a scaled pose and a pose.
    /// - Parameters:
    ///     - transform: A scaled pose to concatenate.
    @inlinable public func concatenating(_ transform: ScaledPose3D) -> ScaledPose3D {
        transform * .init(self)
    }
}

extension Pose3D {
    /// The identity pose.
    public static let identity: Pose3D = .init()
    
    /// A Boolean value that indicates whether the pose is the identity pose.
    @inlinable public var isIdentity: Bool {
        position.isZero && rotation.isIdentity
    }
}

extension Pose3D: Translatable3D {
    @inlinable public mutating func translate(by vector: Vector3D) {
        position.translate(by: vector)
    }
}

extension Pose3D: Rotatable3D {
    public mutating func rotate(by quaternion: simd_quatd) {
        rotation.rotate(by: quaternion)
    }
}

extension Pose3D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the pose.
    @inlinable public var description: String { "(position: \(position), rotation: \(rotation))" }
    /// A textual representation of the pose for debugging.
    @inlinable public var debugDescription: String { description }
}
