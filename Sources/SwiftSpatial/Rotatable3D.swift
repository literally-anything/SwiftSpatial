import simd

/// A set of methods that defines the interface to rotate Spatial entities.
public protocol Rotatable3D {
    /// Rotates the entity by a quaternion.
    /// - Parameters:
    ///     - quaternion: The double-precision quaternion that specifies the rotation.
    mutating func rotate(by quaternion: simd_quatd)
//    /// Rotates the entity by an angle over an axis.
//    /// - Parameters:
//    ///     - rotation: The rotation structure that defines the rotation’s angle and axis.
//    /// (Needs default implementation)
//    mutating func rotate(by rotation: Rotation3D)
    
    /// Returns the entity that a quaternion rotates.
    /// - Parameters:
    ///     - quaternion: The double-precision quaternion that specifies the rotation.
    func rotated(by quaternion: simd_quatd) -> Self
//    /// Returns the entity that results from applying the specified rotation.
//    /// - Parameters:
//    ///     - rotation: The rotation structure that defines the rotation’s angle and axis.
//    /// (Needs default implementation)
//    func rotated(by rotation: Rotation3D) -> Self
}
