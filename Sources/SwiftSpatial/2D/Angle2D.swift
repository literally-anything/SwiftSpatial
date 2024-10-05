public import Foundation
public import RealModule

/// A geometric angle with a value you access in either radians or degrees.
public struct Angle2D: Sendable, Codable, Hashable {
    /// The angle in radians.
    public var radians: Double
    /// The angle in degrees.
    @inlinable public var degrees: Double { radians * 180 / .pi }
    /// Returns the specified angle normalized between –180° and 180.0°.
    @inlinable public var normalized: Angle2D {
        var angle = self
        angle.normalize()
        return angle
    }
    /// Returns the inverse of the angle.
    @inlinable public var inverse: Angle2D {
        var angle = self
        angle.invert()
        return angle
    }
    /// Returns the negative of the angle.
    @inlinable public var negated: Angle2D {
        var angle = self
        angle.negate()
        return angle
    }
    
    /// Creates an angle.
    @inlinable public init() {
        self.init(radians: 0)
    }
    /// Creates an angle with the specified floating-point degrees.
    /// - Parameters:
    ///     - degrees: A floating-point value that specifies the angle in degrees.
    @inlinable public init<T>(degrees: T) where T : BinaryFloatingPoint {
        self.init(radians: Double(degrees))
    }
    /// Creates an angle with the specified floating-point radians.
    /// - Parameters:
    ///     - radians: A floating-point value that specifies the angle in radians.
    @inlinable public init<T>(radians: T) where T : BinaryFloatingPoint {
        self.init(radians: Double(radians))
    }
    /// Creates an angle with the specified double-precision degrees.
    /// - Parameters:
    ///     - degrees: A double-precision value that specifies the angle in degrees.
    @inlinable public init(degrees: Double) {
        self.init(radians: degrees * .pi / 180)
    }
    /// Creates an angle with the specified double-precision radians.
    /// - Parameters:
    ///     - radians: A double-precision value that specifies the angle in radians.
    @inlinable public init(radians: Double) {
        self.radians = radians
    }
    /// Returns a new angle structure with the specified double-precision degrees.
    /// - Parameters:
    ///     - degrees: The angle in degrees.
    /// - Returns: A new angle structure with the specified double-precision degrees.
    @inlinable public static func degrees(_ degrees: Double) -> Angle2D {
        .init(degrees: degrees)
    }
    /// Returns a new angle structure with the specified double-precision radians.
    /// - Parameters:
    ///     - radians: The angle in radians.
    /// - Returns: A new angle structure with the specified double-precision radians.
    @inlinable public static func radians(_ radians: Double) -> Angle2D {
        .init(radians: radians)
    }
    
    /// Normalizes the angle between –180° and 180.0°.
    @inlinable public mutating func normalize() {
        radians = (radians + .pi).truncatingRemainder(dividingBy: (.pi * 2)) + .pi
    }
    /// Inverts the angle.
    /// The new angle is 180º rotated.
    @inlinable public mutating func invert() {
        if radians >= 0 {
            radians -= .pi
        } else if radians < 0 {
            radians += .pi
        }
    }
    /// Negates the angle.
    @inlinable public mutating func negate() {
        radians.negate()
    }
    
    /// The cosine of the angle.
    @inlinable public var cos: Double { Foundation.cos(radians) }
    /// The hyperbolic cosine of the angle.
    @inlinable public var cosh: Double { Foundation.cosh(radians) }
    /// The sine of the angle.
    @inlinable public var sin: Double { Foundation.sin(radians) }
    /// The hyperbolic sine of the angle.
    @inlinable public var sinh: Double { Foundation.sinh(radians) }
    /// The tangent of the angle.
    @inlinable public var tan: Double { Foundation.tan(radians) }
    /// The hyperbolic tangent of the angle.
    @inlinable public var tanh: Double { Foundation.tanh(radians) }
    
    /// Returns the inverse cosine of the specified value.
    /// - Parameters:
    ///     - x: The source value.
    /// - Returns: The inverse cosine of the specified value.
    @inlinable public static func acos(_ x: Double) -> Angle2D {
        .init(radians: Foundation.acos(x))
    }
    /// Returns the inverse hyperbolic cosine of the specified value.
    /// - Parameters:
    ///     - x: The source value.
    /// - Returns: The inverse hyperbolic cosine of the specified value.
    @inlinable public static func acosh(_ x: Double) -> Angle2D {
        .init(radians: Foundation.acosh(x))
    }
    /// Returns the inverse sine of the specified value.
    /// - Parameters:
    ///     - x: The source value.
    /// - Returns: The inverse sine of the specified value.
    @inlinable public static func asin(_ x: Double) -> Angle2D {
        .init(radians: Foundation.asin(x))
    }
    /// Returns the inverse hyperbolic sine of the specified value.
    /// - Parameters:
    ///     - x: The source value.
    /// - Returns: The inverse hyperbolic sine of the specified value.
    @inlinable public static func asinh(_ x: Double) -> Angle2D {
        .init(radians: Foundation.asinh(x))
    }
    /// Returns the inverse tangent of the specified value.
    /// - Parameters:
    ///     - x: The source value.
    /// - Returns: The inverse tangent of the specified value.
    @inlinable public static func atan(_ x: Double) -> Angle2D {
        .init(radians: Foundation.atan(x))
    }
    /// Returns the inverse hyperbolic tangent of the specified value.
    /// - Parameters:
    ///     - x: The source value.
    /// - Returns: The inverse hyperbolic tangent of the specified value.
    @inlinable public static func atanh(_ x: Double) -> Angle2D {
        .init(radians: Foundation.atanh(x))
    }
    /// Returns the two-argument arctangent of the specified values.
    /// - Parameters:
    ///     - y: The y source value.
    ///     - x: The x source value.
    /// - Returns: The two-argument arctangent of the specified value.
    @inlinable public static func atan2(y: Double, x: Double) -> Angle2D {
        .init(radians: Foundation.atan2(y, x))
    }
}

