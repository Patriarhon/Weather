//
//  DetailCell.swift
//  Weather
//
//  Created by Petr on 20/01/2019.
//  Copyright © 2019 Petr. All rights reserved.
//

import UIKit

class DetailCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configurate(name: String, value: Any?) {
        textLabel?.text = name
        detailTextLabel?.text = "\(value ?? "N/A")"
    }
    
    func configurate(forecastModel: ForecastModel) {
        if let timeStamp = forecastModel.dt {
            timeLabel?.text = (DateHelper.getStringDate(from: timeStamp, format: "HH:mm"))
        }
        if let temperature = forecastModel.main?.temp {
            temperatureLabel.text = "\(temperature)"
        }
        if let windSpeed = forecastModel.wind?.speed {
            windLabel.text = "\(windSpeed)"
        }
        if let pressure = forecastModel.main?.pressure {
            pressureLabel.text = "\(pressure)"
        }
        if let humidity = forecastModel.main?.humidity {
            humidityLabel.text = "\(humidity)"
        }
        if let descript = forecastModel.weather?.first?.description {
            descriptionLabel.text = descript
        }
        

        
    }
}
