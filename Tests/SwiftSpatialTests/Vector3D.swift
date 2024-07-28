import Testing
@testable import SwiftSpatial

@Suite("Vector3D") struct Vector3DTests {
    @Suite("Initializers") struct Initializers {
        @Test("Default Initializer") func defaultInitializer() {
            let vector = Vector3D()
            
            #expect(vector.isZero)
            #expect(vector.isFinite)
            #expect(!vector.isNaN)
        }
        
        @Test("Double Initializer") func doubleInitializer() {
            let vector = Vector3D(x: 1, y: 0, z: 1)
            
            #expect(!vector.isZero)
            #expect(vector.isFinite)
            #expect(!vector.isNaN)
        }
        
        @Test("Rotation Axis Initializer") func rotationAxisInitializer() {
            let vector = Vector3D(RotationAxis3D.yz)
            
            #expect(!vector.isZero)
            #expect(vector.isFinite)
            #expect(!vector.isNaN)
            
            #expect(vector.x.isAlmostZero()
                    && vector.y.isAlmostEqual(to: 1)
                    && vector.z.isAlmostEqual(to: 1))
        }
        
        @Test("Defaults") func defaults() {
            let infinite: Vector3D = .infinity
            let up: Vector3D = .up
            let right: Vector3D = .right
            let forward: Vector3D = .forward
            
            #expect(!infinite.isZero && !infinite.isFinite && !infinite.isNaN)
            
            #expect(!up.isZero && up.isFinite && !up.isNaN)
            #expect(up.x.isAlmostZero() && up.y.isAlmostEqual(to: 1) && up.z.isAlmostZero())
            
            #expect(!right.isZero && right.isFinite && !right.isNaN)
            #expect(right.x.isAlmostEqual(to: 1) && right.y.isAlmostZero() && right.z.isAlmostZero())
            
            #expect(!forward.isZero && forward.isFinite && !forward.isNaN)
            #expect(forward.x.isAlmostZero() && forward.y.isAlmostZero() && forward.z.isAlmostEqual(to: 1))
        }
    }
    
    @Suite("Operations") struct Operations {
        @Test("Aproximate Equality") func equal() throws {
            let vector = Vector3D(x: -1)
            var vector2 = Vector3D(x: 1)
            
            try #require(!vector.isApproximatelyEqual(to: vector2))
            
            vector2.x.negate()
            #expect(vector.isApproximatelyEqual(to: vector2))
        }
        
        @Test("Length") func length() {
            let vector = Vector3D(y: 5)
            let vector2 = Vector3D(x: 2)
            
            #expect(vector.length.isAlmostEqual(to: 5))
            #expect(vector2.length.isAlmostEqual(to: 2))
        }
        
        @Test("Normalize") func normalize() {
            let vector = Vector3D(x: 1, y: 3)
            
            #expect(vector.normalized.length.isAlmostEqual(to: 1))
        }
        
        @Test("Addition") func add() {
            let vector = Vector3D(x: 1)
            let vector2 = Vector3D(z: 1)
            
            let sum = Vector3D(x: 1, z: 1)
            
            #expect((vector + vector2).isApproximatelyEqual(to: sum))
        }
        
        @Test("Negate") func negate() {
            let vector = Vector3D(x: 1)
            
            #expect((-vector).x.isAlmostEqual(to: -1))
            #expect((+vector).x.isAlmostEqual(to: 1))
        }
        
        @Test("Subtraction") func subtraction() {
            let vector = Vector3D(x: 1, y: 2)
            let vector2 = Vector3D(x: -2, y: 3, z: -1)
            
            let difference = vector - .zero
            let difference2 = vector - vector2
            
            #expect(difference.isApproximatelyEqual(to: .init(x: 1, y: 2)))
            #expect(difference2.isApproximatelyEqual(to: .init(x: 3, y: -1, z: 1)))
        }
        
        @Test("Multiplication") func multiplication() {
            let vector = Vector3D(x: 1, z: 2)
            let product = Vector3D(x: 2.5, z: 5)
            let quotient = Vector3D(x: 0.5, z: 1)
            
            #expect((vector * 2.5).isApproximatelyEqual(to: product))
            #expect((2.5 * vector).isApproximatelyEqual(to: product))
            
            #expect((vector / 2).isApproximatelyEqual(to: quotient))
        }
        
        @Test("Rotation") func rotation() {
            let point = Vector3D(x: 1, y: 2)
            
            let rotated = point.rotated(by: .init(
                eulerAngles: .init(x: 0,
                                   y: 0,
                                   z: .init(radians: .pi / 2),
                                   order: .xyz)
            ))
            
            #expect(rotated.isApproximatelyEqual(to: .init(x: -2, y: 1)))
        }
        
        @Test("Dot Product") func dotProduct() {
            let unitVector = Vector3D(x: 1)
            let vector = Vector3D(x: 2, y: 5)
            let vector2 = Vector3D(y: 1, z: 2)
            
            #expect(unitVector.dot(vector).isAlmostEqual(to: 2))
            #expect(unitVector.dot(vector2).isAlmostZero())
        }
        
        @Test("Cross Product") func crossProduct() {
            let unitVector = Vector3D(x: 1)
            let vector = Vector3D(x: 1, z: 1)
            
            #expect(unitVector.cross(vector).isApproximatelyEqual(to: -.up))
        }
        
        @Test("Get Rotation") func getRotation() throws {
            let vector = Vector3D(x: 1)
            let vector2 = Vector3D(y: 1)
            
            let rotation = vector.rotation(to: vector2)
            try #require(!rotation.isIdentity)
            
            let rot = vector.rotated(by: rotation)
            #expect(rot.isApproximatelyEqual(to: vector2))
        }
        
        @Test("Applying Poses") func pose() {
            let vector = Vector3D(x: 1, y: 2)
            
            let pose = Pose3D(
                position: .zero,
                rotation: .init(
                    eulerAngles: .init(x: 0,
                                       y: 0,
                                       z: .init(radians: .pi),
                                       order: .xyz)
                              )
            )
            
            let applied = vector.applying(pose)
            
            #expect(applied.isApproximatelyEqual(to: .init(x: -1, y: -2)))
        }
        
        @Test("Applying Scaled Poses") func scaledPose() {
            let vector = Vector3D(x: 1, y: 2)
            
            let scaledPose = ScaledPose3D(
                position: .zero,
                rotation: .init(
                    eulerAngles: .init(x: 0,
                                       y: 0,
                                       z: .init(radians: .pi),
                                       order: .xyz)
                              ),
                scale: 2
            )
            
            let applied = vector.applying(scaledPose)
            
            #expect(applied.isApproximatelyEqual(to: .init(x: -2, y: -4)))
        }
    }
}
