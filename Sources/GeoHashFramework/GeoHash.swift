// The Swift Programming Language
// https://docs.swift.org/swift-book

public struct GeoHash: Sendable, Hashable {
    var binary: String {
        didSet {
            self.coordinate = GeoHashCoordinate2D(binary: binary)
        }
    }
    
    var decimal: Int {
        // binary -> decimal
        Int(binary, radix: 2)!
    }

    /// Create a GeoHash from a string.
    ///
    /// Assure that all characters in the string are "0" or "1".
    ///
    /// - Parameter value: A string that contains only "0" or "1".
    public init(binary: String) {
        precondition(
            binary.allSatisfy({
                ["0", "1"].contains($0)
            }))
        self.binary = binary
        self.coordinate = GeoHashCoordinate2D(binary: binary)
    }

    public var coordinate: GeoHashCoordinate2D
    
    public var hex: String {
        String(decimal, radix: 16)
    }
}
