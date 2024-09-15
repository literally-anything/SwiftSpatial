/// A set of methods that defines the interface to rotate Spatial entities.
public protocol Rotatable2D {
    /// Rotates the entity by an angle over an axis.
    /// - Parameters:
    ///     - angle: The angle structure that defines the angle to rotate the entitiy.
    mutating func rotate(by angle: Angle2D)

    /// Returns the entity that results from applying the specified rotation.
    /// - Parameters:
    ///     - angle: The angle structure that defines the angle to rotate the entitiy.
    func rotated(by angle: Angle2D) -> Self
}

extension Rotatable2D {
    @inlinable public func rotated(by angle: Angle2D) -> Self {
        var v = self
        v.rotate(by: angle)
        return v
    }
}
