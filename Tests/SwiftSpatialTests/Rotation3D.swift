import Testing
@testable import SwiftSpatial

@Suite("Rotation3D") struct Rotation3DTests {
    @Suite("Initializers") struct Initializers {
        @Test("Default Initializer") func defaultInitializer() {
            let rotation = Rotation3D()
            
            #expect(rotation.isIdentity)
        }
        
        @Test("Angles Initializer") func anglesInitializer() {
            let rotation = Rotation3D(eulerAngles: .init(x: 0, y: 0, z: .init(radians: .pi / 2), order: .xyz))
            
            let result = rotation.eulerAngles(order: .xyz)
            #expect(result.angles.x.isAlmostZero())
            #expect(result.angles.y.isAlmostZero())
            #expect(result.angles.z.isAlmostEqual(to: .pi / 2))
        }
        
        @Test("Angle Axis Initializer") func angleAxisInitializer() {
            let rotation = Rotation3D(angle: .init(radians: .pi / 2), axis: .z)
            
            let result = rotation.eulerAngles(order: .xyz)
            #expect(result.angles.x.isAlmostZero())
            #expect(result.angles.y.isAlmostZero())
            #expect(result.angles.z.isAlmostEqual(to: .pi / 2))
        }
        
        @Test("Forward Initializer") func forwardInitializer() {
            let rotation = Rotation3D(forward: .forward)
            
            let vector = Vector3D.right
            
            #expect(vector.rotated(by: rotation).isApproximatelyEqual(to: vector))
        }
    }
    
    @Suite("Operations") struct Operations {
        @Test("Aproximate Equality") func equal() throws {
            let rotation = Rotation3D(angle: .init(radians: .pi / 2), axis: .xz)
            var rotation2 = Rotation3D(angle: .init(radians: -.pi / 2), axis: .xz)
            
            try #require(!rotation.isApproximatelyEqual(to: rotation2))
            
            rotation2.invert()
            #expect(rotation.isApproximatelyEqual(to: rotation2))
        }
        
        @Test("Multiplication") func multiplication() {
            let rotation = Rotation3D(angle: .init(radians: .pi / 2), axis: .x)
            let rotation2 = Rotation3D(angle: .init(radians: .pi / 2), axis: .x)
            let combination = Rotation3D(angle: .init(radians: .pi), axis: .x)
            
            #expect(rotation.rotated(by: rotation2).isApproximatelyEqual(to: combination))
        }
        // ToDo: Add some tests for spline, slerp, twist, and swing
    }
}
