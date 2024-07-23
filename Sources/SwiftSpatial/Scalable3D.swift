/// A set of methods that defines the interface to scale Spatial entities.
public protocol Scalable3D {
//    /// Scales the entity by the specified size.
//    /// - Parameters:
//    ///     - size: The size structure that defines the scale.
//    /// (Needs default implementation)?
//    mutating func scale(by size: Size3D)
    /// Scales the entity by the specified values.
    /// - Parameters:
    ///     - x: The double-precision value that specifies the scale along the x-dimension.
    ///     - y: The double-precision value that specifies the scale along the y-dimension.
    ///     - z: The double-precision value that specifies the scale along the z-dimension.
    /// (Needs default implementation)?
    mutating func scaleBy(x: Double, y: Double, z: Double)
    /// Uniformly scales the entity by the specified scalar value.
    /// - Parameters:
    ///     - scale: The double-precision value that specifies the uniform scale.
    /// (Needs default implementation)
    mutating func uniformlyScale(by scale: Double)
    
//    /// Returns the entity that results from scaling with the specified size.
//    /// - Parameters:
//    ///     - size: The size structure that defines the scale.
//    /// (Needs default implementation)
//    func scaled(by size: Size3D) -> Self
    /// Returns the entity that results from scaling with the specified values.
    /// - Parameters:
    ///     - x: The double-precision value that specifies the scale along the x-dimension.
    ///     - y: The double-precision value that specifies the scale along the y-dimension.
    ///     - z: The double-precision value that specifies the scale along the z-dimension.
    /// (Needs default implementation)
    func scaledBy(x: Double, y: Double, z: Double) -> Self
    /// Returns the entity that results from uniformly scaling with the specified scalar value.
    /// - Parameters:
    ///     - scale: The double-precision value that specifies the uniform scale.
    /// (Needs default implementation)
    func uniformlyScaled(by scale: Double) -> Self
}
