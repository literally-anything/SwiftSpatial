public import simd
public import RealModule

/// A rotation in three dimensions.
public struct Rotation3D: Sendable, Hashable, Codable {
    /// A quaternion that represents the rotation.
    public var quaternion: simd_quatd
    /// The underlying vector of the quaternion.
    @inlinable public var vector: simd_double4 {
        get { quaternion.vector }
        set(newValue) { quaternion.vector = newValue }
    }
    /// The x value.
    @inlinable public var x: Double {
        get { vector.x }
        set(newValue) { vector.x = newValue }
    }
    /// The y value.
    @inlinable public var y: Double {
        get { vector.y }
        set(newValue) { vector.y = newValue }
    }
    /// The z value.
    @inlinable public var z: Double {
        get { vector.z }
        set(newValue) { vector.z = newValue }
    }
    /// The w value.
    @inlinable public var w: Double {
        get { vector.w }
        set(newValue) { vector.w = newValue }
    }
    /// The angle of the rotation.
    @inlinable public var angle: Angle2D {
        get {
            .init(radians: quaternion.angle)
        }
        set(newValue) {
            quaternion = .init(angle: newValue.radians, axis: quaternion.axis)
        }
    }
    /// The axis of the rotation.
    @inlinable public var axis: RotationAxis3D {
        get {
            .init(vector: quaternion.axis)
        }
        set(newValue) {
            quaternion = .init(angle: quaternion.angle, axis: newValue.vector)
        }
    }
    /// The inverse of the rotation.
    @inlinable public var inverse: Rotation3D {
        var r = self
        r.invert()
        return r
    }
    /// The normalized rotation.
    @inlinable public var normalized: Rotation3D {
        var r = self
        r.normalize()
        return r
    }
    /// The rotation matrix.
    @inlinable public var matrix: simd_double4x4 {
        simd_matrix4x4(quaternion)
    }
    /// A Boolean representing whether the quatenion is a valid rotation.
    @inlinable public var valid: Bool {
        quaternion.length.isApproximatelyEqual(to: 1)
    }
    
    /// Creates a rotation structure using an identity quaternion.
    @inlinable public init() {
        self.init(quaternion: .identity)
    }
    /// Creates a rotation from the specified single-precision quaternion.
    /// - Parameters:
    ///     - quaternion: A single-precision quaternion that specifies the rotation.
    @inlinable public init(_ quaternion: simd_quatf) {
        self.init(quaternion: .init(ix: Double(quaternion.vector.x),
                                    iy: Double(quaternion.vector.y),
                                    iz: Double(quaternion.vector.z),
                                    r: Double(quaternion.vector.w)))
    }
    /// Creates a rotation from the specified double-precision quaternion.
    /// - Parameters:
    ///     - quaternion: A double-precision quaternion that specifies the rotation.
    @inlinable public init(_ quaternion: simd_quatd) {
        self.init(quaternion: quaternion)
    }
    /// Creates a rotation structure with the specified Euler angles.
    /// - Parameters:
    ///     - eulerAngles: A structure that specifies the order and values of the Euler angles.
    @inlinable public init(eulerAngles: EulerAngles) {
        let halfAngles = eulerAngles.angles / 2
        
        let cosr = cos(halfAngles.x)
        let sinr = sin(halfAngles.x)
        let cosp = cos(halfAngles.y)
        let sinp = sin(halfAngles.y)
        let cosy = cos(halfAngles.z)
        let siny = sin(halfAngles.z)
        
        let r = cosr * cosp * cosy + sinr * sinp * siny
        let i1 = sinr * cosp * cosy - cosr * sinp * siny
        let i2 = cosr * sinp * cosy + sinr * cosp * siny
        let i3 = cosr * cosp * siny - sinr * sinp * cosy
        
        let imag: SIMD3<Double>
        switch eulerAngles.order {
        case .xyz:
            imag = .init(x: i1, y: i2, z: i3)
        case .zxy:
            imag = .init(x: i3, y: i1, z: i2)
        }
        
        self.init(quaternion: .init(real: r,
                                    imag: imag).normalized)
    }
    /// Creates a rotation structure with the specified axis and the specified angle from Spatial structures.
    /// - Parameters:
    ///     - angle: The rotation angle.
    ///     - axis: The rotation axis.
    @inlinable public init(
        angle: Angle2D,
        axis: RotationAxis3D
    ) {
        self.init(quaternion: .init(angle: angle.radians,
                                    axis: axis.vector).normalized)
    }
    /// Creates a rotation structure that represents the look-at direction from a position to a target.
    /// - Parameters:
    ///     - position: The eye position.
    ///     - target: The target position.
    ///     - up: The up direction.
    @inlinable public init(
        position: Point3D = .zero,
        target: Point3D,
        up: Vector3D = .up
    ) {
        self.init(forward: target - position, up: up)
    }
    /// Creates a rotation with the specified forward vector.
    /// - Parameters:
    ///     - forward: The forward vector.
    @inlinable public init(forward: Vector3D) {
        self.init(forward: forward, up: .up)
    }
    /// Creates a rotation with the specified forward and up vectors.
    /// - Parameters:
    ///     - forward: The forward vector.
    ///     - up: The up vector.
    @inlinable public init(forward: Vector3D, up: Vector3D) {
        assert(forward.length.isApproximatelyEqual(to: 1), "Forward vector length is not 1: \(forward.length)")
        assert(up.length.isApproximatelyEqual(to: 1), "Up vector length is not 1: \(up.length)")
        
        let side = forward.cross(up)
        let up_norm = forward.cross(side)
        
        let matrix = simd_double3x3(columns: (forward.vector, up_norm.vector, side.vector))
        self.init(quaternion: simd_quatd(matrix).normalized)
    }
    /// Creates a rotation from the specified double-precision quaternion.
    /// - Parameters:
    ///     - quaternion: A double-precision quaternion that specifies the rotation.
    @inlinable public init(quaternion: simd_quatd) {
        self.quaternion = quaternion
    }
    
