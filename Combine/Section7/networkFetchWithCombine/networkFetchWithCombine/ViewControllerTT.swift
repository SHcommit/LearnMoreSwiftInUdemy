//
//  ViewController.swift
//  networkFetchWithCombine
//
//  Created by 양승현 on 2022/11/16.
//

import UIKit
import Combine

class ViewControllerTT: UITableViewController {
    
    private var cancellable: AnyCancellable?
    
    private var posts = [Post]() {
        didSet {
            print("reloadData")
            print(posts)
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        cancellable = WebService().fetchPosts()
            .catch { _ in Just([Post]())}
            .assign(to: \.posts, on: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = posts[indexPath.row].title
        cell.detailTextLabel?.text = posts[indexPath.row].body
        
        return cell
        
    }

}

