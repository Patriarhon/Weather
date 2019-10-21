//
//  Model.swift
//  Weather
//
//  Created by Petr on 19/01/2019.
//  Copyright © 2019 Petr. All rights reserved.
//

import Foundation

struct Models: Codable {
    let list: [Model]
}

struct ForecastModels: Codable {
    let list: [ForecastModel]
    
    init(forecasts: [ForecastModel]) {
        list = forecasts
    }
}

struct ForecastModel: Codable {
    let dt: Double?
    let main: Main?
    let wind: Wind?
    let weather: [Weather]?
    
    init(model: Model) {
        self.dt = model.dt
        self.main = model.main
        self.wind = model.wind
        self.weather = model.weather
    }
    
    init(from weatherEntity: WeatherEntity) {
        dt = weatherEntity.dt.value
        main = Main(temp: weatherEntity.temp.value, pressure: weatherEntity.pressure.value, humidity: weatherEntity.humidity.value)
        wind = Wind(speed: weatherEntity.speed.value)
        weather = [Weather(description: weatherEntity.descript)]
    }
}

struct Model: Codable {
    let name: String
    let id: Int
    let dt: Double?
    let main: Main?
    let wind: Wind?
    let weather: [Weather]?
    
    init(from cityEntity: CityEntity) {
        name = cityEntity.name
        id = cityEntity.id
        dt = cityEntity.currentWeather?.dt.value
        main = Main(temp: cityEntity.currentWeather?.temp.value, pressure: cityEntity.currentWeather?.pressure.value, humidity: cityEntity.currentWeather?.humidity.value)
        wind = Wind(speed: cityEntity.currentWeather?.speed.value)
        weather = [Weather(description: cityEntity.currentWeather?.descript)]
    }
}

struct Main: Codable {
    let temp: Float?
    let pressure: Float?
    let humidity: Int?
    
    init(temp: Float?, pressure: Float?, humidity: Int?) {
        self.temp = temp
        self.pressure = pressure
        self.humidity = humidity
    }
}

struct Wind: Codable {
    let speed: Float?
    
    init(speed: Float?) {
        self.speed = speed
    }
}

struct Weather: Codable {
    let description: String?
    
    init(description: String?) {
        self.description = description
    }
}
