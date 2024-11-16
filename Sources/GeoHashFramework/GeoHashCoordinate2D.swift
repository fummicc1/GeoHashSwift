//
//  GeoHashCoordinate2D.swift
//  geo-hash-swift
//
//  Created by Fumiya Tanaka on 2024/11/16.
//

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
}
