import UIKit

class NewsListTableViewController : UITableViewController{
    private var articleListVM: ArticleListViewModel!
    var lists = [Article]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataParsing()
        setupNavigation()
    }
    private func setupDataParsing(){
        let newsUrl = "https://newsapi.org/v2/top-headlines?country=kr&apiKey=dc7c80a136c9497c9a0f04d113b500e6"
        Webservice().getArticles(url: newsUrl){ articles in
            guard let _articles = articles else {return}
            self.articleListVM  = ArticleListViewModel(articles: _articles)
            /*
             이건 가장 중요한거, 현재 어플의 Scene을 구성하는 주요한 refresh이니까
             DispatchQueue를 통해 main 스레드 UI 스레드에서 동작하도록 해야함.
             */
//            DispatchQueue.main.sync {
//                self.tableView.reloadData()
//            }
            self.tableView.reloadData()
        }
    }
}


extension NewsListTableViewController{
    private func setupNavigation(){
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.articleListVM == nil ? 0 : self.articleListVM.numberOfSections
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articleListVM.numberOfRowsInSection(section)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "newsCell")
        
        let articleVM = self.articleListVM.articleAtIndex(indexPath.row)
        cell.textLabel?.text = articleVM.title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        cell.detailTextLabel?.text = articleVM.description
        //오 한가지 신기한건 detailTextLabel의 라인수를 0으로하면 detailTextlabel의 String전부 Lines로 표시되네.
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
}
