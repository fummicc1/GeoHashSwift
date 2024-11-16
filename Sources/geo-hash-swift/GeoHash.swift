// The Swift Programming Language
// https://docs.swift.org/swift-book


public struct GeoHash: Sendable, Hashable {
    var binary: String {
        didSet {
            
        }
    }
    
    /// Create a GeoHash from a string.
    ///
    /// Assure that all characters in the string are "0" or "1".
    ///
    /// - Parameter value: A string that contains only "0" or "1".
    public init(binary: String) {
        precondition(binary.allSatisfy({
            ["0", "1"].contains($0)
        }))
        self.binary = binary
        // binary -> Int
        guard let binaryInt = Int(binary, radix: 2) else {
            fatalError("Failed to convert binary to decimal.")
        }
        self.hashValue = String(binaryInt, radix: 16)
        self.coordinate = GeoHashCoordinate2D(binary: binary)
    }
    
    public private(set) var hashValue: String
    
    public var coordinate: GeoHashCoordinate2D
}
