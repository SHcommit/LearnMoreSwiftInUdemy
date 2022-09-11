//
//  SettingViewController.swift
//  GoodWeather
//
//  Created by 양승현 on 2022/09/09.
//

import UIKit

protocol SettingDelegate {
    func saveUnit(value: SettingViewModel)
}

class SettingViewController: UITableViewController {
    private var settingViewModel = SettingViewModel()
    var delegate: SettingDelegate?
    override func viewDidLoad(){
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        setupNavigationBackground()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBackground()
    }
    
}

extension SettingViewController {
    func setupNavigationBackground() {
        guard let navBar = self.navigationController?.navigationBar else {
            return
        }
        self.setupNavigationAppearance(navBar: navBar)
    }
}

//MARK: - tableView delegate
extension SettingViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingViewModel.units.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = settingViewModel.units[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") ?? UITableViewCell(style: .default, reuseIdentifier: "SettingCell")
        cell.textLabel?.text = item.displayType
        
        if item == settingViewModel.selectedUnit {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.visibleCells.forEach {
            $0.accessoryType = .none
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) else {
            print("Failure find user's selected cell indexPath")
            return
        }
        
        cell.accessoryType = .checkmark
        let unit = Unit.allCases[indexPath.row]
        settingViewModel.selectedUnit = unit
        
        self.delegate?.saveUnit(value: settingViewModel)
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            print("Failure find user's didSelected cell")
            return
        }
        cell.accessoryType = .none
    }
}
