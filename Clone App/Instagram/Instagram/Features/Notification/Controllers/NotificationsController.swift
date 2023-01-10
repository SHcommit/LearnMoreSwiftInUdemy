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
    var vm: NotificationsViewModelType = NotificationsViewModel()
    var scriptions = Set<AnyCancellable>()
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}

extension NotificationController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCellReusableId, for: indexPath) as! NotificationCell
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}


