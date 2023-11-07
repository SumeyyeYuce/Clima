//
//  WeatherData.swift
//  Clima
//
//  Created by Sümeyye on 9.06.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

//Decodable ->> Bu protokolü kabul eden class veya struct’lar JSON türünden bir datayı kullanarak kendi türlerinden objeler oluşturabilirler.

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct Weather: Codable {
    let description:String
    let id : Int
}