    /// Invert the rotation by getting the inverse of the quaternion.
    @inlinable public mutating func invert() {
        quaternion = quaternion.inverse
    }
    
    /// Normalize the rotation.
    @inlinable public mutating func normalize() {
        quaternion = quaternion.normalized
    }
    
    /// Calculates the dot product of the rotation and the specified rotation.
    /// - Parameters:
    ///     - other: The second rotation.
    /// - Returns: The dot product of the rotation and the specified rotation.
    @inlinable public func dot(_ other: Rotation3D) -> Double {
        simd.dot(other.quaternion, quaternion)
    }
    /// Returns the spherical linear interpolation along either the shortest or the longest arc between two rotations.
    /// - Parameters:
    ///     - from: The starting rotation.
    ///     - to: The ending rotation.
    ///     - t: The position along the interpolation that’s between 0 and 1.
    ///     - path: An enumeration that specifies whether the interpolation should be along the shortest or the longest path between the two rotations.
    /// - Returns: A new rotation. When t = 0.0, the result is the from rotation. When t = 1.0, the result is the to rotation. For any other value of t, the result is a spherical linear interpolation between the two rotations.
    @inlinable public static func slerp(
        from: Rotation3D,
        to: Rotation3D,
        t: Double,
        along path: Rotation3D.SlerpPath = .shortest
    ) -> Rotation3D {
        let quaternion: simd_quatd
        switch path {
        case .automatic, .shortest:
            quaternion = simd_slerp(from.quaternion, to.quaternion, t)
        case .longest:
            quaternion = simd_slerp_longest(from.quaternion, to.quaternion, t)
        }
        return .init(quaternion: quaternion)
    }
    
    /// Returns the twist component of the rotation’s swing-twist decomposition for a given twist axis.
    /// - Parameters:
    ///     - twistAxis: The twist axis.
    /// - Returns: The twist component of the rotation’s swing-twist decomposition for a given twist axis.
    @inlinable public func twist(twistAxis: RotationAxis3D) -> Rotation3D {
        let p = simd_dot(.init(x: x, y: y, z: z), twistAxis.vector) * twistAxis.vector
        let twist = simd_quatd(real: w, imag: p)
        return .init(quaternion: simd_normalize(twist))
    }
    @usableFromInline internal func swing(twistAxis: RotationAxis3D, twist: Rotation3D) -> Rotation3D {
        .init(quaternion: quaternion * twist.quaternion.conjugate)
    }
    /// Returns the swing component of the rotation’s swing-twist decomposition for a given twist axis.
    /// - Parameters:
    ///     - twistAxis: The twist axis.
    /// - Returns: The swing component of the rotation’s swing-twist decomposition for a given twist axis.
    @inlinable public func swing(twistAxis: RotationAxis3D) -> Rotation3D {
        swing(twistAxis: twistAxis, twist: twist(twistAxis: twistAxis))
    }
    /// Returns the rotation’s swing-twist decomposition for a given twist axis.
    /// - Parameters:
    ///     - twistAxis: The twist axis.
    /// - Returns: A tuple that contains the swing rotation and the twist rotation.
    @inlinable public func swingTwist(twistAxis: RotationAxis3D) -> (swing: Rotation3D, twist: Rotation3D) {
        let twist = twist(twistAxis: twistAxis)
        let swing = swing(twistAxis: twistAxis, twist: twist)
        
        return (swing, twist)
    }
    
