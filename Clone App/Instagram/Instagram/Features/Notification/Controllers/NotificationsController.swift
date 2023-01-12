//
//  NotificationController.swift
//  Instagram
//
//  Created by 양승현 on 2022/09/30.
//

import UIKit
import Combine

class NotificationController: UITableViewController {
    
    //MARK: - Constants
    let NotificationCellReusableId = "NotificationCell"
    
    //MARK: - Properties
    let viewWillAppear = PassthroughSubject<Void,Never>()
    var specificCellInit = PassthroughSubject<(cell: NotificationCell, index: Int),Never>()
    var vm: NotificationsViewModelType = NotificationsViewModel()
    var subscriptions = Set<AnyCancellable>()
    var delegateSubscription = [AnyCancellable]()
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegateSubscription.map{$0.cancel()}
        setupBindings()
    }
}

extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        delegateSubscription.map{$0.cancel()}
        return vm.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCellReusableId, for: indexPath) as! NotificationCell
        specificCellInit.send((cell,indexPath.row))
        setupNotificationCellDelegate(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}


