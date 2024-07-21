/// A set of methods common to Spatial primitives.
public protocol Primitive3D: Codable, Equatable {
    /// Returns a Boolean value that indicates whether the primitive is zero.
    var isZero: Bool { get }
    /// Returns a Boolean value that indicates whether the primitive is finite.
    var isFinite: Bool { get }
    /// Returns a Boolean value that indicates whether the primitive contains any NaN values.
    var isNaN: Bool { get }
    
    /// A primitive with infinite values.
    static var infinity: Self { get }
    /// A primitive with zero values.
    static var zero: Self { get }
    
//    /// Applies an affine transform.
//    /// - Parameters:
//    ///     - transform: The affine transform that the function applies to the Spatial primitive.
//    /// (Needs default implementation)?
//    mutating func apply(_ transform: AffineTransform3D)
    
//    /// Applies a projective transform.
//    /// - Parameters:
//    ///     - transform: The projective transform that the function applies to the Spatial primitive.
//    /// (Needs default implementation)?
//    mutating func apply(_ transform: ProjectiveTransform3D)
    
//    /// Returns the entity that results from applying an affine transform.
//    /// - Parameters:
//    ///     - transform: The affine transform that the function applies to the Spatial primitive.
//    /// (Needs default implementation)?
//    func applying(_ transform: AffineTransform3D) -> Self
    
//    /// Returns the entity that results from applying a projective transform.
//    /// - Parameters:
//    ///     - transform: The projective transform that the function applies to the Spatial primitive.
//    /// (Needs default implementation)?
//    func applying(_ transform: ProjectiveTransform3D) -> Self
    
//    /// Applies a pose.
//    /// - Parameters:
//    ///     - pose: The pose that the function applies to the Spatial primitive.
//    mutating func apply(_ pose: Pose3D)
    
//    /// Returns the entity that results from applying a pose.
//    /// - Parameters:
//    ///     - pose: The pose that the function applies to the Spatial primitive.
//    /// (Needs default implementation)
//    func applying(_ pose: Pose3D) -> Self
    
//    /// Unapplies an affine transform.
//    /// - Parameters:
//    ///     - transform: The affine transform that the function unapplies to the Spatial primitive.
//    /// (Needs default implementation)
//    mutating func unapply(_ transform: AffineTransform3D)
    
//    /// Unapplies an projective transform.
//    /// - Parameters:
//    ///     - transform: The projective transform that the function unapplies to the Spatial primitive.
//    /// (Needs default implementation)?
//    mutating func unapply(_ transform: ProjectiveTransform3D)
    
//    /// Returns the entity that results from unapplying an affine transform.
//    /// - Parameters:
//    ///     - transform: The affine transform that the function unapplies to the Spatial primitive.
//    /// (Needs default implementation)
//    func unapplying(_ transform: AffineTransform3D) -> Self
    
//    /// Returns the entity that results from unapplying a projective transform.
//    /// - Parameters:
//    ///     - transform: The projective transform that the function unapplies to the Spatial primitive.
//    /// (Needs default implementation)?
//    mutating func unapply(_ transform: ProjectiveTransform3D)
    
//    /// Unapplies a pose.
//    /// - Parameters:
//    ///     - pose: The pose that the function unapplies to the Spatial primitive.
//    /// (Needs default implementation)?
//    mutating func unapply(_ pose: Pose3D)
    
//    /// Returns the entity that results from unapplying a pose.
//    /// - Parameters:
//    ///     - pose: The pose that the function unapplies to the Spatial primitive.
//    /// (Needs default implementation)?
//    func unapplying(_ pose: Pose3D) -> Selffunc unapplying(_ pose: Pose3D) -> Self
}
