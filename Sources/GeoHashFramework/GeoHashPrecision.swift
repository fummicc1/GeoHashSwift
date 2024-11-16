/// A GeoHashPrecision  enum represents the precision of the GeoHash in binary unit.
///
/// - low: 24 digits precision. This corresponds to 6 characters of GeoHash.
/// - mid: 32 digits precision. This corresponds to 8 characters of GeoHash.
/// - high: 40 digits precision. This corresponds to 10 characters of GeoHash.
public enum GeoHashPrecision: Sendable, Hashable {
    /// 6 digits GeoHash
    case low
    /// 8 digits GeoHash
    case mid
    /// 10 digits GeoHash
    case high

    /// `digits` **bits** precision.
    /// - Note: `digits` must be a multiple of 4 because each GeoHash character is 4 bits.
    case exact(digits: Int)

    public var rawValue: Int {
        switch self {
        case .low: return 6 * 4
        case .mid: return 8 * 4
        case .high: return 10 * 4
        case .exact(let digits):
            precondition(digits % 4 == 0)
            return digits
        }
    }

    var format: String {
        let rawValue = self.rawValue
        return "%0\(rawValue / 4)d"
    }
}
