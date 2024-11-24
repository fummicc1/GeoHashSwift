//
//  GeoHashCoordinate2D.swift
//  geo-hash-swift
//
//  Created by Fumiya Tanaka on 2024/11/16.
//

import Foundation

/// A GeoHashCoordinate2D represents a pair of latitude and longitude.
///
/// This `latitude` and `longitude` are not always corresponds to the actual latitude and longitude because of the limited precision.
public struct GeoHashCoordinate2D: Sendable, Hashable {
    public var latitude: Double
    public var longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    public init(binary: String, precision: GeoHashBitsPrecision) {
        let latitudeBits = binary.enumerated().filter { $0.offset % 2 == 1 }.map {
            String($0.element)
        }
        let longitudeBits = binary.enumerated().filter { $0.offset % 2 == 0 }.map {
            String($0.element)
        }

        // referring to: https://github.com/nh7a/Geohash/blob/927b1f402650ab18ee0714cf099122606390646c/Sources/Geohash/Geohash.swift#L45-L54
        // latitude
        let latitudeRange = latitudeBits.enumerated().reduce((-90.0, 90.0)) { result, value in
            let (min, max) = result
            let mean = Decimal(min + max) / Decimal(2)
            let (_, bit) = value
            return bit == "1"
                ? (NSDecimalNumber(decimal: mean).doubleValue, max)
                : (min, NSDecimalNumber(decimal: mean).doubleValue)
        }
        self.latitude = (latitudeRange.0 + latitudeRange.1) / 2.0

        // longitude
        let longitudeRange = longitudeBits.enumerated().reduce((-180.0, 180.0)) { result, value in
            let (min, max) = result
            let mean = Decimal(min + max) / Decimal(2)
            let (_, bit) = value
            return bit == "1"
                ? (NSDecimalNumber(decimal: mean).doubleValue, max)
                : (min, NSDecimalNumber(decimal: mean).doubleValue)
        }
        self.longitude = (longitudeRange.0 + longitudeRange.1) / 2.0
    }
}
