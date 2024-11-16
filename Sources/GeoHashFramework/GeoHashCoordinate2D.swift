//
//  GeoHashCoordinate2D.swift
//  geo-hash-swift
//
//  Created by Fumiya Tanaka on 2024/11/16.
//

/// A GeoHashCoordinate2D represents a pair of latitude and longitude in binary.
///
/// This `latitudeBinary` and `longitudeBinary` are binary strings and not corresponds to the actual latitude and longitude.
///
/// This means accuracy of these binary strings are not guaranteed but better than one stored as hex string.
public struct GeoHashCoordinate2D: Sendable, Hashable {
    public init(binary: String) {
        var lat: String = ""
        var lng: String = ""
        
        for (i, bin) in binary.enumerated() {
            if i % 2 == 0 {
                lng.append(bin)
            } else {
                lat.append(bin)
            }
        }
        latitudeBinary = lat
        longitudeBinary = lng
    }
    
    public var latitudeBinary: String
    public var longitudeBinary: String
}
