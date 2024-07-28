import simd

/// A set of methods that defines the interface to rotate Spatial entities.
public protocol Rotatable3D {
    /// Rotates the entity by an angle over an axis.
    /// - Parameters:
    ///     - rotation: The rotation structure that defines the rotation’s angle and axis.
    mutating func rotate(by rotation: Rotation3D)
    /// Rotates the entity by a quaternion.
    /// - Parameters:
    ///     - quaternion: The double-precision quaternion that specifies the rotation.
    mutating func rotate(by quaternion: simd_quatd)
    
    /// Returns the entity that results from applying the specified rotation.
    /// - Parameters:
    ///     - rotation: The rotation structure that defines the rotation’s angle and axis.
    func rotated(by rotation: Rotation3D) -> Self
    /// Returns the entity that a quaternion rotates.
    /// - Parameters:
    ///     - quaternion: The double-precision quaternion that specifies the rotation.
    func rotated(by quaternion: simd_quatd) -> Self
}

extension Rotatable3D {
    @inlinable public mutating func rotate(by rotation: Rotation3D) {
        rotate(by: rotation.quaternion)
    }
    
    @inlinable public func rotated(by rotation: Rotation3D) -> Self {
        return rotated(by: rotation.quaternion)
    }
    
    @inlinable public func rotated(by quaternion: simd_quatd) -> Self {
        var v = self
        v.rotate(by: quaternion)
        return v
    }
}
