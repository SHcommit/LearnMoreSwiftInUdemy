//
//  OrdersTableViewController.swift
//  HotCoffee
//
//  Created by 양승현 on 2022/09/02.
//

import UIKit
import Alamofire
class OrdersTableViewController : UITableViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        populateOrders()
        
        
        
    }
    
    //웹서비스에 요청
    private func populateOrders() {
        let coffeeOrdersURL = "https://warp-wiry-rugby.glitch.me/orders"
        let resource = Resource<[Order]>(url: coffeeOrdersURL)
        Webservice().load(resource: resource) { result in
            
            switch result {
            case .success(let orders):
                print(orders)
            case .failure(let error):
                print(error)
            }
        }
    }
}


extension OrdersTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        UITableViewCell()
    }
}
//MARK: - setupUI
extension OrdersTableViewController {
    //navigationBar
    func setupNavigationBar(){
        self.navigationItem.title = "Orders"
        
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(presentNewOrder(_:)))
        self.navigationItem.rightBarButtonItem = addBtn
    }
    
}

//MARK: - Event Handler
extension OrdersTableViewController {
    @objc func presentNewOrder(_ sender: Any){
        performSegue(withIdentifier: "addOrderSegue", sender: sender)
    }
}
