/// A GeoHashPrecision  enum represents the precision of the GeoHash in binary unit.
///
/// - low: 24 digits precision. This corresponds to 6 characters of GeoHash.
/// - mid: 32 digits precision. This corresponds to 8 characters of GeoHash.
/// - high: 40 digits precision. This corresponds to 10 characters of GeoHash.
public enum GeoHashPrecision: Sendable, Hashable {
    /// Accuracy is around XXX m
    case low
    /// Accuracy is around YYY m
    case mid
    /// Accuracy is around ZZZ m
    case high

    case exact(digits: Int)

    public var rawValue: Int {
        switch self {
        case .low: return 6 * 4
        case .mid: return 8 * 4
        case .high: return 10 * 4
        case .exact(let digits): return digits
        }
    }
}
