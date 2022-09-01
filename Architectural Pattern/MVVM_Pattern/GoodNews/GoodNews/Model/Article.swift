//
//  Article.swift
//  GoodNews
//
//  Created by 양승현 on 2022/09/01.
//

/**
 TODO : News API에 있는 데이터를 파싱했을 경우 원하는 뉴스 데이터를 저장하기 위한 Model
 
 - Param <#ParamNames#> : <#Discription#>
 - Param <#ParamNames#> : <#Discription#>
 
 # Notes: #
 1. <#Notes if any#>
 
 */

struct Article: Decodable{
    let title      : String
    let description: String
}
