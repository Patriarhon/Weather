//
//  DatabaseManager.swift
//  Weather
//
//  Created by Petr on 22/01/2019.
//  Copyright © 2019 Petr. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseManager {
    
    enum PredicateType : String {
        case id = "id = %d"
        case all
    }
    
    static let realm = try! Realm()
    
    // MARK: - Setup
    
    static func setupRealm() {
        if realm.objects(CityEntity.self).count == 0 {
            try! realm.write {
                for city in Constants.defaultCities {
                    let cityEntity = CityEntity()
                    cityEntity.name = city.key
                    cityEntity.id = city.value
                    realm.add(cityEntity)
                }
            }
        }
    }
    
    // MARK: - Readers
    
    /// - parameter cityId: Use with PredicateType.id
    static func getModelFromRealm(by filter: PredicateType, cityId: Int? = nil) -> [Model] {
        var predicate: NSPredicate?
        switch filter {
        case .id:
            if let id = cityId {
                predicate = NSPredicate(format: PredicateType.id.rawValue, id)
            }
        case .all:
            break
        }

        let objects = predicate != nil ? realm.objects(CityEntity.self).filter(predicate!) : realm.objects(CityEntity.self)
        var cityModels = [Model]()
        for object in objects {
            cityModels.append(Model(from:object))
        }
        return cityModels
    }
    
    static func getForecastsFromRealm(cityId: Int) -> [ForecastModel]? {
        let predicate = NSPredicate(format: PredicateType.id.rawValue, cityId)
        if let forecasts = realm.objects(CityEntity.self).filter(predicate).first?.forecastWeather {
            var forecastModels = [ForecastModel]()
            for forecast in forecasts {
                let forecastModel = ForecastModel(from: forecast)
                forecastModels.append(forecastModel)
            }
            return forecastModels
        }
        return nil
    }
    
    // MARK: - Writers
    
    static func writeForecasts(forecasts: [ForecastModel], cityId: Int) {
        guard let city = realm.objects(CityEntity.self).filter(NSPredicate(format: PredicateType.id.rawValue, cityId)).first else { return }
        
        let weathers = List<WeatherEntity>()
        
        for forecast in forecasts {
            weathers.append(WeatherEntity(from: forecast))
        }
        
        try! realm.write {
            city.forecastWeather.removeAll()
            for weather in weathers {
                city.forecastWeather.append(weather)
            }
        }
    }
    
    static func writeCities(citys: [Model]) {
        for model in citys {
            let cityEntity = CityEntity(from: model)
            DatabaseManager.write(cityEntities: [cityEntity])
        }
    }
    
    // MARK: Private 
    
    static private func write(cityEntities: [CityEntity]) {
        for city in cityEntities {
            try! realm.write {
                if let object = realm.objects(CityEntity.self).filter(PredicateType.id.rawValue, city.id).first {
                    self.realm.delete(object)
                    self.realm.add(city)
                } else {
                    self.realm.add(city)
                }
            }
        }
    }
}
