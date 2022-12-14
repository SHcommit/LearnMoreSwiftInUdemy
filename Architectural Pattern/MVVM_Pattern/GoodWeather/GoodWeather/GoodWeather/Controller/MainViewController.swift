//
//  mainViewController.swift
//  GoodWeather
//
//  Created by μμΉν on 2022/09/09.
//

import UIKit
import Lottie


class MainViewController: UITableViewController {
    
    var testModule = TestModule()
    var setting: AnimationView?
    var addWeather: AnimationView?
    private var weatherListViewModel = WeatherListViewModel()
    private var lastUnitSelection : Unit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupLastUnitSelection()
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadAnimationView()
        self.tableView.reloadData()
    }
    func reloadAnimationView() {
        guard let _setting = setting, let _addWeather = addWeather else {
            return
        }
        workLottie(_setting)
        workLottie(_addWeather)
    }
    func workLottie(_ av: AnimationView) {
        av.play()
        av.loopMode = .loop
    }
    
    func setupLastUnitSelection() {
        let ud = UserDefaults.standard
        if let value = ud.value(forKey: "unit") as? String {
            self.lastUnitSelection = Unit(rawValue: value)!
        }
    }
}

//MARK: - tableView delegate methods
extension MainViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherListViewModel.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "WeatherCell")
        weatherListViewModel.setupCellData(cell: cell, index: indexPath.row, listModel: self.weatherListViewModel)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

//MARK: AddWeatherDelegate
extension MainViewController: AddLocalWeatherDelegate{
    
    func addLocalWeatherDidSave(vm: WeatherViewModel) {
        print("Success delegate protocol call result :\(vm)")
        weatherListViewModel.addWeatherViewModel(vm)
    }
        
    func prepareSegueForAddLocalWeatherViewController(segue: UIStoryboardSegue) {
        guard let addLocalWeatherVC = segue.destination as? AddLocalWeather else {
            print("Failure to bind destination in seuge")
            return
        }
        addLocalWeatherVC.delegate = self
        
    }
}

//MARK: - SettingDelegate
extension MainViewController: SettingDelegate {
    func saveUnit(value: SettingViewModel) {
        print("Success get SettingVM value")
        if lastUnitSelection.rawValue != value.selectedUnit.rawValue {
            weatherListViewModel.updateUnit(to: value.selectedUnit)
            tableView.reloadData()
            lastUnitSelection = Unit(rawValue: value.selectedUnit.rawValue)!
        }
    }
    
    func prepareSegueForSettingViewController(segue: UIStoryboardSegue) {
        guard let settingVC = segue.destination as? SettingViewController else {
            print("Failure to bind destination in segue")
            return
        }
        settingVC.delegate = self
    }
}

//MARK: - segue's call method
extension MainViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "AddWeatherSegue":
            prepareSegueForAddLocalWeatherViewController(segue: segue)
            break
        case "MetricSegue":
            prepareSegueForSettingViewController(segue: segue)
            break
        default:
            break
        }
        
    }

}

//MARK: - setupUI
extension MainViewController {
    
    func  setupNavigationBar() {
        self.navigationItem.leftBarButtonItem  = settingBarButton()
        self.navigationItem.rightBarButtonItem = addWeatherBarButton()
        setupNavigationBackground()
        self.navigationItem.title = "GoodWeather"
    }
    
    func setupNavigationBackground() {
        guard let navBar = self.navigationController?.navigationBar else {
            return
        }
        self.setupNavigationAppearance(navBar: navBar)
    }
    
    func settingBarButton() -> UIBarButtonItem{
        guard let width = self.navigationController?.navigationBar.frame.height else {
            fatalError("Can't find navigaitonBar's frame")
        }
        let av: AnimationView = .init(name:"set")
        av.frame = CGRect(x: 0, y: 0, width: width + 10, height: width + 10)
        av.contentMode = .scaleAspectFit
        setting = av
        workLottie(av)
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(setting(_:)))
        av.addGestureRecognizer(tabGesture)
        let settingBtn = UIBarButtonItem(customView: av)
        
        return settingBtn
    }
    
    func addWeatherBarButton() -> UIBarButtonItem{
        guard let width = self.navigationController?.navigationBar.frame.height else {
            fatalError("Failure bind navigationBar's frame")
        }
        let av: AnimationView = .init(name: "map")
        av.contentMode = .scaleAspectFit
        addWeather = av
        workLottie(av)
        av.frame.origin = CGPoint(x: 0, y: 0)
        av.frame.size = CGSize(width: width, height: width)
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(addWeather(_:)))
        av.addGestureRecognizer(tabGesture)
        let addBtn = UIBarButtonItem(customView: av)
        
        return addBtn
    }
}

//MARK: - setup event handler
extension MainViewController {
    
    @objc func setting(_ sender: Any) {
        self.performSegue(withIdentifier: "MetricSegue", sender: sender)
    }
    
    @objc func addWeather(_ sender: Any) {
        self.performSegue(withIdentifier: "AddWeatherSegue", sender: sender)
    }
}


//MARK: basic structure extension
extension Double {
    func formatAsDegree() -> String {
        return String(format: "%.0f",self)
    }
}
