//
//  ArticleViewModel.swift
//  GoodNews
//
//  Created by 양승현 on 2022/09/01.
//


/**
 TODO : ArticleViewModel은 단 한개의 cell에만 관여할 수 있는 single ViewModel이다. 그래서 상위모델을 추가한다.
 
 - Param <#ParamNames#> : <#Discription#>
 - Param <#ParamNames#> : <#Discription#>
 
 # Notes: #
 1. 상위모델을 추가할 때의 장점은?
    - 전체의 뷰를 나타낼 수 있다.(전체의 화면)
    -> search bar나 segmented control 또는 다른 항목으로 구성된 뷰가 존재한다면 부모 viewModel로 활용해야한다.
 2. 근데 중요한건 테이블 view의 cell또한 채워줘야함. Controller가 없고 ViewModel이 존재하니깐.
    like numberOfRowsInSection, CellForRowAt 와 같은 함수들이 제공되야한다.
    - 테이블 뷰를 구성하기 위해 가장 필요한 함수들의 데이터는 우선
        1) articles.count
        2) 특정 indexPath.row에서의 articles 데이터를 필요로 한다.
        3) 또 한가지가 있다면 몇개의 section으로 tableView가 구성되었는지 까지?
 
 @Issue #1 이후
 3. ViewModel로 Cell을 채우려면 customCell이 필요하다. 그래야 atricle의 title과 description을 display할 수 있다.
 */
struct ArticleListViewModel {
    let articles: [Article]
}
extension ArticleListViewModel {
    var numberOfSections: Int {
        return 1
    }
    func numberOfRowsInSection(_ section: Int)->Int{
        return self.articles.count
    }
    
    func articleAtIndex(_ index: Int)-> ArticleViewModel {
        let article = self.articles[index]
        return ArticleViewModel(article)
    }
}

/**
 TODO : ArticleViewModel은 article을 view에 표시하는 역할이다.
 
 - Param article : 실제 article news 한개를 참조하는 property
 - Param <#ParamNames#> : <#Discription#>
 
 # Notes: #
 1. articleViewModel은 **단지 한 개**의 특정한 뉴스 article을 책임진다.
 2. 몇개의 sort된 정보, user interface에게 데이터를 제공한다.
 3. 이것은 single article이다. 하지만 테이블 뷰에는 multiple articles를 ,, list를 제공해야함.
    -> ArticleViewModel을 자식으로 하는 부모 클래스 한개 더 만듬
 */
struct ArticleViewModel{
    
    private let article : Article
}

extension ArticleViewModel{
    init(_ article: Article){
        self.article = article
    }
}

extension ArticleViewModel {
    var title: String {
        return self.article.title
    }
    
    var description: String {
        return self.article.description
    }
}



