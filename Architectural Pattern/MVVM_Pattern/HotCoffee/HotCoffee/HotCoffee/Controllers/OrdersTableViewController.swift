//
//  OrdersTableViewController.swift
//  HotCoffee
//
//  Created by 양승현 on 2022/09/02.
//

import UIKit
import Alamofire
class OrdersTableViewController : UITableViewController{
    
    var orderListViewModel = OrderListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        populateOrders()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    //웹서비스에 요청
    private func populateOrders() {
        Webservice<[Order]>().load(resource: Order.all) { [weak self] result in
            
            switch result {
            case .success(let orders):
                self?.orderListViewModel.ordersViewModel = orders.map{ OrderViewModel.init(order: $0)}
                self?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - tableViewDelegate
extension OrdersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orderListViewModel.ordersViewModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let vm = self.orderListViewModel.orderViewModel(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath)
        
        cell.textLabel?.text = vm.type
        cell.detailTextLabel?.text = vm.size
        
        return cell
    }
}

//MARK: - addCoffeeOrderDelegate
extension OrdersTableViewController: AddCoffeeOrderDelegate
{
    func addCoffeeOrderViewControlelrDidSave(order: Order, controller: UIViewController) {
        let orderVM = OrderViewModel(order: order)
        self.orderListViewModel.ordersViewModel.append(orderVM)
        controller.navigationController?.popViewController(animated: true)
    }
    
    func addCoffeeOrderViewControllerDidClose(controller: UIViewController) {
        controller.navigationController?.popViewController(animated: true)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? UIViewController, let addCoffeeOrderVC = vc as? AddOrderNewController else {
            fatalError("Error performing segue")
            return
        }
        addCoffeeOrderVC.delegate = self
    }
}
