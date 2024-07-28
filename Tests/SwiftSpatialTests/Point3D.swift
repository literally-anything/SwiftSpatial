import Testing
@testable import SwiftSpatial

@Suite("Point3D") struct Point3DTests {
    @Suite("Initializers") struct Initializers {
        @Test("Default Initializer") func defaultInitializer() {
            let point = Point3D()
            
            #expect(point.isZero)
            #expect(point.isFinite)
            #expect(!point.isNaN)
        }
        
        @Test("Double Initializer") func doubleInitializer() {
            let point = Point3D(x: 1, y: 0, z: 1)
            
            #expect(!point.isZero)
            #expect(point.isFinite)
            #expect(!point.isNaN)
        }
        
        @Test("Infinite") func zero() {
            let point: Point3D = .infinity
            
            #expect(!point.isZero)
            #expect(!point.isFinite)
            #expect(!point.isNaN)
        }
    }
    
    @Suite("Operations") struct Operations {
        @Test("Aproximate Equality") func equal() throws {
            let point = Point3D(x: -1)
            var point2 = Point3D(x: 1)
            
            try #require(!point.isApproximatelyEqual(to: point2))
            
            point2.x.negate()
            #expect(point.isApproximatelyEqual(to: point2))
        }
        
        @Test("Distance") func distance() {
            let point = Point3D(x: 1)
            
            #expect(point.distance(to: .zero).isAlmostEqual(to: 1))
        }
        
        @Test("Addition") func add() {
            let point = Point3D(x: 1)
            let offset = Vector3D(z: 1)
            
            let sum = Point3D(x: 1, z: 1)
            
            #expect((point + offset).isApproximatelyEqual(to: sum))
        }
        
        @Test("Negate") func negate() {
            let point = Point3D(x: 1)
            
            #expect((-point).x.isAlmostEqual(to: -1))
            #expect((+point).x.isAlmostEqual(to: 1))
        }
        
        @Test("Subtraction") func subtraction() {
            let point = Point3D(x: 1, y: 2)
            let point2 = Point3D(x: -2, y: 3, z: -1)
            
            let vector = point - .zero
            let difference = point - point2
            
            #expect(vector.isApproximatelyEqual(to: .init(x: 1, y: 2)))
            #expect(difference.isApproximatelyEqual(to: .init(x: 3, y: -1, z: 1)))
        }
        
        @Test("Multiplication") func multiplication() {
            let point = Point3D(x: 1, z: 2)
            let product = Point3D(x: 2.5, z: 5)
            let quotient = Point3D(x: 0.5, z: 1)
            
            #expect((point * 2.5).isApproximatelyEqual(to: product))
            #expect((2.5 * point).isApproximatelyEqual(to: product))
            
            #expect((point / 2).isApproximatelyEqual(to: quotient))
        }
        
        @Test("Rotation") func rotation() {
            var point = Point3D(x: 1, y: 2)
            
            point.rotate(by: .init(
                eulerAngles: .init(x: 0,
                                   y: 0,
                                   z: .init(radians: .pi / 2),
                                   order: .xyz)
            ))
            
            #expect(point.isApproximatelyEqual(to: .init(x: -2, y: 1)))
        }
        
        @Test("Applying Poses") func pose() {
            let point = Point3D(x: 1, y: 2)
            
            let pose = Pose3D(
                position: .zero,
                rotation: .init(
                    eulerAngles: .init(x: 0,
                                       y: 0,
                                       z: .init(radians: .pi),
                                       order: .xyz)
                              )
            )
            
            let applied = point.applying(pose)
            
            #expect(applied.isApproximatelyEqual(to: .init(x: -1, y: -2)))
        }
        
        @Test("Applying Scaled Poses") func scaledPose() {
            let point = Point3D(x: 1, y: 2)
            
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
            
            let applied = point.applying(scaledPose)
            
            #expect(applied.isApproximatelyEqual(to: .init(x: -2, y: -4)))
        }
    }
}
