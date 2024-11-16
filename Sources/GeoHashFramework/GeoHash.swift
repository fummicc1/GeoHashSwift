// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct GeoHash: Sendable, Hashable {
    public private(set) var precision: GeoHashPrecision
    public private(set) var binary: String

    /// Base32 characters used to hash
    ///
    // a and o are omitted
    private static let base32Chars = "0123456789bcdefghjkmnpqrstuvwxyz"

    /// Create a GeoHash from a string.
    ///
    /// Assure that all characters in the string are "0" or "1".
    ///
    /// - Parameter value: A string that contains only "0" or "1".
    public init(
        binary: String,
        precision: GeoHashPrecision = .mid
    ) {
        precondition(
            binary.allSatisfy({
                ["0", "1"].contains($0)
            })
        )
        if binary.count != precision.rawValue {
            precondition(
                binary.count == precision.rawValue,
                "Binary length must be \(precision.rawValue), but binary length is \(binary.count)"
            )
        }
        self.binary = binary
        self.precision = precision
    }

    public init(
        latitude: Double,
        longitude: Double,
        precision: GeoHashPrecision = .mid
    ) {
        precondition(
            latitude >= -90 && latitude <= 90,
            "Latitude must be between -90 and 90"
        )
        precondition(
            longitude >= -180 && longitude <= 180,
            "Longitude must be between -180 and 180"
        )

        self.init(
            binary: Self.makeBinary(
                from: .init(
                    latitude: latitude,
                    longitude: longitude
                ),
                precision: precision
            ),
            precision: precision
        )
    }

    public init(geoHash: String, precision: GeoHashPrecision = .mid) {
        self.init(
            binary: Self.makeBinary(
                from: geoHash,
                precision: precision
            ),
            precision: precision
        )
    }
}

// MARK: Internal
extension GeoHash {
    static func makeBinary(
        from geoHash: String,
        precision: GeoHashPrecision
    ) -> String {
        var binary = ""

        for char in geoHash {
            guard let index = Self.base32Chars.firstIndex(of: char) else {
                preconditionFailure(
                    "Invalid geohash character \(char) in geoHash: \(geoHash)"
                )
            }

            let value = Self.base32Chars.distance(
                from: Self.base32Chars.startIndex,
                to: index
            )
            let bits = String(format: precision.format, value)
            binary += bits
        }
        return binary
    }

    static func makeBinary(from coordinate: GeoHashCoordinate2D, precision: GeoHashPrecision)
        -> String
    {
        let latitude = coordinate.latitude
        let longitude = coordinate.longitude

        var maxLatitude = 90.0
        var minLatitude = -90.0
        var maxLongitude = 180.0
        var minLongitude = -180.0

        var latitudeBits: [Int] = []
        var longitudeBits: [Int] = []

        for bits in 0..<precision.rawValue {
            if bits % 2 == 0 {
                // longitude
                let mid = (minLongitude + maxLongitude) / 2

                if longitude >= mid {
                    longitudeBits.append(1)
                    minLongitude = mid
                } else {
                    longitudeBits.append(0)
                    maxLongitude = mid
                }

            } else {
                // latitude
                let mid = (minLatitude + maxLatitude) / 2

                if latitude >= mid {
                    latitudeBits.append(1)
                    minLatitude = mid
                } else {
                    latitudeBits.append(0)
                    maxLatitude = mid
                }
            }
        }
        var binary = ""
        for (lat, lng) in zip(latitudeBits, longitudeBits) {
            binary += "\(lng)\(lat)"
        }
        if longitudeBits.count > latitudeBits.count {
            binary += "\(longitudeBits.last!)"
        }
        return binary
    }
}

// MARK: Public getter
extension GeoHash {
    public var latitudeBits: String {
        var lat: String = ""

        for (i, bin) in binary.enumerated() {
            if i % 2 == 1 {
                lat.append(bin)
            }
        }
        return lat
    }
    public var longitudeBits: String {
        var lng: String = ""

        for (i, bin) in binary.enumerated() {
            if i % 2 == 0 {
                lng.append(bin)
            }
        }
        return lng
    }

    public var geoHash: String {
        var hash: String = ""

        var currentBits: Int = 0
        var bitsCount = 0

        for bin in binary {
            currentBits = (currentBits << 1) | (bin == "1" ? 1 : 0)
            bitsCount += 1

            if bitsCount == 5 {
                let index = Self.base32Chars.index(
                    Self.base32Chars.startIndex,
                    offsetBy: currentBits
                )
                hash += String(Self.base32Chars[index])
                currentBits = 0
                bitsCount = 0
            }
        }
        if bitsCount > 0 {
            // Padding
            currentBits <<= 5 - bitsCount
            let index = Self.base32Chars.index(
                Self.base32Chars.startIndex,
                offsetBy: currentBits
            )
            hash += String(Self.base32Chars[index])
        }
        return hash
    }
}
