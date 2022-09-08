# HotCoffee

1. 강의 보기전에 대략적인 UI를 구현했습니다. 이번엔 Autoresizing 레이아웃을 사용하지 않고 구현해봤다.

<img src="https://user-images.githubusercontent.com/96910404/188262725-91e63009-8f40-4984-9676-3a49a371499a.gif"  width="200" height="400"/>

오호.. Hiroku로 간단하게 주간단하게 웹 서버가 동작하는 법을 살짝 맛봤다.


1. 초기 order 서버에는 빈 배열만있는데 iOS로 새로운 데이터 전송을 하지않고 (네트워킹 툴)포스트맨에서도 쉽게 value를 추가 할 수있다. 근데 이 강의에서 소개한 서버는 한번 실행하면 몇시간만에 저장해둔 db 값들을 다시 싹 날려버린다. (헛;; 기존 서버가 만료됬나..  요청 안됬는데 다행히 공지사항을 보니 새 서버 주소가 있네 휴..)
2. 실제로 Web API를 test할 때는 포스트맨 같은 네트워킹 툴을 사용하면 휠씬 편하다.(잘 응답 되는지 등등+ 문서화도 가능)
3. 이미지1 서버 정상동작
<img width="600" alt="스크린샷 2022-09-07 오후 12 43 00" src="https://user-images.githubusercontent.com/96910404/188784052-138fc958-13a9-4d24-9cae-26e3167f977b.png">

4. 포스트맨을 사용하면 어플리케이션에서 POST방식으로 값을 서버로 전달하지 않고도 포스트맨에서 POST방식으로 값을 추가해준 후에 GET방식으로 변환해서 성공적으로 값이 서버에 저장되었는지 요청하면 볼 수있다. 정말 편하고 신기하다.

# 마주한 에러들


## 돌발상황 #1 


오늘 마주한 에러이다...

Date: 22.09.03~22.09.04

새로운 개념을 알게 되었다 Codable... 그냥 데이터를 JSON형식으로 모델에 적용하는것은 쉬운데 Codable 프로토콜로 채택하는 것은 아주 많이 까다로웠다.


<img src="https://user-images.githubusercontent.com/96910404/188299660-d3f87306-6a03-4a4c-a67e-9cc9f3bc4bfc.png"  width="250" height="300"/>


간단하게 responseString으로 값을 확인했을 때는 성공적으로 데이터가 존재하는데 decode(_:from:)를 했을 때 Codable 프로토콜이 적용되지 않은 채로 존재한다. 데이터 -> decode가 적용이 되지 않는다. 왜그럴까? 해결하려고 온갖 방법을 썼는데 그덕에 Alamofire의 여러 response 메소드를 강제로 다루게 되고 익숙해져버렸다;;;;;.... 하지만 문제는 여전히 해결할 수 없었다. URLRequest로 HTTP메서드 정의해서 URLSession으로 데이터를 파싱하려고해도 에러가...발생했다.

해결 과정은 아래에 작성.

---

## <a href="https://github.com/SHcommit/LearnMoreSwiftInUdemy/commit/7829c139ebb5ced05ce478d13476213b8ee74a49">돌발상황 #2</a>


어떤 유저가 coffee size 타입을 Large로 보냈다. 하지만 내 Enum에는 소문자로 case가 되있어 Codable 조건이 만족되지 않았다. 

-> singleValueContainer를 통해 Container>의 데이터를 받아와서 lowercased()적용했다. 그래서 CoffeeSize또한 lowercase()를 적용시키니 해결이 됬다.


## 돌발상황 #3


사용자가 주문을 할 경우 그 값들은 Order.create(_:)를 통해 만들 수 있다. 이건 Order 인스턴스이다. Codable타입이기에 JSONEncoder()로 인코딩을해서 데이터를 얻었다.

URLRequest말고 AF.request(_:method:...) 함수를 통해 다량으로 값을 넣어 전송하고 싶었다. 근데 reqeust의 경우 parameters로 값을 서버로 전송할 수 있는데 JSONSerialization.jsonObject(with:) as [String:Any]로 변환해주었는데 차꾸만 responseDecodable(of:) 과정에서 디코딩을 수행할 수 없었다..;;

그래서 결국 load<T>(resource:completion:), send<T>(resource:completion:) 따로 분리해주었다. 클린코드 저자와 비슷하게 코드를 구현하려고 중복되지 않도록 여러 메소드로 쪼갰다.

AF.request의 경우 url String을 요구하는것과 URL을 요구하는 두가지 함수 오버로딩이 되어있어서 send로 HTTP에 값을 전송할 때는 URLRequest인스턴스를 만들어서 AF를 사용했다.

## 돌발상황 #4

마지막으로 마주한 에러인데,, 사용자의 주문을 받으면 save버튼을 통해 주문 정보는 서버에, 그와 동시에 다시 메인화면으로 되돌아가야한다.

난 강의에서와 다르게 먼저 구현하고 강의를 보면서 공부했기에 화면 전환 구조가 살짝 달랐다. 그래서인지 모르게 에러가 발생했다.

