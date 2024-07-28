/// A set of methods for working with Spatial primitives with volume.
public protocol Volumetric {
    /// The size of the volume.
    var size: Size3D { get }
    
    /// Returns a Boolean value that indicates whether the entity contains the specified volumetric entity.
    /// - Parameters:
    ///     - other: The volumetric entity that the function compares against.
    func contains(_ other: Self) -> Bool
    
    /// Returns a Boolean value that indicates whether this volume contains the specified point.
    /// - Parameters:
    ///     - point: The point that the function compares against.
    func contains(point: Point3D) -> Bool
    
    /// Returns a Boolean value that indicates whether this volume contains any of the specified points.
    /// - Parameters:
    ///     - points: The array of points that the function compares against.
    /// (Needs default implementation)?
    func contains(anyOf points: [Point3D]) -> Bool
    
    /// Sets the primitive to the intersection of itself and the specified primitive.
    /// - Parameters:
    ///     - other: The volumetric entity that the function compares against.
    mutating func formIntersection(_ other: Self)
    
    /// Sets the primitive to the union of itself and the specified primitive.
    /// - Parameters:
    ///     - other: The volumetric entity that the function compares against.
    mutating func formUnion(_ other: Self)
    
    /// Returns the intersection of two volumetric entities.
    /// - Parameters:
    ///     - other: The volumetric entity that the function compares against.
    func intersection(_ other: Self) -> Self?
    
    /// Returns the smallest volumetric entity that contains the two source entities.
    /// - Parameters:
    ///     - other: The volumetric entity that the function compares against.
    func union(_ other: Self) -> Self
}
