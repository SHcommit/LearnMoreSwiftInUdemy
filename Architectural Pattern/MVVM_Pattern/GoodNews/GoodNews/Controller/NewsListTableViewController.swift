import UIKit

class NewsListTableViewController : UITableViewController{
    var arr = [1,2,3,4,5,6,7,8,9,0,1,2,3,13,13,23,1,233,1,31,31,31,3,13,13,13,13,13,13,13,13,1,31,31,31,3,13,3,1]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setup()
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") ?? UITableViewCell(style: .default, reuseIdentifier: "newsCell")
        cell.textLabel?.text = "\(arr[indexPath.row])"
        return cell
    }
    private func setup(){
        
    }
}


extension NewsListTableViewController{
    func setupNavigation(){
        //Navigation Title
        let title           = UILabel()
        title.text          = "GoodNews"
        title.textColor     = .white
        title.textAlignment = .center
        title.font          = UIFont.systemFont(ofSize: 30, weight: UIFont.Weight(rawValue: 0.35))
        title.sizeToFit()
        title.isOpaque      = true
        self.navigationItem.titleView = title
        
        //MARK: - appearance settings
        guard let navBar = self.navigationController?.navigationBar else{ return }
        let appearance              = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor  = UIColor(displayP3Red: 47/255, green: 54/255, blue: 64/255, alpha: 1.0)
        
        navBar.standardAppearance   = appearance
        navBar.scrollEdgeAppearance = appearance
    }
}
