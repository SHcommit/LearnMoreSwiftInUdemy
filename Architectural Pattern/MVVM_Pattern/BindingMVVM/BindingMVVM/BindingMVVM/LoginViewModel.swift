//
//  LoginViewModel.swift
//  BindingMVVM
//
//  Created by 양승현 on 2022/09/12.
//

import Foundation

/**
 TODO : VC에서 TextField 입력시 VM으로 바인딩 되는  방법 and 반대의 경우 바인딩
 
 - Param <#ParamNames#> : <#Discription#>
 - Param <#ParamNames#> : <#Discription#>
 
 # Notes: #
 1. 바인딩 되기 위해서는 우선 인스턴스가 필요하다. VM에 값을 받는 Controller에 인스턴스를 생성
 
 */
struct LoginViewModel {
    var username: String = ""
    var password: String = ""
}
