public import simd

/// A structure that contains a 2D position and a 2D angle.
public struct Pose2D: Sendable, Codable, Hashable {
    /// The pose’s position.
    public var position: Point2D
    /// The pose’s angle.
    public var angle: Angle2D
    /// The pose’s inverse.
    @inlinable public var inverse: Pose2D {
        var p = self
        p.invert()
        return p
    }
    
    /// Creates a pose structure.
    @inlinable public init() {
        self.init(position: .zero, angle: .zero)
    }
    /// Creates a pose with the specified single-precision position vector and angle.
    /// - Parameters:
    ///     - position: A vector that specifies the position of the pose.
    ///     - angle: The angle in radians.
    @inlinable public init(position: simd_float2 = .zero, angle: Double) {
        self.init(position: .init(position),
                  angle: .init(radians: angle))
    }
    /// Creates a pose with the specified double-precision position vector and angle.
    /// - Parameters:
    ///     - position: A vector that specifies the position of the pose.
    ///     - angle: The angle in radians.
    @inlinable public init(position: simd_double2 = .zero, angle: Double) {
        self.init(position: .init(vector: position),
                  angle: .init(radians: angle))
    }
    /// Returns a pose at the specified position with the angle towards the target.
    /// - Parameters:
    ///     - position: A point structure that specifies the position of the pose.
    ///     - target: The point that the pose orients towards.
    @inlinable public init(
        position: Point2D = .zero,
        target: Point2D
    ) {
        let angleDifference = target - position
        self.init(position: position,
                  angle: .atan2(y: angleDifference.y, x: angleDifference.x))
    }
//    /// Creates a pose with the specified scaled pose.
//    /// - Parameters:
//    ///     - scaledPose: A scaled pose structure to get the position and rotation from.
//    @inlinable public init(_ scaledPose: ScaledPose3D) {
//        self.init(position: scaledPose.position,
//                  angle: scaledPose.angle)
//    }
    /// Creates a pose with the specified position and angle structures.
    /// - Parameters:
    ///     - position: A point structure that specifies the position of the pose.
    ///     - rotation: An angle structure that specifies the angle in radians.
    @inlinable public init(position: Point2D, angle: Angle2D) {
        self.position = position
        self.angle = angle
    }
    
    /// Returns a Boolean value that indicates whether two poses are equal within a specified tolerance.
    /// - Parameters:
    ///     - other: The right-hand side value.
    ///     - tolerance: A double-precision value that specifies the tolerance.
    /// - Returns: A Boolean indicating whether the two poses are equal within a specified tolerance.
    @inlinable public func isApproximatelyEqual(
        to other: Pose2D,
        tolerance: Double = .ulpOfOne.squareRoot()
    ) -> Bool {
        position.isApproximatelyEqual(to: other.position, tolerance: tolerance)
        && angle.isApproximatelyEqual(to: other.angle, tolerance: tolerance)
    }
    
    /// Sets the pose to it's inverse.
    @inlinable public mutating func invert() {
        position = -position
        angle.invert()
    }
    
    /// Flips a pose along the specified axis.
    /// ToDo: This is completely wrong and doesn't work. Fix it.
    /// - Parameters:
    ///     - axis: An axis structure that specifies the flip axis.
    @inlinable public mutating func flip(along axis: Axis2D) {
        switch axis {
        case .x:
            position.vector.x.negate()
            angle.radians = .pi - angle.radians
        case .y:
            position.vector.y.negate()
            angle.radians.negate()
            angle.normalize()
        }
    }
    /// Returns a pose that results from flipping it along the specified axis.
    /// ToDo: This is completely wrong and doesn't work. Fix it.
    /// - Parameters:
    ///     - axis: An axis structure that specifies the flip axis.
    /// - Returns: The pose flipped along the specified axis.
    @inlinable public func flipped(along axis: Axis2D) -> Pose2D {
        var p = self
        p.flip(along: axis)
        return p
    }
}

extension Pose2D {
    /// Returns the inverse of the pose.
    /// - Parameters:
    ///     - pose: The scaled pose to invert.
    @inlinable public static prefix func - (pose: Pose2D) -> Pose2D {
        pose.inverse
    }
    
    /// Returns the concatenation of two poses.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * (lhs: Pose2D, rhs: Pose2D) -> Pose2D {
        var p = lhs
        p *= rhs
        return p
    }
    /// Concatenates two poses and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout Pose2D, rhs: Pose2D) {
        lhs.position += Vector2D(rhs.position)
        lhs.angle += rhs.angle
    }
    
    /// Returns a pose that represents the concatenation of two poses.
    /// - Parameters:
    ///     - transform: The second pose.
    @inlinable public func concatenating(_ transform: Pose2D) -> Pose2D {
        self * transform
    }
//    /// Returns a pose that represents the concatenation of a scaled pose and a pose.
//    /// - Parameters:
//    ///     - transform: A scaled pose to concatenate.
//    @inlinable public func concatenating(_ transform: ScaledPose2D) -> ScaledPose2D {
//        transform * .init(self)
//    }
}

extension Pose2D {
    /// The identity pose.
    public static let identity: Pose2D = .init()
    
    /// A Boolean value that indicates whether the pose is the identity pose.
    @inlinable public var isIdentity: Bool {
        position.isZero && angle.radians.isZero
    }
}

extension Pose2D: Translatable2D {
    @inlinable public mutating func translate(by vector: Vector2D) {
        position.translate(by: vector)
    }
}

extension Pose2D: Rotatable2D {
    public mutating func rotate(by angle: Angle2D) {
        self.angle += angle
    }
}

extension Pose2D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the pose.
    @inlinable public var description: String { "(position: \(position), angle: \(angle))" }
    /// A textual representation of the pose for debugging.
    @inlinable public var debugDescription: String { description }
}
