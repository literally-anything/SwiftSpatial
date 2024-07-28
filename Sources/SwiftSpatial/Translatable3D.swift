/// A set of methods that defines the interface to translate Spatial entities.
public protocol Translatable3D {
    /// Translates the entity by the specified vector.
    /// - Parameters:
    ///     - vector: The vector that defines the translation.
    mutating func translate(by vector: Vector3D)
    
    /// Returns the entity that results from translating with the specified vector.
    /// - Parameters:
    ///     - vector: The vector that defines the translation.
    /// (Needs default implementation)
    func translated(by vector: Vector3D) -> Self
}

extension Translatable3D {
    @inlinable public func translated(by vector: Vector3D) -> Self {
        var v = self
        v.translate(by: vector)
        return v
    }
}
