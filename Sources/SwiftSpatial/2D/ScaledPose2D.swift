public import simd
public import RealModule

/// A structure that contains a position, rotation, and scale.
public struct ScaledPose2D: Sendable, Codable, Hashable {
    /// The pose’s position.
    public var position: Point2D
    /// The pose’s angle.
    public var angle: Angle2D
    /// The scaled pose’s scale.
    public var scale: Double
    /// The pose’s inverse.
    @inlinable public var inverse: ScaledPose2D {
        var p = self
        p.invert()
        return p
    }
    
    /// Creates a pose structure.
    @inlinable public init() {
        self.init(position: .zero, angle: .zero, scale: 1)
    }
    /// Creates a scaled pose with the specified single-precision position vector and angle.
    /// - Parameters:
    ///     - position: A vector that specifies the position of the pose.
    ///     - angle: An angle structure that specifies the rotation of the pose.
    ///     - scale: The scale value for the scaled pose.
    @inlinable public init(
        position: simd_float2 = .zero,
        angle: Double,
        scale: Double = 1
    ) {
        self.init(position: .init(position),
                  angle: .init(radians: angle),
                  scale: scale)
    }
    /// Creates a scaled pose with the specified double-precision position vector and angle.
    /// - Parameters:
    ///     - position: A vector that specifies the position of the pose.
    ///     - angle: An angle structure that specifies the rotation of the pose.
    ///     - scale: The scale value for the scaled pose.
    @inlinable public init(
        position: simd_double2 = .zero,
        angle: Double,
        scale: Double = 1
    ) {
        self.init(position: .init(vector: position),
                  angle: .init(radians: angle),
                  scale: scale)
    }
    /// Returns a scaled pose at the specified position with the rotation toward the target.
    /// - Parameters:
    ///     - position: A point structure that specifies the position of the pose.
    ///     - target: The point that the pose orients towards.
    ///     - scale: The scale value for the scaled pose.
    @inlinable public init(
        position: Point2D = .zero,
        target: Point2D,
        scale: Double = 1
    ) {
        let forward = target - position
        self.init(position: position,
                  angle: forward.angle,
                  scale: scale)
    }
    /// Creates a scaled pose with the specified pose and a scale of 1.
    /// - Parameters:
    ///     - pose: A pose structure to use for the position and rotation of the sacled pose.
    @inlinable public init(_ pose: Pose2D) {
        self.init(position: pose.position,
                  angle: pose.angle,
                  scale: 1)
    }
    /// Creates a scaled pose with the specified Spatial position, angle, and scale structures.
    /// - Parameters:
    ///     - position: A point structure that specifies the position of the pose.
    ///     - angle: An angle structure that specifies the rotation of the pose.
    ///     - scale: The scale value for the scaled pose.
    @inlinable public init(position: Point2D, angle: Angle2D, scale: Double) {
        self.position = position
        self.angle = angle
        self.scale = scale
    }
    
    /// Sets the pose to it's inverse.
    @inlinable public mutating func invert() {
        position = -position
        angle.negate()
        scale = 1 / scale
    }

    /// Returns a pose that represents the concatenation of two poses.
    /// - Parameters:
    ///     - transform: The second pose.
    @inlinable public func concatenating(_ transform: Pose2D) -> ScaledPose2D {
        self * .init(transform)
    }
    /// Returns a pose that represents the concatenation of a scaled pose and a pose.
    /// - Parameters:
    ///     - transform: A scaled pose to concatenate.
    @inlinable public func concatenating(_ transform: ScaledPose2D) -> ScaledPose2D {
        self * transform
    }
}

extension ScaledPose2D: ApproximatelyEquatable {
    @inlinable public func isApproximatelyEqual(to other: ScaledPose2D,
                                                relativeTolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        position.isApproximatelyEqual(to: other.position, relativeTolerance: relativeTolerance) &&
        angle.isApproximatelyEqual(to: other.angle, relativeTolerance: relativeTolerance) &&
        scale.isApproximatelyEqual(to: other.scale, relativeTolerance: relativeTolerance)
    }

    @inlinable public func isApproximatelyEqual(to other: ScaledPose2D,
                                                absoluteTolerance: Double, relativeTolerance: Double = 0) -> Bool {
        position.isApproximatelyEqual(to: other.position, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance) &&
        angle.isApproximatelyEqual(to: other.angle, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance) &&
        scale.isApproximatelyEqual(to: other.scale, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}

extension ScaledPose2D {
    /// The identity pose.
    public static let identity: Pose2D = .init()
    
    /// A Boolean value that indicates whether the pose is the identity pose.
    @inlinable public var isIdentity: Bool {
        position.isZero &&
        angle.radians.isZero &&
        scale == 1
    }
}

extension ScaledPose2D: Translatable2D {
    @inlinable public mutating func translate(by vector: Vector2D) {
        position.translate(by: vector)
    }
}

extension ScaledPose2D: Rotatable2D {
    @inlinable public mutating func rotate(by angle: Angle2D) {
        self.angle += angle
    }
    
    /// Flips a pose along the specified axis.
    /// - Parameters:
    ///     - axis: An axis structure that specifies the flip axis.
    @inlinable public mutating func flip(along axis: Axis2D) {
        position.flip(along: axis)
        angle.flip(along: axis)
    }
    /// Returns a pose that results from flipping it along the specified axis.
    /// - Parameters:
    ///     - axis: An axis structure that specifies the flip axis.
    /// - Returns: The pose flipped along the specified axis.
    @inlinable public func flipped(along axis: Axis2D) -> ScaledPose2D {
        var pose = self
        pose.flip(along: axis)
        return pose
    }
}

extension ScaledPose2D {
    @inlinable public mutating func uniformlyScale(by scale: Double) {
        self.scale *= scale
    }
    
    @inlinable public func uniformlyScaled(by scale: Double) -> Self {
        var v = self
        v.uniformlyScale(by: scale)
        return v
    }
}

extension ScaledPose2D {
    /// Returns the inverse of the pose.
    /// - Parameters:
    ///     - scaledPose: The scaled pose to invert.
    @inlinable public static prefix func - (scaledPose: ScaledPose2D) -> ScaledPose2D {
        scaledPose.inverse
    }
    
    /// Returns the concatenation of two poses.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: ScaledPose2D, rhs: ScaledPose2D) -> ScaledPose2D {
        var p = lhs
        p *= rhs
        return p
    }
    /// Concatenates two poses and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout ScaledPose2D, rhs: ScaledPose2D) {
        lhs.position += Vector2D(rhs.position)
        lhs.angle += rhs.angle
        lhs.scale *= rhs.scale
    }
}

extension ScaledPose2D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the pose.
    @inlinable public var description: String { "Pose2D(position: \(position), angle: \(angle), scale: \(scale))" }
    /// A textual representation of the pose for debugging.
    @inlinable public var debugDescription: String { description }
}
