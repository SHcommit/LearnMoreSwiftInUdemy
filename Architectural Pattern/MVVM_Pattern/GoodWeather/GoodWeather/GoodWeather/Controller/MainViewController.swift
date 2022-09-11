//
//  mainViewController.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/09.
//

import UIKit
import Lottie


class MainViewController: UITableViewController {
    var testModule = TestModule()
    var setting: AnimationView?
    var addWeather: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadAnimationView()
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
}

//MARK: - tableView delegate methods
extension MainViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell") ?? UITableViewCell(style: .value1, reuseIdentifier: "WeatherCell")
        cell.textLabel?.text = "Daejeon"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22)
        cell.detailTextLabel?.text = "33"
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 25)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "AddWeatherSegue" else {
            print("Failure find identifier in segue")
            return
        }
    }
    
    func prepareSegueForAddLocalWeatherViewController(segue: UIStoryboardSegue) {
        guard let addLocalWeatherVC = segue.destination as? AddLocalWeather else {
            print("Failure to bind destination in seuge")
            return
        }
        addLocalWeatherVC.delegate = self
        
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
