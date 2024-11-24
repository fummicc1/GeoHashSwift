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
        // Tokyo Station
        let coordinate = GeoHashCoordinate2D(
            latitude: 35.681382,
            longitude: 139.766084
        )
        let precision = GeoHashBitsPrecision.low
        let geoHash = GeoHash(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            precision: precision
        )
        let actual = geoHash.getBound()
        let expected = [
            GeoHashCoordinate2D(
                latitude: 35.68634033203124,
                longitude: 139.76257324218756
            ),
            GeoHashCoordinate2D(
                latitude: 35.68634033203124,
                longitude: 139.77355957031256
            ),
            GeoHashCoordinate2D(
                latitude: 35.68084716796874,
                longitude: 139.77355957031256
            ),
            GeoHashCoordinate2D(
                latitude: 35.68084716796874,
                longitude: 139.76257324218756
            ),
        ]
        #expect(actual == expected)
    }

    @Test
    func getBounds() async throws {
        let actual = GeoHash.getBounds(with: .exact(digits: 15))
        let count = actual.reduce(0) { partialResult, bound in
            partialResult + bound.count
        }
        print(count == 131072)  // 2^15 * 4
    }

    @Test
    func getNeighbors() async throws {
        // Tokyo Station
        let lat = 35.681382
        let lng = 139.766084

        let expected = [
            "xn76urws",
            "xn76urwu",
            "xn76urwg",
            "xn76urwf",
            "xn76urwd",
            "xn76urw6",
            "xn76urw7",
            "xn76urwk",
        ]

        let geoHash = GeoHash(latitude: lat, longitude: lng)
        let neighbors = geoHash.getNeighbors()
        #expect(neighbors.map(\.geoHash) == expected)
    }
}
