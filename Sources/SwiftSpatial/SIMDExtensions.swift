public import simd

extension simd_float4x4 {
    @inlinable internal func toDouble() -> simd_double4x4 {
        .init(.init(Double(columns.0.x), Double(columns.0.y), Double(columns.0.z), Double(columns.0.w)),
              .init(Double(columns.1.x), Double(columns.1.y), Double(columns.1.z), Double(columns.1.w)),
              .init(Double(columns.2.x), Double(columns.2.y), Double(columns.2.z), Double(columns.2.w)),
              .init(Double(columns.3.x), Double(columns.3.y), Double(columns.3.z), Double(columns.3.w)))
    }
}

extension simd_double4 {
    @inlinable internal func to3() -> simd_double3 {
        .init(x, y, z)
    }
}

extension simd_quatd: Codable {
    public static let identity: simd_quatd = .init(real: 1, imag: .zero)
    
    @inlinable public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.init(vector: try values.decode(SIMD4<Double>.self, forKey: .vector))
    }
    
    @inlinable public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(vector, forKey: .vector)
    }
    
    @usableFromInline enum CodingKeys: String, CodingKey {
        case vector
    }
}
