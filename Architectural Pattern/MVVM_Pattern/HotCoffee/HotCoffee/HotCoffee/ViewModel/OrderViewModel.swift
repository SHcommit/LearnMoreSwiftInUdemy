import Foundation

/**
 TODO : Screen에 화면 채우기 위한 데이터를 반환.
 
 - Param <#ParamNames#> : <#Discription#>
 - Param <#ParamNames#> : <#Discription#>
 
 # Notes: #
 1. OrderViewModel 정의
 2. OrderViewModel을 다량으로 갖는 list 정의
 3. Controller에 UI상태 정보등을 주는 함수 정의
 (참고로 이 선생님?은 extension으로 표현해주는걸 좋아함. 클린코드 읽다보니 이해는 감.
    -> 테이블 뷰에 뿌릴려함 어떻게 해야할까?
    -> tableView의 델리게이트 값들을 여기에 서 반환할수있는함수 만들고 Controller에는 VM인스턴스를 통해 반환만 해주면 됨.
 
 즉! tableview Controller에서 데이터가 필요하면 VM에서 지원해 주자.
 */


/**
 TODO : 전체 뷰 스 크린에 데이터 표현할 것.

 # Notes: #
 1. 테이블뷰에 Delegate 메서드를 만족 시킬만한 value들을 반환할 메소드를 선언하자
 
 */
class OrderListViewModel {
    var ordersViewModel: [OrderViewModel]
    
    init() {
        self.ordersViewModel = [OrderViewModel]()
    }
}

extension OrderListViewModel {
    func orderViewModel(at index: Int) -> OrderViewModel {
        return self.ordersViewModel[index]
    }
}

/**
 TODO : Order한개 화면에 뿌려주기 위한 데이터

 1. <#Notes if any#>
 
 */
struct OrderViewModel {
    let order: Order
}

//get
extension OrderViewModel {
    
    var name: String{
        return self.order.name
    }
    
    var email: String{
        return self.order.email
    }
    
    var type: String{
        return self.order.type.rawValue.capitalized
    }
    
    var size: String {
        return self.order.size.rawValue.capitalized
    }
}
