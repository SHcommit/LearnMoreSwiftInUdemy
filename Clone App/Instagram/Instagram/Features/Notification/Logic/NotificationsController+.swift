//
//  NotificationsController+.swift
//  Instagram
//
//  Created by 양승현 on 2023/01/11.
//

import Foundation

//MARK: - Helpers
extension NotificationController {
    
    func configureTableView() {
        view.backgroundColor = .white
        navigationItem.title = "Notificaitons"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCellReusableId)
        tableView.separatorStyle = .none
    }
    
    func setupBindings() {
        let input = NotificationsViewModelInput(viewWillAppear: viewWillAppear.eraseToAnyPublisher(), specificCellInit: specificCellInit.eraseToAnyPublisher())
        
        let output = vm.transform(with: input)
        output.sink { completion in
            switch completion {
            case .finished:
                print("DEBUG: NotificationsController subscription completion.")
            case.failure(_): break
            }
        } receiveValue: {
            self.render($0)
        }.store(in: &scriptions)
    }
    
    private func render(_ state: NotificationsControllerState) {
        switch state {
        case .none:
            break
        case .updateTableView:
            tableView.reloadData()
        }
    }
}