> UITableViewAlertForLayoutOutsideViewHierarchy error: Warning once only (iOS 13 GM)

이 에러가 발생했다. frame을 보니 메인 화면의 tableView에서 난 에러였다. 원인은 아마 <a href="https://github.com/SHcommit/LearnMoreSwiftInUdemy/blob/master/Architectural%20Pattern/MVVM_Pattern/HotCoffee/HotCoffee/HotCoffee/Controllers/OrdersTableViewController.swift">메인 OrderTableVC 컨트롤러</a>에서 테이블 뷰가 표시되지 않는데 segue된 화면에서 메인 테이블 뷰의 cell을 추가하는 코드를 구현 했기에 이런 에러가 발생했던 것 같다. (아.. 에러난 코드를 커밋하지 않았네 ㅠㅠ)

해결법은 viewWillAppear()에 tableView.reloadData()를 실행하고 AddOrderVC에서 오더를 받으면 단지 list에 값을 추가하기만 하는 방식으로 구현했다.

그리고 화면 전환을 segue로 했다. 되돌아갈 때는 navigationController의 popViewController(animated:) 메서드를 사용해 되돌아왔다.


# 새로 알게된 개념

## 1. JSON과 Codable 공부 

Date: 22.09.03~22.09.06 위에서 마주한 에러를 해결하기 위해 약간의 공부를 했다. 간단하게 끝날 줄 알았는데 시간은 계속 흘렀다.

위의에러를 해결하기 위해서 <a href="https://dev-with-precious-dreams.tistory.com/132">RESTful API JSON 데이터 파싱 개념을 공부했고  URLSession과 URLReqeust에 대해 자세하게 공부했다</a>. Codable을 적용하기 위해 <a href="https://dev-with-precious-dreams.tistory.com/134">Alamofire 도 공부</a>를 했다.  URLRequest + URLSession 과 Alamofire 공부를 충분히 한 후에 <a href="https://dev-with-precious-dreams.tistory.com/135">Codable 공부를 했다</a>.  그리고 <a href="https://dev-with-precious-dreams.tistory.com/136">Codable이 진짜 좋은 프로토콜임을</a>임을 알게 되었다.

근데 가장 좋은 건 친절하게 알려주신 <a href="https://stackoverflow.com/questions/73596588/ios-how-can-i-parse-json-codable-array-with-alamofire">StackOF 천사같은 어느 한 개발자님</a>..정말 감사했다. 선 정답 답변을 통해 알고도 곧바로 이해를 못했지만 Codable공부를 완벽하게 끝낸 이후엔 내 코드에 CodingKeys정의부터 몇몇 문제가 있었음을 알 수 있었다. 그리고 에러를 해결했다.

## 2. 서버 root JSON 형식
새로 알게된 개념인데 RESTful API의 JSON 에서 **root object as Array**인 경우 OrderList라는 list구조체를 굳이 만들지 않아도 된다.

load(resource<[Order]>) { result in
   // handle the response but now you will get the list of orders
}

를 통해 배열로된 list를 받을 수 있기 때문이다.

이와 반면에 root object as Object의 경우 OrderList를 생성해야 한다.

## 3. 화면 전환시 델리게이트

강의를 들으면서 정말 좋았던 것은 화면 전환시에 델리게이트를 프로토콜로 구현해 본 것이다. A(메인VC) B(subVC)가 존재하고 A->B로 화면 전환한 상태에서 B에서 발생한 정보를 A로 넘겨줄때 델리게이트를 프로토콜로 구현해서 사용했다.

B의 VC에서 A에서 수행해야 할 기능들을 프로토콜로 만들어 놓고 A의 화면에서 B의 화면으로 전환할 때 B VC인스턴스를 얻어 델리게이트 변수에 자기자신을 등록함으로써 B에서 기능들을 호출하면 A에서 구현한 델리게이트 메서드가 작동한다. 이때 화면 전환도 이루어진다.

## 4. JSON 파싱 POST 방법

RESTAPI에 대한 GET 방식은 거의 잘 이해했는데 POST방식은 이전에 메모 앱 만들때도 해봤지만 기억이 잘 안났다. 다행히 **돌발상황 #3** 과정을 겪으며 POST방식에 대해 어느정도 개념을 갖게 된 것 같다.

# 결론

요즘 클린코드를 읽고 있는데 클린코드의 저자 스타일을 쪼금이나마 실행에 옮겼다.

목적은 MVVM 패턴을 공부하는 것이지만 VM 구현하는 것 이외에도 공부한 것이 좀 있었던 실습이었다.

<img src="https://user-images.githubusercontent.com/96910404/189078127-268efa92-851e-44e1-9f36-ed0a0ffd1aec.gif"  width="200" height="400"/>

// save 시 서버에 데이터가 잘 추가되었는지? ( 잘 수행됨! )

<img src="https://user-images.githubusercontent.com/96910404/189078184-735a4f24-3ef9-4855-a228-e83f2d7b324f.png"  width="300" height="600"/>

