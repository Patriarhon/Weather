//
//  CityController.swift
//  Weather
//
//  Created by Petr on 19/01/2019.
//  Copyright © 2019 Petr. All rights reserved.
//

import UIKit
import MBProgressHUD

class CityController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var data = [Model]()
 
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputTextField.delegate = self
       
        configureTableView()
        DatabaseManager.setupRealm()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        NetworkManager.getCurrentWeather(cityIDs: getCities(), with: { (models) in
            self.setModeForCitys(isOnline: true, models: models)
        }) { (error) in
            self.setModeForCitys(isOnline: false)
        }
    }
    
    //MARK: - Actions
    
    @IBAction func buttonDidTap(_ sender: UIButton) {
        guard let city = inputTextField.text else { return }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        NetworkManager.getCurrentWeather(in: city, with: { (model) in
            if model != nil {
                self.setMode(isOnline: true, model: model)
            } else {
                self.showAlert()
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }) { (error) in
            self.setMode(isOnline: false)
        }
    }
    
    // MARK: - Private
    
    private func showAlert() {
        let alert = UIAlertController(title: "City not found", message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ОК", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getCities() -> [Int]{
        self.data = Array(DatabaseManager.getModelFromRealm(by: .all))
        self.tableView.reloadData()
        
        return data.map({ $0.id })
    }
    
    private func setMode(isOnline: Bool, model: Model? = nil) {  // Конечно, при оффлайн режиме по-хорошему, надо проверять актуальность информации по времени и выводить только актуальную, но думаю это выходит за рамки тестового задания
        if isOnline {
            DatabaseManager.writeCities(citys: [model!])
        }
        
        self.getCitysFromDatabse()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    private func setModeForCitys(isOnline: Bool, models: Models? = nil) {
        if isOnline {
            DatabaseManager.writeCities(citys: (models?.list)!)
        }
        
        self.getCitysFromDatabse()
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
    }
    
    private func getCitysFromDatabse() {
        self.data = Array(DatabaseManager.getModelFromRealm(by: .all))
        
        self.tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource

extension CityController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = String(describing: CityCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CityCell
        cell.configure(with: data[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate

extension CityController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = String(describing: DetailViewController.self)
        let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier) as! DetailViewController
        detailViewController.model = data[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}

//MARK: - UITextFieldDelegate

extension CityController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}

