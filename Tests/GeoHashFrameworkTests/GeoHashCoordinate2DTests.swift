import Testing
@testable import GeoHashFramework

struct GeoHashCoordinate2DTests {
    @Test
    func makeFromBinary() async throws {
        let input = "0110101001101010"
        
        let expectedLat = "10001000"
        let expectedLng = "01110111"
        
        let geoHash = GeoHashCoordinate2D(binary: input)
        #expect(geoHash.latitudeBinary == expectedLat)
        #expect(geoHash.longitudeBinary == expectedLng)
    }
}