extension Angle2D: ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral {
    @inlinable public init(integerLiteral value: Int64) {
        self.init(radians: Double(value))
    }
    
    @inlinable public init(floatLiteral value: Double) {
        self.init(radians: value)
    }
}

extension Angle2D: ApproximatelyEquatable {
    @inlinable public func isApproximatelyEqual(to other: Angle2D,
                                                relativeTolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        radians.isApproximatelyEqual(
            to: other.radians,
            relativeTolerance: relativeTolerance
        )
    }
    
    @inlinable public func isApproximatelyEqual(to other: Angle2D,
                                                absoluteTolerance: Double, relativeTolerance: Double = 0) -> Bool {
        radians.isApproximatelyEqual(
            to: other.radians,
            absoluteTolerance: absoluteTolerance,
            relativeTolerance: relativeTolerance
        )
    }
}

extension Angle2D: Rotatable2D {
    @inlinable public mutating func rotate(by angle: Angle2D) {
        radians += angle.radians
    }

    @inlinable public mutating func flip(along axis: Axis2D) {
        switch axis {
        case .x:
            radians.negate()
        case .y:
            radians = .pi - radians
        }
    }
}

extension Angle2D: AdditiveArithmetic {
    /// The angle with the zero value.
    public static let zero: Angle2D = .init()
    
    /// Returns the given angle unchanged.
    @inlinable public static prefix func + (x: Angle2D) -> Angle2D { x }
    /// Adds two angles and produces their sum.
    @inlinable public static func + (lhs: Angle2D, rhs: Angle2D) -> Angle2D {
        var angle = lhs
        angle += rhs
        return angle
    }
    /// Adds two angles and stores the result in the left-hand-side variable.
    @inlinable public static func += (lhs: inout Angle2D, rhs: Angle2D) {
        lhs.radians += rhs.radians
    }
    
    /// Returns the additive inverse of the given angle.
    @inlinable public static prefix func - (x: Angle2D) -> Angle2D {
        var negative = x
        negative.radians.negate()
        return negative
    }
    /// Subtracts one angle from another and produces their difference.
    @inlinable public static func - (lhs: Angle2D, rhs: Angle2D) -> Angle2D {
        var angle = lhs
        angle -= rhs
        return angle
    }
    /// Subtracts the second angle from the first and stores the difference in the left-hand-side variable.
    @inlinable public static func -= (lhs: inout Angle2D, rhs: Angle2D) {
        lhs.radians -= rhs.radians
    }
}

extension Angle2D: CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable public var description: String { "Angle2D(radians: \(radians))" }
    @inlinable public var debugDescription: String { description }
}

/// Returns the cosine of the specified angle.
/// - Parameters:
///     - angle: The source angle.
/// - Returns: The cosine of the specified angle.
@inlinable public func cos(_ angle: Angle2D) -> Double { angle.cos }
/// Returns the hyperbolic cosine of the specified angle.
/// - Parameters:
///     - angle: The source angle.
/// - Returns: The hyperbolic cosine of the specified angle.
@inlinable public func cosh(_ angle: Angle2D) -> Double { angle.cosh }
/// Returns the sine of the specified angle.
/// - Parameters:
///     - angle: The source angle.
/// - Returns: The sine of the specified angle.
@inlinable public func sin(_ angle: Angle2D) -> Double { angle.sin }
/// Returns the hyperbolic sine of the specified angle.
/// - Parameters:
///     - angle: The source angle.
/// - Returns: The hyperbolic sine of the specified angle.
@inlinable public func sinh(_ angle: Angle2D) -> Double { angle.sinh }
/// Returns the tangent of the specified angle.
/// - Parameters:
///     - angle: The source angle.
/// - Returns: The tangent of the specified angle.
@inlinable public func tan(_ angle: Angle2D) -> Double { angle.tan }
/// Returns the hyperbolic tangent of the specified angle.
/// - Parameters:
///     - angle: The source angle.
/// - Returns: The hyperbolic tangent of the specified angle.
@inlinable public func tanh(_ angle: Angle2D) -> Double { angle.tanh }
