/// A set of methods that defines the interface to rotate and flip 2D Spatial entities.
public protocol Rotatable2D {
    /// Rotates the entity by an angle over an axis.
    /// - Parameters:
    ///     - angle: The angle structure that defines the angle to rotate the entitiy.
    mutating func rotate(by angle: Angle2D)
    /// Flips the entity across the specified axis.
    /// - Parameters:
    ///     - axis: The axis to flip across.
    mutating func flip(along axis: Axis2D)

    /// Returns the entity that results from applying the specified rotation.
    /// - Parameters:
    ///     - angle: The angle structure that defines the angle to rotate the entitiy.
    func rotated(by angle: Angle2D) -> Self
    /// Returns the entity that results from flipping the entity across the specified axis.
    /// - Parameters:
    ///     - axis: The axis to flip across.
    func flipped(along axis: Axis2D) -> Self
}

extension Rotatable2D {
    @inlinable public func rotated(by angle: Angle2D) -> Self {
        var rotatable = self
        rotatable.rotate(by: angle)
        return rotatable
    }
    @inlinable public func flipped(along axis: Axis2D) -> Self {
        var rotatable = self
        rotatable.flip(along: axis)
        return rotatable
    }
}
