/// A set of methods that defines the interface to translate 2D Spatial entities.
public protocol Translatable2D {
    /// Translates the entity by the specified vector.
    /// - Parameters:
    ///     - vector: The vector that defines the translation.
    mutating func translate(by vector: Vector2D)
    
    /// Returns the entity that results from translating with the specified vector.
    /// - Parameters:
    ///     - vector: The vector that defines the translation.
    /// (Needs default implementation)
    func translated(by vector: Vector2D) -> Self
}

extension Translatable2D {
    @inlinable public func translated(by vector: Vector2D) -> Self {
        var v = self
        v.translate(by: vector)
        return v
    }
}
