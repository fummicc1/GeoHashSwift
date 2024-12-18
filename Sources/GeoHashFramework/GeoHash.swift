// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct GeoHash: Sendable, Hashable {
    public private(set) var precision: GeoHashBitsPrecision
    public private(set) var coordinate: GeoHashCoordinate2D
    public private(set) var binary: String

    /// Base32 characters used to hash
    ///
    // a, i, l and o are omitted
    package static let base32Chars = "0123456789bcdefghjkmnpqrstuvwxyz"

    /// Create a GeoHash from a string.
    ///
    /// Assure that all characters in the string are "0" or "1".
    ///
    /// - Parameter value: A string that contains only "0" or "1".
    public init?(
        binary: String,
        precision: GeoHashBitsPrecision = .mid
    ) {
        let isValidBinary = binary.allSatisfy({
            ["0", "1"].contains($0)
        })
        if !isValidBinary {
            RuntimeWarning.log(
                message: "Binary string must contain only '0' or '1'."
            )
            return nil
        }
        if binary.count != precision.rawValue {
            let isSameLength = binary.count == precision.rawValue
            if !isSameLength {
                RuntimeWarning.log(
                    message: "Binary length must be %d, but binary length is %d",
                    args: precision.rawValue, binary.count
                )
            }
        }
        self.binary = binary
        self.precision = precision
        self.coordinate = GeoHashCoordinate2D(
            binary: binary,
            precision: precision
        )
    }

    public init?(
        latitude: Double,
        longitude: Double,
        precision: GeoHashBitsPrecision = .mid
    ) {
        if latitude >= 90 || latitude <= -90 {
            RuntimeWarning.log(
                message: "Latitude must be between -90 and 90"
            )
            return nil
        }
        if longitude >= 180 || longitude <= -180 {
            RuntimeWarning.log(
                message: "Longitude must be between -180 and 180"
            )
            return nil
        }

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

    public init?(geoHash: String, precision: GeoHashBitsPrecision = .mid) {
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
        precision: GeoHashBitsPrecision
    ) -> String {
        var binary = ""

        for char in geoHash {
            guard let index = Self.base32Chars.firstIndex(of: char) else {
                RuntimeWarning.log(
                    message: "Invalid geohash character %s in geoHash: %s",
                    args: String(char), geoHash
                )
                continue
            }

            let value = Self.base32Chars.distance(
                from: Self.base32Chars.startIndex,
                to: index
            )
            let bits = String(value, radix: 2)
            if bits.count < 5 {
                let padding = String(repeating: "0", count: 5 - bits.count)
                binary += padding + bits
            } else {
                binary += bits
            }
        }
        return binary
    }

    static func makeBinary(from coordinate: GeoHashCoordinate2D, precision: GeoHashBitsPrecision)
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

// MARK: Public properties and methods
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

    public func getNeighbors() -> [GeoHash] {
        // Calculate the step size based on precision
        let latStep = 180.0 / pow(2.0, Double(latitudeBits.count))
        let lngStep = 360.0 / pow(2.0, Double(longitudeBits.count))

        // Decode current position
        let (minLatitude, maxLatitude, minLongitude, maxLongitude) = getBound(binary: binary)

        // Calculate center coordinates
        let centerLat = (minLatitude + maxLatitude) / 2
        let centerLng = (minLongitude + maxLongitude) / 2

        func makeNeighbor(latOffset: Double, lngOffset: Double) -> GeoHash {
            var newLat = centerLat + (latOffset * latStep)
            var newLng = centerLng + (lngOffset * lngStep)

            newLat = clamp(latitude: newLat)
            newLng = normalize(longitude: newLng)

            return GeoHash(
                latitude: newLat,
                longitude: newLng,
                precision: precision
            )!
        }

        return [
            makeNeighbor(latOffset: 1, lngOffset: 0),  // north
            makeNeighbor(latOffset: 1, lngOffset: 1),  // northeast
            makeNeighbor(latOffset: 0, lngOffset: 1),  // east
            makeNeighbor(latOffset: -1, lngOffset: 1),  // southeast
            makeNeighbor(latOffset: -1, lngOffset: 0),  // south
            makeNeighbor(latOffset: -1, lngOffset: -1),  // southwest
            makeNeighbor(latOffset: 0, lngOffset: -1),  // west
            makeNeighbor(latOffset: 1, lngOffset: -1),  // northwest
        ]
    }

    private func getBound(binary: String) -> (
        minLatitude: Double,
        maxLatitude: Double,
        minLongitude: Double,
        maxLongitude: Double
    ) {
        var maxLatitude = 90.0
        var minLatitude = -90.0
        var maxLongitude = 180.0
        var minLongitude = -180.0
        for (index, bit) in binary.enumerated() {
            if index % 2 == 0 {
                // longitude bits
                let mid = (minLongitude + maxLongitude) / 2
                if bit == "1" {
                    minLongitude = mid
                } else {
                    maxLongitude = mid
                }
            } else {
                // latitude bits
                let mid = (minLatitude + maxLatitude) / 2
                if bit == "1" {
                    minLatitude = mid
                } else {
                    maxLatitude = mid
                }
            }
        }
        return (minLatitude, maxLatitude, minLongitude, maxLongitude)
    }

    /// Add `delta` to `bits`
    private func add(bits: String, by delta: Int) -> String {
        if let decimal = Int(bits, radix: 2) {
            let moved = decimal + delta
            // 11 -> 1110
            // keep bits length
            let binary = String(moved, radix: 2)
            return binary.padding(toLength: bits.count, withPad: "0", startingAt: 0)
        }
        return bits
    }

    /// Combine `latitude` and `longitude` in bits.
    private func combineBits(latitude: String, longitude: String) -> String {
        var result = ""
        let latArray = Array(latitude)
        let lngArray = Array(longitude)
        let maxLength = max(latArray.count, lngArray.count)

        for i in 0..<maxLength {
            if i < lngArray.count {
                result.append(lngArray[i])
            }
            if i < latArray.count {
                result.append(latArray[i])
            }
        }
        return result
    }

    private func normalize(longitude: Double) -> Double {
        var normalized = longitude
        while normalized > 180.0 {
            normalized -= 360.0
        }
        while normalized < -180.0 {
            normalized += 360.0
        }
        return normalized
    }

    private func clamp(latitude: Double) -> Double {
        return min(90.0, max(-90.0, latitude))
    }

    public func getBound() -> [GeoHashCoordinate2D] {

        var (minLatitude, maxLatitude, minLongitude, maxLongitude) = getBound(binary: binary)

        maxLatitude = clamp(latitude: maxLatitude)
        minLatitude = clamp(latitude: minLatitude)
        maxLongitude = normalize(longitude: maxLongitude)
        minLongitude = normalize(longitude: minLongitude)

        let topLeft = GeoHashCoordinate2D(
            latitude: maxLatitude,
            longitude: minLongitude
        )
        let topRight = GeoHashCoordinate2D(
            latitude: maxLatitude,
            longitude: maxLongitude
        )
        let bottomRight = GeoHashCoordinate2D(
            latitude: minLatitude,
            longitude: maxLongitude
        )
        let bottomLeft = GeoHashCoordinate2D(
            latitude: minLatitude,
            longitude: minLongitude
        )

        return [topLeft, topRight, bottomRight, bottomLeft]
    }

    public static func getBounds(with precision: GeoHashBitsPrecision) -> [[GeoHashCoordinate2D]] {
        // Initial: BottomLeft in zoom-level 0
        let bound = GeoHash(
            binary: String(repeating: "0", count: precision.rawValue),
            precision: precision
        )!.getBound()

        let latitudeDelta = bound[0].latitude - bound[3].latitude
        let longitudeDelta = bound[1].longitude - bound[0].longitude

        var ret: [[GeoHashCoordinate2D]] = []
        var currentLatitude = 90.0  // Start from the top

        // Scan from top to bottom
        while currentLatitude > -90.0 {
            var currentLongitude = -180.0

            // Scan each row from left to right
            while currentLongitude < 180.0 {
                let rectangle = [
                    GeoHashCoordinate2D(latitude: currentLatitude, longitude: currentLongitude),
                    GeoHashCoordinate2D(
                        latitude: currentLatitude, longitude: currentLongitude + longitudeDelta),
                    GeoHashCoordinate2D(
                        latitude: currentLatitude - latitudeDelta,
                        longitude: currentLongitude + longitudeDelta),
                    GeoHashCoordinate2D(
                        latitude: currentLatitude - latitudeDelta, longitude: currentLongitude),
                ]
                ret.append(rectangle)

                currentLongitude += longitudeDelta
            }

            currentLatitude -= latitudeDelta
        }

        return ret
    }

}
