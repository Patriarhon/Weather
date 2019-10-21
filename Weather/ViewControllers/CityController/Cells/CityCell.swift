//
//  CityCell.swift
//  Weather
//
//  Created by Petr on 22/01/2019.
//  Copyright © 2019 Petr. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public
    
    func configure(with model: Model) {
        textLabel!.text = model.name
        if let currentTemperature = model.main?.temp {
            detailTextLabel!.text = String(currentTemperature)
        }
    }
}
