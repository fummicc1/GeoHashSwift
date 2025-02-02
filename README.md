# GeoHashSwift

GeoHashSwift is a Swift implementation of GeoHash.

[GeoHashCLI](https://github.com/user-attachments/assets/4d19753f-dc6e-4d26-bdce-14b9963f2dde)



## Installation & Usage

### GeoHashFramework

GeoHashFramework is a framework that ships things to calculate GeoHash from coordinates.

You can use it as a dependency of your project.

```swift
dependencies: [
    .package(url: "https://github.com/fummicc1/GeoHashSwift.git", from: "0.0.4")
]
```

```swift
import GeoHashFramework

let geoHash = GeoHash(latitude: 35.681382, longitude: 139.766084, precision: .mid)
print(geoHash.geoHash) // "xn76urwe"
```

### GeoHashCLI

GeoHashCLI executable is a CLI tool which depends on GeoHashFramework.

You can use this executable to generate GeoHash from coordinates.

- Install via Homebrew

```sh
brew tap fummicc1/geohash
brew install fummicc1/geohash/geohash
```

Usage:

```sh
# Generate GeoHash from latitude and longitude
geohash 35.681236 139.767125
> xn76urx6
# Generate GeoHash from coordinate2d
geohash --coordinate "35.681236,139.767125"
> xn76urx6
```

- Install via Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/fummicc1/GeoHashSwift.git", from: "0.0.4")
]
```

Usage:

```sh
# Generate GeoHash from latitude and longitude
swift run geohash 35.681236 139.767125
> xn76urx6
# Generate GeoHash from coordinate2d
swift run geohash --coordinate "35.681236,139.767125"
> xn76urx6
```

## APIs

### Models

#### GeoHash

A GeoHash is a GeoHash object.

You can obtain both binary and hex values of coordinate from GeoHash object.

More implementation related to Coordinate2D (latitude, longitude) is in GeoHashCoordinate2D.swift.

Beside the calculation of GeoHash, this object also provides the followings:

- a method to get bounds of the GeoHash.
- a method to get neighbors of the GeoHash with bits precision same.


#### GeoHashCoordinate2D

A GeoHashCoordinate2D represents a pair of latitude and longitude in binary.

**Note that actual latitude and longitude are not stored in this object, because the accuracy of GeoHash is not guaranteed.**

### Features

- User can generate GeoHash from:
  - latitude and longitude
  - binary string
  - GeoHash string
- User can retrieve hash string from `GeoHash` object.
- User can obtain bounds of GeoHash.
- User can obtain neighbors of GeoHash.

## Related Repositories

- [GeoHashDebugView: An example app using GeoHashSwift](https://github.com/fummicc1/GeoHashDebugView)
