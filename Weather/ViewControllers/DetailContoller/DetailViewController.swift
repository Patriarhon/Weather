//
//  DetailViewController.swift
//  Weather
//
//  Created by Petr on 20/01/2019.
//  Copyright © 2019 Petr. All rights reserved.
//

import UIKit
import MBProgressHUD

class DetailViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    var model: Model!
    var groupedForecastModels = [[ForecastModel]]()
    var days = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityNameLabel.text = model.name
        groupedForecastModels.append([ForecastModel(model: model)])
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Actions
    
    @IBAction func valueDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            days = 0
            groupedForecastModels = [[ForecastModel]]()
            groupedForecastModels.append([ForecastModel(model: model)])
            tableView.reloadData()
        case 1:
            days = 3
            groupedForecastModels = [[ForecastModel]]()
            getWeather()
        case 2:
            days = 5
            groupedForecastModels = [[ForecastModel]]()
            getWeather()
        default: break
        }
    }
    
    //MARK: - Private
    
    private func groupForecasts(models: ForecastModels) {
        groupedForecastModels.removeAll()
        for i in 0 ..< days {
            let forecastModels = models.list.filter({ DateHelper.getDay(timestamp: $0.dt) == i})
            if !forecastModels.isEmpty {
                self.groupedForecastModels.append(forecastModels)
            }
        }
    }
    
    private func setMode(isOnline: Bool, model: ForecastModels? = nil) {
        if isOnline {
            DatabaseManager.writeForecasts(forecasts: (model?.list)!, cityId: self.model.id)
        }
        
        self.getForecastsFromDatabase()
        tableView.reloadData()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    private func getForecastsFromDatabase() {
        guard let forecasts = DatabaseManager.getForecastsFromRealm(cityId: model.id) else { return }
        groupForecasts(models: ForecastModels(forecasts: forecasts))
    }
    
    private func getWeather() {
        let count = days * Constants.forecastsInDay
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkManager.getForecast(cityId: model.id, count: count, with: { (models) in
            self.groupForecasts(models: models)
            self.setMode(isOnline: true, model: models)
        }) { (error) in
            self.setMode(isOnline: false)
        }
    }
}

//MARK: - UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groupedForecastModels.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let timeStamp = groupedForecastModels[section].first?.dt {
            return DateHelper.getStringDate(from: timeStamp, format: "dd MMMM")
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupedForecastModels[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DetailCell
        cell.configurate(forecastModel: groupedForecastModels[indexPath.section][indexPath.row])
        return cell
    }
    
    
}
