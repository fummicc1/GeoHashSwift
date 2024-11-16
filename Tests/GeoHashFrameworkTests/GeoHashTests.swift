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
        let geoHash = GeoHash(
            binary: input,
            precision: .exact(digits: 16)
        )
        #expect(geoHash.geoHash == "e9p0")
        #expect(geoHash.geoHash.count == input.count / 4)
    }

    @Test
    func makeFromBinary() async throws {
        let input = "0110101001101010"

        let expectedLat = "10001000"
        let expectedLng = "01110111"

        let geoHash = GeoHash(
            binary: input,
            precision: .exact(
                digits: 16
            )
        )
        #expect(geoHash.latitudeBits == expectedLat)
        #expect(geoHash.longitudeBits == expectedLng)
    }

    @Test
    func makeFromLatLng() async throws {
        let lat = 35.681382
        let lng = 139.766084

        let geoHash = GeoHash(latitude: lat, longitude: lng)
        #expect(
            geoHash.binary == "11101101000011100110110101011111"
        )
        #expect(
            geoHash.geoHash == "xn76urs"
        )
    }
}
