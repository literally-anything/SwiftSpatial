/// A set of methods common to Spatial primitives.
public protocol Primitive2D {
    /// A primitive with infinite values.
    static var infinity: Self { get }
    /// A primitive with zero values.
    static var zero: Self { get }

    /// Returns a Boolean value that indicates whether the primitive is zero.
    var isZero: Bool { get }
    /// Returns a Boolean value that indicates whether the primitive is finite.
    var isFinite: Bool { get }
    /// Returns a Boolean value that indicates whether the primitive contains any NaN values.
    var isNaN: Bool { get }

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
    /// Applies a pose.
    /// - Parameters:
    ///     - pose: The pose that the function applies to the Spatial primitive.
    mutating func apply(_ pose: Pose2D)
//    /// Applies a scaled pose.
//    /// - Parameters:
//    ///     - pose: The scaled pose that the function applies to the Spatial primitive.
//    mutating func apply(_ scaledPose: ScaledPose2D)

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
    /// Returns the entity that results from applying a pose.
    /// - Parameters:
    ///     - pose: The pose that the function applies to the Spatial primitive.
    /// (Needs default implementation)
    func applying(_ pose: Pose2D) -> Self
//    /// Returns the entity that results from applying the specified scaled pose.
//    /// - Parameters:
//    ///     - pose: The scaled pose that the function applies to the Spatial primitive.
//    func applying(_ scaledPose: ScaledPose2D) -> Self

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
    /// Unapplies a pose.
    /// - Parameters:
    ///     - pose: The pose that the function unapplies to the Spatial primitive.
    /// (Needs default implementation)?
    mutating func unapply(_ pose: Pose2D)
//    /// Unapplies a scaled pose.
//    /// - Parameters:
//    ///     - pose: The scaled pose that the function unapplies to the Spatial primitive.
//    mutating func unapply(_ scaledPose: ScaledPose2D)

//    /// Returns the entity that results from unapplying an affine transform.
//    /// - Parameters:
//    ///     - transform: The affine transform that the function unapplies to the Spatial primitive.
//    /// (Needs default implementation)
//    func unapplying(_ transform: AffineTransform3D) -> Self
//    /// Returns the entity that results from unapplying a projective transform.
//    /// - Parameters:
//    ///     - transform: The projective transform that the function unapplies to the Spatial primitive.
//    /// (Needs default implementation)?
//    mutating func unapplying(_ transform: ProjectiveTransform3D) -> Self
    /// Returns the entity that results from unapplying a pose.
    /// - Parameters:
    ///     - pose: The pose that the function unapplies to the Spatial primitive.
    /// (Needs default implementation)?
    func unapplying(_ pose: Pose2D) -> Self
//    /// Returns the entity that results from unapplying the specified scaled pose.
//    /// - Parameters:
//    ///     - pose: The scaled pose that the function unapplies to the Spatial primitive.
//    func unapplying(_ scaledPose: ScaledPose2D) -> Self
}

extension Primitive2D {
    @inlinable public func applying(_ pose: Pose2D) -> Self {
        var s = self
        s.apply(pose)
        return s
    }
//    @inlinable public func applying(_ scaledPose: ScaledPose2D) -> Self {
//        var s = self
//        s.apply(scaledPose)
//        return s
//    }
    
    @inlinable public func unapplying(_ pose: Pose2D) -> Self {
        var s = self
        s.unapply(pose)
        return s
    }
//    @inlinable public func unapplying(_ scaledPose: ScaledPose2D) -> Self {
//        var s = self
//        s.unapply(scaledPose)
//        return s
//    }
    
    @inlinable public mutating func unapply(_ pose: Pose2D) {
        self.apply(-pose)
    }
//    @inlinable public mutating func unapply(_ scaledPose: ScaledPose2D) {
//        self.apply(-scaledPose)
//    }
}
