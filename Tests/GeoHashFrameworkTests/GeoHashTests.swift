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
        let input = "01101010011010100110"
        let geoHash = GeoHash(
            binary: input,
            precision: .exact(digits: 20)
        )
        #expect(geoHash.geoHash == "e9p6")
        #expect(geoHash.geoHash.count == input.count / 5)
    }

    @Test
    func makeFromBinary() async throws {
        let input = "01101010011010100110"

        let expectedLat = "1000100010"
        let expectedLng = "0111011101"

        let geoHash = GeoHash(
            binary: input,
            precision: .exact(
                digits: 20
            )
        )
        #expect(geoHash.latitudeBits == expectedLat)
        #expect(geoHash.longitudeBits == expectedLng)
    }

    @Test
    func makeFromLatLng() async throws {
        // Tokyo Station
        let lat = 35.681382
        let lng = 139.766084

        let geoHash = GeoHash(latitude: lat, longitude: lng)
        #expect(
            geoHash.binary == "1110110100001110011011010101111110001101"
        )
        #expect(
            geoHash.geoHash == "xn76urwe"
        )
    }
    
    @Test
    func getBound() async throws {
        let actual = GeoHash.getBound(with: .exact(digits: 0))
        let expected = [
            GeoHashCoordinate2D(
                latitude: 90.0,
                longitude: -180.0
            ),
            GeoHashCoordinate2D(
                latitude: 90.0,
                longitude: 180.0
            ),
            GeoHashCoordinate2D(
                latitude: -90.0,
                longitude: 180.0
            ),
            GeoHashCoordinate2D(
                latitude: -90.0,
                longitude: -180.0
            )
        ]
        #expect(actual == expected)
    }
}
