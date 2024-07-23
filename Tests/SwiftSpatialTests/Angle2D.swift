import Testing
import Foundation
@testable import SwiftSpatial

@Suite("Angle2D") struct Angle2DTests {
    @Suite("Initializers") struct Initializers {
        @Test("Default Initializer") func defaultInitializer() {
            let angle = Angle2D()
            
            #expect(angle.radians == 0)
            #expect(angle.degrees.isAlmostZero())
        }
        
        @Test("Degrees Initializer") func degreesInitializer() {
            let angle = Angle2D(radians: .pi)
            
            #expect(angle.radians.isAlmostEqual(to: .pi))
            #expect(angle.degrees.isAlmostEqual(to: 180))
        }
        
        @Test("Radians Initializer") func radiansInitializer() {
            let angle = Angle2D(degrees: 180)
            
            #expect(angle.radians.isAlmostEqual(to: .pi))
            #expect(angle.degrees.isAlmostEqual(to: 180))
        }
    }
    
    @Suite("Operations") struct Operations {
        @Test("Addition") func add() throws {
            var angle = Angle2D(degrees: 0)
            
            angle += .degrees(180)
            try #require(angle.degrees.isAlmostEqual(to: 180))
            
            let zero = angle - .degrees(180)
            try #require(zero.degrees.isAlmostZero())
            
            let full = angle + .degrees(180)
            try #require(full.degrees.isAlmostEqual(to: 360))
            
            let negative = -angle
            try #require(negative.degrees.isAlmostEqual(to: -180))
            try #require((+negative).degrees.isAlmostEqual(to: -180))
            
            angle -= .degrees(360)
            #expect(angle.degrees.isAlmostEqual(to: -180))
        }
        
        @Test("Normalize") func normalize() {
            let angle = Angle2D(radians: -3 * .pi)
            
            let normalizedAngle = angle.normalized
            
            #expect(normalizedAngle.radians.isAlmostEqual(to: .pi))
            #expect(normalizedAngle.degrees.isAlmostEqual(to: 180))
        }
        
        @Test("Cosine") func cos() throws {
            let angle = Angle2D(degrees: 60)
            
            let cos = angle.cos
            try #require(cos.isAlmostEqual(to: 0.5))

            #expect(Angle2D.acos(cos).degrees.isAlmostEqual(to: 60))
        }
        
        @Test("Sine") func sin() throws {
            let angle = Angle2D(degrees: 90)
            
            let sin = angle.sin
            try #require(sin.isAlmostEqual(to: 1))
            
            #expect(Angle2D.asin(sin).degrees.isAlmostEqual(to: 90))
        }
        
        @Test("Tangent") func tan() throws {
            let angle = Angle2D(degrees: 45)
            
            let tan = angle.tan
            try #require(tan.isAlmostEqual(to: 1))
            
            #expect(Angle2D.atan(tan).degrees.isAlmostEqual(to: 45))
        }
        
        @Test("Hyperbolic Cosine") func cosh() throws {
            let angle = Angle2D(degrees: 0)
            
            let cosh = angle.cosh
            try #require(cosh.isAlmostEqual(to: 1))

            #expect(Angle2D.acosh(cosh).degrees.isAlmostZero())
        }
        
        @Test("Hyperbolic Sine") func sinh() throws {
            let angle = Angle2D(degrees: 0)
            
            let sinh = angle.sinh
            try #require(sinh.isAlmostZero())
            
            #expect(Angle2D.asinh(sinh).degrees.isAlmostZero())
        }
        
        @Test("Hyperbolic Tangent") func tanh() throws {
            let angle = Angle2D(degrees: 0)
            
            let tanh = angle.tanh
            try #require(tanh.isAlmostZero())
            
            #expect(Angle2D.atanh(tanh).degrees.isAlmostZero())
        }
    }
    
    @Test("Full") func full() throws {
        // 30 60 90 right triange
        let theta = Angle2D(degrees: 30)
        let c = 2.0
        
        let x = theta.cos * c
        let y = theta.sin * c
        
        #expect(x.isAlmostEqual(to: sqrt(3)))
        #expect(y.isAlmostEqual(to: 1))
    }
}
