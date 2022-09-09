//
//  mainViewController.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/09.
//

import UIKit
import Lottie


class MainViewController: UITableViewController {
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
