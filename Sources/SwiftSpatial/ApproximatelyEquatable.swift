public protocol ApproximatelyEquatable {
    associatedtype Magnitude: FloatingPoint

    /// Test if `self` and `other` are approximately equal.
    ///
    /// `true` if `self` and `other` are equal, or if they are finite and
    /// ```
    /// norm(self - other) <= relativeTolerance * scale
    /// ```
    /// where `scale` is
    /// ```
    /// max(norm(self), norm(other), .leastNormalMagnitude)
    /// ```
    ///
    /// The default value of `relativeTolerance` is `.ulpOfOne.squareRoot()`,
    /// which corresponds to expecting "about half the digits" in the computed
    /// results to be good. This is the usual guidance in numerical analysis,
    /// if you don't know anything about the computation being performed, but
    /// is not suitable for all use cases.
    ///
    /// Mathematical Properties:
    ///
    /// - `isApproximatelyEqual(to:relativeTolerance:norm:)` is _reflexive_ for
    ///   non-exceptional values (such as NaN).
    ///
    /// - `isApproximatelyEqual(to:relativeTolerance:norm:)` is _symmetric_.
    ///
    /// - `isApproximatelyEqual(to:relativeTolerance:norm:)` is __not__
    ///   _transitive_. Because of this, approximately equality is __not an
    ///   equivalence relation__, even when restricted to non-exceptional values.
    ///
    ///   This means that you must not use approximate equality to implement
    ///   a conformance to Equatable, as it will violate the invariants of
    ///   code written against that protocol.
    ///
    /// - For any point `a`, the set of values that compare approximately equal
    ///   to `a` is _convex_. (Under the assumption that the `.magnitude`
    ///   property implements a valid norm.)
    ///
    /// - `isApproximatelyEqual(to:relativeTolerance:norm:)` is _scale invariant_,
    ///   so long as no underflow or overflow has occured, and no exceptional
    ///   value is produced by the scaling.
    ///
    /// See also `isApproximatelyEqual(to:absoluteTolerance:[relativeTolerance:norm:])`.
    ///
    /// - Parameters:
    ///
    ///   - other: The value to which `self` is compared.
    ///
    ///   - relativeTolerance: The tolerance to use for the comparison.
    ///     Defaults to `.ulpOfOne.squareRoot()`.
    ///
    ///     This value should be non-negative and less than or equal to 1.
    ///     This constraint on is only checked in debug builds, because a
    ///     mathematically well-defined result exists for any tolerance,
    ///     even one out of range.
    func isApproximatelyEqual(
        to other: Self,
        relativeTolerance: Magnitude
    ) -> Bool

    /// Test if `self` and `other` are approximately equal with specified tolerances.
    ///
    /// `true` if `self` and `other` are equal, or if they are finite and either
    /// ```
    /// (self - other).magnitude <= absoluteTolerance
    /// ```
    /// or
    /// ```
    /// (self - other).magnitude <= relativeTolerance * scale
    /// ```
    /// where `scale` is `max(self.magnitude, other.magnitude)`.
    ///
    /// Mathematical Properties:
    ///
    /// - `isApproximatelyEqual(to:absoluteTolerance:relativeTolerance:)`
    ///   is _reflexive_ for non-exceptional values (such as NaN).
    ///
    /// - `isApproximatelyEqual(to:absoluteTolerance:relativeTolerance:)`
    ///   is _symmetric_.
    ///
    /// - `isApproximatelyEqual(to:relativeTolerance:norm:)` is __not__
    ///   _transitive_. Because of this, approximately equality is __not an
    ///   equivalence relation__, even when restricted to non-exceptional values.
    ///
    ///   This means that you must not use approximate equality to implement
    ///   a conformance to Equatable, as it will violate the invariants of
    ///   code written against that protocol.
    ///
    /// - For any point `a`, the set of values that compare approximately equal
    ///   to `a` is _convex_. (Under the assumption that `norm` implements a
    ///   valid norm, which cannot be checked by this function.)
    ///
    /// See also `isApproximatelyEqual(to:[relativeTolerance:])`.
    ///
    /// - Parameters:
    ///
    ///   - other: The value to which `self` is compared.
    ///
    ///   - absoluteTolerance: The absolute tolerance to use in the comparison.
    ///
    ///     This value should be non-negative and finite.
    ///     This constraint on is only checked in debug builds, because a
    ///     mathematically well-defined result exists for any tolerance,
    ///     even one out of range.
    ///
    ///   - relativeTolerance: The relative tolerance to use in the comparison.
    ///     Defaults to zero.
    ///
    ///     This value should be non-negative and less than or equal to 1.
    ///     This constraint on is only checked in debug builds, because a
    ///     mathematically well-defined result exists for any tolerance,
    ///     even one out of range.
    func isApproximatelyEqual(
        to other: Self,
        absoluteTolerance: Magnitude,
        relativeTolerance: Magnitude
    ) -> Bool
    
    /// This function is for compatibility with the originial Spatial framework from Apple.
    @available(*, deprecated, message: "Only for compatibility with Apple's Spatial Framework",
                              renamed: "isApproximatelyEqual(to:relativeTolerance:)")
    func isApproximatelyEqual(
        to other: Self,
        tolerance: Magnitude
    ) -> Bool
}

extension ApproximatelyEquatable {
    public func isApproximatelyEqual(
        to other: Self,
        tolerance: Magnitude = .ulpOfOne.squareRoot()
    ) -> Bool {
        isApproximatelyEqual(to: other, relativeTolerance: tolerance)
    }
}