    /// Returns an interpolated value between two rotations along a spherical cubic spline.
    @inlinable public static func spline(
        leftEndpoint r0: Rotation3D,
        from r1: Rotation3D,
        to r2: Rotation3D,
        rightEndpoint r3: Rotation3D,
        t: Double
    ) -> Rotation3D {
        let spline = simd_spline(.init(vector: r0.vector),
                                 .init(vector: r1.vector),
                                 .init(vector: r2.vector),
                                 .init(vector: r3.vector),
                                 t)
        return .init(quaternion: .init(vector: spline.vector))
    }
    
    /// Returns a rotation’s Euler angles.
    /// - Parameters:
    ///     - order: The Euler angle ordering.
    /// - Returns: A structure that represents Euler angles and ordering.
    @inlinable public func eulerAngles(order: EulerAngles.Order) -> EulerAngles {
        let r = w
        let i1, i2, i3: Double
        switch order {
        case .xyz:
            i1 = x
            i2 = y
            i3 = z
        case .zxy:
            i1 = z
            i2 = x
            i3 = y
        }
        
        // Roll
        let sinr_cosp = 2 * (r * i1 + i2 * i3)
        let cosr_cosp = 1.0 - 2.0 * (pow(i1, 2) + pow(i2, 2))
        let roll = atan2(sinr_cosp, cosr_cosp)
        
        // Pitch
        let val = 2 * (r * i2 - i1 * i3)
        let sinp = sqrt(1 + val)
        let cosp = sqrt(1 - val)
        let pitch = 2 * atan2(sinp, cosp) - .pi / 2
        
        // Yaw
        let siny_cosp = 2 * (r * i3 + i1 * i2)
        let cosy_cosp = 1 - 2 * (pow(i2, 2) + pow(i3, 2))
        let yaw = atan2(siny_cosp, cosy_cosp)
        
        return .init(angles: .init(x: roll,
                                   y: pitch,
                                   z: yaw),
                     order: order)
    }
    
    /// Constants that define the arc that a slerp operation takes.
    public enum SlerpPath: Sendable, Codable, Hashable {
        /// Spherical linear interpolation along the automatically selected arc between two rotations.
        case automatic
        /// Spherical linear interpolation along the shortest arc between two rotations.
        case shortest
        /// Spherical linear interpolation along the longest arc between two rotations.
        case longest
    }
    
    /// A vector that represents three Euler angles and specifies the angle ordering.
    public struct EulerAngles: Sendable, Codable, Hashable,
                               CustomStringConvertible, CustomDebugStringConvertible {
        public var angles: SIMD3<Double>
        public var order: Order
        
        /// Creates a new Euler angles structure with all zeros.
        @inlinable public init() {
            self.init(angles: SIMD3<Double>.zero, order: .xyz)
        }
        /// Creates a new Euler angles structure from the specified single-precision angles and order.
        /// - Parameters:
        ///     - x: The first angle.
        ///     - y: The second angle.
        ///     - z: The third angle.
        ///     - order: The Euler angle order.
        @inlinable public init(x: Angle2D,
                               y: Angle2D,
                               z: Angle2D,
                               order: EulerAngles.Order
        ) {
            self.init(angles: SIMD3<Double>.init(x: x.radians,
                                                 y: y.radians,
                                                 z: z.radians),
                      order: order)
        }
        /// Creates a new Euler angles structure from the specified single-precision angles and order.
        /// - Parameters:
        ///     - angles: A three-element, single-precision vector that specifies the Euler angles.
        ///     - order: The Euler angle order.
        @inlinable public init(angles: SIMD3<Float>, order: Order) {
            self.init(angles: SIMD3<Double>.init(x: Double(angles.x),
                                                 y: Double(angles.y),
                                                 z: Double(angles.z)),
                      order: order)
        }
        /// Creates a new Euler angles structure from the specified double-precision angles and order.
        /// - Parameters:
        ///     - angles: A three-element, double-precision vector that specifies the Euler angles.
        ///     - order: The Euler angle order.
        @inlinable public init(angles: SIMD3<Double>, order: Order) {
            self.angles = angles
            self.order = order
        }
        
        /// A textual representation of the euler angles.
        @inlinable public var description: String { "(roll: \(angles.x), pitch: \(angles.y), yaw: \(angles.z))" }
        /// A textual representation of the euler angles for debugging.
        @inlinable public var debugDescription: String { description }
        
        /// A type that specifies the order of the angles.
        public enum Order: Sendable, Codable, Hashable {
            case xyz
            case zxy
        }
    }
}

