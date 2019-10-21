//
//  CityEntity.swift
//  Weather
//
//  Created by Petr on 19/01/2019.
//  Copyright © 2019 Petr. All rights reserved.
//

import Foundation
import RealmSwift

class CityEntity: Object {
    @objc dynamic var name = String()
    @objc dynamic var id = Int()
    
    @objc dynamic var currentWeather: WeatherEntity?
    let forecastWeather = List<WeatherEntity>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init(from model: Model) {
        self.init()
        name = model.name
        id = model.id
        currentWeather = WeatherEntity(from: model)
    }
}

class WeatherEntity: Object {
    var dt = RealmOptional<Double>()
    var temp = RealmOptional<Float>()
    var pressure = RealmOptional<Float>()
    var humidity = RealmOptional<Int>()
    var speed = RealmOptional<Float>()
    @objc dynamic var descript: String? = nil
    
    required convenience init(from model: Model) {
        self.init()
        dt.value = model.dt
        temp.value = model.main?.temp
        pressure.value = model.main?.pressure
        humidity.value = model.main?.humidity
        speed.value = model.wind?.speed
        descript = model.weather?.first?.description
    }
    
    required convenience init(from model: ForecastModel) {
        self.init()
        dt.value = model.dt
        temp.value = model.main?.temp
        pressure.value = model.main?.pressure
        humidity.value = model.main?.humidity
        speed.value = model.wind?.speed
        descript = model.weather?.first?.description
    }
}
