//
//  GeoHashCluster.swift
//  geo-hash-swift
//
//  Created by Fumiya Tanaka on 2024/11/16.
//

/// An union-find data structure for GeoHash.
///
/// This data structure is used to store GeoHashes and their relations.
public struct GeoHashCluster: Sendable, Hashable {
    private var clusters: [GeoHashBitsPrecision: [GeoHash]] = [:]

    public init() {
        clusters = [:]
    }

    public func isSame(geoHash1: GeoHash, geoHash2: GeoHash, precision: GeoHashBitsPrecision) -> Bool {
        fatalError("Not implemented")
    }

    public func mergeIfPossible(geoHash1: GeoHash, geoHash2: GeoHash, precision: GeoHashBitsPrecision) {
        fatalError("Not implemented")
    }
}
