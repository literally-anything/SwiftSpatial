/// A set of methods that defines the interface to scale Spatial entities.
public protocol Scalable2D {
    /// Scales the entity by the specified size.
    /// - Parameters:
    ///     - size: The size structure that defines the scale.
    mutating func scale(by size: Size2D)
    /// Scales the entity by the specified values.
    /// - Parameters:
    ///     - x: The double-precision value that specifies the scale along the x-dimension.
    ///     - y: The double-precision value that specifies the scale along the y-dimension.
    mutating func scaleBy(x: Double, y: Double)
    /// Uniformly scales the entity by the specified scalar value.
    /// - Parameters:
    ///     - scale: The double-precision value that specifies the uniform scale.
    mutating func uniformlyScale(by scale: Double)
    
    /// Returns the entity that results from scaling with the specified size.
    /// - Parameters:
    ///     - size: The size structure that defines the scale.
    func scaled(by size: Size2D) -> Self
    /// Returns the entity that results from scaling with the specified values.
    /// - Parameters:
    ///     - x: The double-precision value that specifies the scale along the x-dimension.
    ///     - y: The double-precision value that specifies the scale along the y-dimension.
    func scaledBy(x: Double, y: Double) -> Self
    /// Returns the entity that results from uniformly scaling with the specified scalar value.
    /// - Parameters:
    ///     - scale: The double-precision value that specifies the uniform scale.
    func uniformlyScaled(by scale: Double) -> Self
}

extension Scalable2D {
    @inlinable public func scaled(by size: Size2D) -> Self {
        var v = self
        v.scale(by: size)
        return v
    }
    
    @inlinable public func scaledBy(x: Double, y: Double) -> Self {
        var v = self
        v.scaleBy(x: x, y: y)
        return v
    }
    
    @inlinable public func uniformlyScaled(by scale: Double) -> Self {
        var v = self
        v.uniformlyScale(by: scale)
        return v
    }
}
