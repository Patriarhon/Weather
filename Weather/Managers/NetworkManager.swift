//
//  NetworkManager.swift
//  Weather
//
//  Created by Petr on 19/01/2019.
//  Copyright © 2019 Petr. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    static var parameters: Parameters = ["appid": "251b1832e1e3c804d48b4c8a1945cb4a", "units": "metric"]
    
    static func getCurrentWeather(in city: String, with success: @escaping (Model?) -> Void, and failure: @escaping (Error?) -> Void) {
        parameters["q"] = city
        
        Alamofire.request("https://api.openweathermap.org/data/2.5/weather", method: .get, parameters: parameters).responseData { response in
            if let data = response.result.value {
                let jsonDecoder = JSONDecoder()
                let model =  try? jsonDecoder.decode(Model.self, from: data)
                success(model)
            } else {
                failure(response.error)
            }
        }
    }
    
    static func getCurrentWeather(cityIDs: [Int], with success: @escaping (Models) -> Void, and failure: @escaping (Error?) -> Void) {
        var stringIDs = ""
        for id in cityIDs.enumerated() {
            if id.offset != 0 {
                stringIDs += ","
            }
            stringIDs += String(id.element)
        }
        
        parameters["id"] = stringIDs
        
        Alamofire.request("https://api.openweathermap.org/data/2.5/group", method: .get, parameters: parameters).responseData { response in
            if let data = response.result.value {
                let jsonDecoder = JSONDecoder()
                if let models =  try? jsonDecoder.decode(Models.self, from: data) {
                    success(models)
                }
            } else {
                failure(response.error)
            }
        }
    }
    
    static func getForecast(cityId: Int, count: Int, with success: @escaping (ForecastModels) -> Void, and failure: @escaping (Error?) -> Void) {
        parameters["id"] = cityId
        parameters["cnt"] = count
        
        Alamofire.request("https://api.openweathermap.org/data/2.5/forecast", method: .get, parameters: parameters).responseData { response in
            if let data = response.result.value {
                let jsonDecoder = JSONDecoder()
                if let models =  try? jsonDecoder.decode(ForecastModels.self, from: data) {
                    success(models)
                }
            } else {
                failure(response.error)
            }
        }
    }
}
