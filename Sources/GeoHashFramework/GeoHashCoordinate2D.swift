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
        // 010101010 --> 1111
        let latitudeBits = binary.enumerated().filter { $0.offset % 2 == 1 }.map { String($0.element) }
        // 010101010 --> 00000
        let longitudeBits = binary.enumerated().filter { $0.offset % 2 == 0 }.map { String($0.element) }
        
        // 1111 -> 15
        let latitudePrecision = pow(2, Double(latitudeBits.count)) - 1
        // 01000 -> 8/15
        let latitudeIndex = latitudeBits.enumerated().reduce(into: 0.0, { partialResult, value in
            let (index, bits) = value
            if bits == "1" {
                partialResult += Double(1 << (latitudeBits.count - 1 - index))
            }
        }) / latitudePrecision
        self.latitude = 180 * latitudeIndex - 90.0

        // 00000 -> 31
        let longitudePrecision = pow(2, Double(longitudeBits.count)) - 1
        // 01000 -> 8/31
        let longitudeIndex = Double(
            longitudeBits.enumerated().reduce(into: 0.0, { partialResult, value in
                let (index, bits) = value
                if bits == "1" {
                    partialResult += Double(1 << (longitudeBits.count - 1 - index))
                }
            })
        ) / longitudePrecision
        
        self.longitude = 360 * longitudeIndex - 180.0
    }
}
