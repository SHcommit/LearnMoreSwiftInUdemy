import UIKit

class NewsListTableViewController : UITableViewController{
    var arr = [1,2,3,4,5,6,7,8,9,0,1,2,3,13,13,23,1,233,1,31,31,31,3,13,13,13,13,13,13,13,13,1,31,31,31,3,13,3,1]
    var lists = [Article]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setup()
    }
    private func setup(){
        let newsUrl = "https://newsapi.org/v2/top-headlines?country=kr&apiKey=dc7c80a136c9497c9a0f04d113b500e6"
        Webservice().getArticles(url: newsUrl){ temp in
            guard let list = temp else {return}
            self.lists = list
            self.tableView.reloadData()
        }
        NSLog("\(lists.count)")
    }
}


extension NewsListTableViewController{
    func setupNavigation(){
        //Navigation Title
        self.navigationItem.title =  "Daily 뉴스"
        
        //MARK: - appearance settings
        guard let navBar = self.navigationController?.navigationBar else{ return }
        navBar.prefersLargeTitles   = true
        let appearance              = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor  = UIColor(displayP3Red: 47/255, green: 54/255, blue: 64/255, alpha: 1.0)
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.titleTextAttributes = [.foregroundColor : UIColor.white]
        navBar.standardAppearance   = appearance
        navBar.scrollEdgeAppearance = appearance
    }
}

//MARK: - tableViewDelegate handler
extension NewsListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "newsCell")
        cell.textLabel?.text = "\(lists[indexPath.row].title)"
        cell.detailTextLabel?.text = "\(lists[indexPath.row].description)"
        return cell
    }
    
}
