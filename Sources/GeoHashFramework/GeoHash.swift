// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct GeoHash: Sendable, Hashable {
    public private(set) var precision: GeoHashPrecision
    public private(set) var coordinate: GeoHashCoordinate2D
    public private(set) var binary: String {
        didSet {
            self.coordinate = GeoHashCoordinate2D(binary: binary)
        }
    }
    
    var decimal: Int {
        // binary -> decimal
        Int(binary, radix: 2)!
    }
    
    /// Base32 characters used to hash
    ///
    // a and o are omitted
    private static let base32Chars = "0123456789bcdefghjkmnpqrstuvwxyz"

    /// Create a GeoHash from a string.
    ///
    /// Assure that all characters in the string are "0" or "1".
    ///
    /// - Parameter value: A string that contains only "0" or "1".
    public init(binary: String, precision: GeoHashPrecision = .mid) {
        precondition(
            binary.allSatisfy({
                ["0", "1"].contains($0)
            }))
        self.binary = binary
        self.precision = precision
        self.coordinate = GeoHashCoordinate2D(binary: binary)
    }
}

extension GeoHash {
    public var geoHash: String {
        for _ in 0..<binary.count {
        }
        fatalError("Not implemented")
    }
}
