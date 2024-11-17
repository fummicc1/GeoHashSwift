//
//  GeoHashCLI.swift
//  GeoHashCLI
//
//  Created by Fumiya Tanaka on 2024/11/17.
//

import ArgumentParser
import GeoHashFramework

@main
struct GeoHashCLI: ParsableCommand {
    
    @Option(name: .shortAndLong, help: "length of GeoHash")
    var length: Int = 8
    
    @Argument(help: "latitude of coordinate")
    var latitude: Double?
    
    @Argument(help: "longitude of coordinate")
    var longitude: Double?
    
    @Option(help: "concatenated coordinate formatted as latitude,longitude")
    var coordinate: String?
    
    mutating func run() throws {
        precondition(
            (latitude != nil && longitude != nil) || coordinate != nil
        )
        let precision = GeoHashBitsPrecision.exact(digits: length * 5)
        
        let geoHash: GeoHash
        
        if let coordinate {
            let components = coordinate.split(separator: ",")
            guard components.count == 2 else {
                throw ValidationError("Coordinate must be formatted as latitude,longitude")
            }
            latitude = Double(components[0])
            longitude = Double(components[1])
            
            geoHash = .init(
                latitude: latitude!,
                longitude: longitude!,
                precision: precision
            )
        } else if let latitude, let longitude {
            geoHash = .init(
                latitude: latitude,
                longitude: longitude,
                precision: precision
            )
        } else {
            throw ValidationError("Coordinate or latitude and longitude must be provided.")
        }
        print(geoHash.geoHash)
    }
}