extension Rotation3D: ExpressibleByArrayLiteral {
    /// Initialize the rotation using an array of quaternion components.
    /// The array should only ever be of length 4.
    /// - Parameters:
    ///     - elements: The array of length 4 that defines the x, y, z, and w components.
    @inlinable public init(arrayLiteral elements: Double...) {
        assert(elements.count == 4, "Rotation3Dh only has 4 elements.")

        self.init(quaternion: .init(vector:
                .init(x: elements[0], y: elements[1], z: elements[2], w: elements[3])
        ))
    }
}

extension Rotation3D: ApproximatelyEquatable {
    @inlinable public func isApproximatelyEqual(to other: Rotation3D,
                                                relativeTolerance: Double = .ulpOfOne.squareRoot()) -> Bool {
        dot(other).isApproximatelyEqual(to: 1, relativeTolerance: relativeTolerance)
    }

    @inlinable public func isApproximatelyEqual(to other: Rotation3D,
                                                absoluteTolerance: Double, relativeTolerance: Double = 0) -> Bool {
        dot(other).isApproximatelyEqual(to: 1, absoluteTolerance: absoluteTolerance, relativeTolerance: relativeTolerance)
    }
}

extension Rotation3D {
    /// The identity rotation.
    public static let identity: Rotation3D = .init()
    
    /// A Boolean value that indicates whether the rotation is the identity rotation.
    @inlinable public var isIdentity: Bool {
        quaternion == Self.identity.quaternion
    }
}

extension Rotation3D: Rotatable3D {
    /// Applies the specified quaternion.
    /// - Parameters:
    ///     - quaternion: The quaternion that defines the rotation’s angle and axis.
    @inlinable public mutating func rotate(by quaternion: simd_quatd) {
        assert(quaternion.length.isApproximatelyEqual(to: 1))
        
        self.quaternion *= quaternion
    }
}

extension Rotation3D {
    /// Returns the element wize negation of the rotaion.
    /// - Parameters;
    ///     - rotation: The rotation that is negated.
    @inlinable public static prefix func - (rotation: Rotation3D) -> Rotation3D {
        var r = rotation
        r.vector = -r.vector
        return r
    }
    
    /// Returns the product of two rotations.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    /// - Returns: The product rotation.
    @inlinable public static func * (lhs: Rotation3D, rhs: Rotation3D) -> Rotation3D {
        var r = lhs
        r *= rhs
        return r
    }
    /// Returns the spherical linear interpolation between the identity rotation and the left-hand-side rotation at the right-hand-side interpolation parameter.
    /// - Parameters:
    ///     - lhs: The rotation.
    ///     - rhs: The interpolation parameter.
    @inlinable public static func * (lhs: Rotation3D, rhs: Double) -> Rotation3D {
        .init(quaternion: simd_slerp(.identity, lhs.quaternion, rhs))
    }
    /// Returns the spherical linear interpolation between the identity rotation and the right-hand-side rotation at the left-hand-side interpolation parameter.
    /// - Parameters:
    ///     - lhs: The interpolation parameter.
    ///     - rhs: The rotation.
    @inlinable public static func * (lhs: Double, rhs: Rotation3D) -> Rotation3D {
        .init(quaternion: simd_slerp(.identity, rhs.quaternion, lhs))
    }
    /// Returns the rotatable entity that results from applying the rotatable entity.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func * <T>(lhs: Rotation3D, rhs: T) -> T where T : Rotatable3D {
        rhs.rotated(by: lhs)
    }
    
    /// Computes the product of two rotations and stores the result in the left-hand-side variable.
    /// - Parameters:
    ///     - lhs: The left-hand-side value.
    ///     - rhs: The right-hand-side value.
    @inlinable public static func *= (lhs: inout Rotation3D, rhs: Rotation3D) {
        lhs.quaternion *= rhs.quaternion
    }
}

extension Rotation3D: SIMDStorage {
    @inlinable public var scalarCount: Int { 4 }
    @inlinable public subscript(index: Int) -> Double {
        get {
            vector[index]
        }
        set(newValue) {
            vector[index] = newValue
        }
    }
}

extension Rotation3D: CustomStringConvertible, CustomDebugStringConvertible {
    /// A textual representation of the rotation quaternion.
    @inlinable public var description: String { "(x: \(x), y: \(y), z: \(z), w: \(w))" }
    /// A textual representation of the rotation quaternion for debugging.
    @inlinable public var debugDescription: String { description }
}
