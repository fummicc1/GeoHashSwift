//
//  GeoHashTests.swift
//  geo-hash-swift
//
//  Created by Fumiya Tanaka on 2024/11/16.
//

import Testing
@testable import GeoHashFramework

struct GeoHashTests {
    @Test
    func makeGeoHashFromBinary() async throws {
        let input = "0110101001101010"
        let geoHash = GeoHash(binary: input)
        #expect(geoHash.geoHash == "6a6a")
        #expect(geoHash.geoHash.count == input.count / 4)
    }
}
