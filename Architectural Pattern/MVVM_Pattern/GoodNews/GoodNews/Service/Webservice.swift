//
//  Webservice.swift
//  GoodNews
//
//  Created by 양승현 on 2022/09/01.
//

import UIKit
import Alamofire

/**
 TODO : 기사보거나 뉴스 받고 완료하는 service
 
 - Param <#ParamNames#> : <#Discription#>
 - Param <#ParamNames#> : <#Discription#>
 
 # Notes: #
 1. <#Notes if any#>
 
 */

class Webservice{
    /**
     newsAPI를 url로 파싱할 경우 받을 수 있는 Articles를 얻음
     
     - parameter url: newsAPI를 받을 수 있는 url.
     - parameter completion: url을 성공적으로 파싱했다면 수행될 completion handler
     - returns: <#Return values#>
     - warning: <#Warning if any#>
     
     
     # Notes: #
     1. <#Notes if any#>
     
     # Example #
     ```
     // <#Example code if any#>
     ```
     
     */
    func getArticles(url: String, completion: @escaping ([Article]?)->()){

        let Articles = AF.request(
            url,
            method: .get)
        
        Articles.responseJSON{ res in
            do{
                guard let jsonObject = try res.result.get() as? NSDictionary else {
                    NSLog("res is nil in Webservice.swift")
                    return
                }
                guard let resCode  = jsonObject["status"] as? String else { return }
                guard let totalRes = jsonObject["totalResults"] as? Int else {return}
                
                guard resCode != "OK" else {
                    NSLog("URL 파싱 status 값이 OK가 아닙니다. 데이터에 문제가 있습니다.")
                    return
                }
                
                //요기서 데이터 성공적으로 파싱했는지 일단 테스트 가능
                NSLog(jsonObject.description)
                guard let list = jsonObject["articles"] as? [NSDictionary] else
                {
                    return
                }
                var articles = [Article]()
                
                for data in list {
                    let title       = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    articles.append(Article(title: title, description: description))
                }
                completion(articles)
                
            }catch let e as NSError{
                NSLog("An error found : \(e.localizedDescription)")
                completion(nil)
            }
            
            
        }
    }
}
