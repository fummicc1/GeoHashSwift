/// A GeoHashPrecision enum represents the bits precision of the GeoHash in binary unit.
///
/// - low: 30 bits precision. This corresponds to 6 characters of GeoHash.
/// - mid: 40 bits precision. This corresponds to 8 characters of GeoHash.
/// - high: 50 bits precision. This corresponds to 10 characters of GeoHash.
public enum GeoHashBitsPrecision: Sendable, Hashable {
    /// 6 digits GeoHash
    case low
    /// 8 digits GeoHash
    case mid
    /// 10 digits GeoHash
    case high

    /// `digits` **bits** precision.
    /// - Note: `digits` must be a multiple of 4 because each GeoHash character is 5 bits.
    case exact(digits: Int)

    public var rawValue: Int {
        switch self {
        case .low: return 6 * 5
        case .mid: return 8 * 5
        case .high: return 10 * 5
        case .exact(let digits):
            precondition(digits % 5 == 0)
            return digits
        }
    }

    var format: String {
        let rawValue = self.rawValue
        return "%0\(rawValue / 5)d"
    }
}
