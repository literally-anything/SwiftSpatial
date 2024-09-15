import Testing
@testable import SwiftSpatial

@Suite("Size3D") struct Size3DTests {
    @Suite("Initializers") struct Initializers {
        @Test("Default Initializer") func defaultInitializer() {
            let size = Size3D()
            
            #expect(size.isZero)
            #expect(size.isFinite)
            #expect(!size.isNaN)
        }
        
        @Test("Double Initializer") func doubleInitializer() {
            let size = Size3D(width: 1, height: 0, depth: 1)
            
            #expect(!size.isZero)
            #expect(size.isFinite)
            #expect(!size.isNaN)
        }
        
        @Test("Infinite") func zero() {
            let size: Size3D = .infinity
            
            #expect(!size.isZero)
            #expect(!size.isFinite)
            #expect(!size.isNaN)
        }
    }
    
    @Suite("Operations") struct Operations {
        @Test("Aproximate Equality") func equal() throws {
            let vector = Size3D(width: -1)
            var vector2 = Size3D(width: 1)
            
            try #require(!vector.isApproximatelyEqual(to: vector2))
            
            vector2.width.negate()
            #expect(vector.isApproximatelyEqual(to: vector2))
        }
        
        @Test("Addition") func add() throws {
            let size = Size3D(width: 1)
            let size2 = Size3D(depth: 1)
            
            var sum = size + size2
            
            try #require(sum.width.isAlmostEqual(to: 1)
                         && sum.height.isAlmostEqual(to: 0)
                         && sum.depth.isAlmostEqual(to: 1))
            
            let vector = Vector3D(x: -2, y: 1)
            sum += vector
            
            #expect(sum.width.isAlmostEqual(to: -1)
                    && sum.height.isAlmostEqual(to: 1)
                    && sum.depth.isAlmostEqual(to: 1))
        }
        
        @Test("Negate") func negate() {
            let size = Size3D(width: 1)
            
            #expect((-size).width.isAlmostEqual(to: -1))
            #expect((+size).width.isAlmostEqual(to: 1))
        }
        
        @Test("Subtraction") func subtraction() throws {
            let size = Size3D(width: 1)
            let size2 = Size3D(depth: 1)
            
            var difference = size - size2
            
            try #require(difference.width.isAlmostEqual(to: 1)
                         && difference.height.isAlmostEqual(to: 0)
                         && difference.depth.isAlmostEqual(to: -1))
            
            let vector = Vector3D(x: -2, y: 1)
            difference -= vector
            
            #expect(difference.width.isAlmostEqual(to: 3)
                    && difference.height.isAlmostEqual(to: -1)
                    && difference.depth.isAlmostEqual(to: -1))
        }
        
        @Test("Multiplication") func multiplication() {
            let size = Size3D(width: 1, depth: 2)
            
            let product = Size3D(width: 2.5, depth: 5)
            let quotient = Size3D(width: 0.5, depth: 1)
            
            #expect((size * 2.5).isApproximatelyEqual(to: product))
            #expect((2.5 * size).isApproximatelyEqual(to: product))
            
            #expect((size / 2).isApproximatelyEqual(to: quotient))
        }
        
        @Test("Rotation") func rotation() {
            let size = Size3D(width: 1, height: 2)
            
            let rotated = size.rotated(by: .init(
                eulerAngles: .init(x: 0,
                                   y: 0,
                                   z: .init(radians: .pi / 2),
                                   order: .xyz)
            ))
            
            #expect(rotated.isApproximatelyEqual(to: .init(width: -2, height: 1)))
        }
        
        @Test("Applying Poses") func pose() {
            let size = Size3D(width: 1, height: 2)
            
            let pose = Pose3D(
                position: .zero,
                rotation: .init(
                    eulerAngles: .init(x: 0,
                                       y: 0,
                                       z: .init(radians: .pi),
                                       order: .xyz)
                              )
            )
            
            let applied = size.applying(pose)
            
            #expect(applied.isApproximatelyEqual(to: .init(width: -1, height: -2)))
        }
        
        @Test("Applying Scaled Poses") func scaledPose() {
            let size = Size3D(width: 1, height: 2)
            
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
            
            let applied = size.applying(scaledPose)
            
            #expect(applied.isApproximatelyEqual(to: .init(width: -2, height: -4)))
        }
        
        @Suite("Volume") struct Volume {
            struct ContainedPoint: CustomStringConvertible, CustomDebugStringConvertible {
                var point: Point3D
                var contained: Bool
                
                init(_ point: Point3D, _ contained: Bool) {
                    self.point = point
                    self.contained = contained
                }
                
                var description: String { "(point: \(point), contained: \(contained))" }
                var debugDescription: String { description }
            }
            
            @Test("Contains Points", .disabled("Bug in swift-testing"), arguments: [
                ContainedPoint(.init(x: 1, y: 2.5, z: 3), true),
                ContainedPoint(.init(x: 1, y: 3.99, z: 5), true),
                ContainedPoint(.init(x: 2.5, y: 1, z: 1.5), true),
                ContainedPoint(.init(x: 2, y: 3.5, z: 4), true),
                ContainedPoint(.init(x: 2, y: 3, z: 5), true),
                
                ContainedPoint(.init(x: -1, y: 2.5, z: 3), false),
                ContainedPoint(.init(x: 1, y: 4.1, z: 5), false),
                ContainedPoint(.init(x: 2.5, y: 1, z: 7), false),
                ContainedPoint(.init(x: 2, y: 3.5, z: -9), false),
                ContainedPoint(.init(x: 3.1, y: 4.1, z: 5.1), false)
            ])
            func containsPoints(
                point: ContainedPoint
            ) {
                let size = Size3D(width: 3, height: 4, depth: 6)
                
                #expect(size.contains(point: point.point) == point.contained)
            }
            
            @Test("Contains Any") func containsAny() {
                let containedPoints = [
                    Point3D(x: 1, y: 2.5, z: 3),
                    Point3D(x: 1, y: 3.99, z: 5),
                    Point3D(x: 2.5, y: 1, z: 1.5),
                    Point3D(x: 2, y: 3.5, z: 4),
                    Point3D(x: 2, y: 3, z: 5)
                ]
                let notContainedPoints = [
                    Point3D(x: -1, y: 2.5, z: 3),
                    Point3D(x: 1, y: 4.1, z: 5),
                    Point3D(x: 2.5, y: 1, z: 7),
                    Point3D(x: 2, y: 3.5, z: -9),
                    Point3D(x: 3.1, y: 4.1, z: 5.1)
                ]
                let size = Size3D(width: 3, height: 4, depth: 6)
                
                #expect(size.contains(anyOf: containedPoints))
                #expect(!size.contains(anyOf: notContainedPoints))
                #expect(size.contains(anyOf: (containedPoints + notContainedPoints).shuffled()))
            }
            
            @Test("Intersection") func intersection() {
                let size = Size3D(width: 3, height: 4, depth: 6)
                let size2 = Size3D(width: 5, height: 7, depth: 1)
                
                #expect(size.intersection(size2)!.isApproximatelyEqual(to: .init(width: 3, height: 4, depth: 1)))
            }
            
            @Test("Union") func union() {
                let size = Size3D(width: 3, height: 4, depth: 6)
                let size2 = Size3D(width: 5, height: 7, depth: 1)
                
                #expect(size.union(size2).isApproximatelyEqual(to: .init(width: 5, height: 7, depth: 6)))
            }
        }
    }
}
