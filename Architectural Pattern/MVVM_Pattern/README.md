# GoodNews 


기본 강의를 듣기 전에 일단 MVC패턴으로 뉴스 REST API를 받아와 tableView Cell을 구현했습니다.

URLSession의 task를 통해 JSONSerialization로 데이터를 파싱하지 않고 최근에 Swift 재은씨 실전편을 통해 익혔던 Alamofire를 통해 데이터를 파싱하고 구현했습니다.

---

![초기구현](https://user-images.githubusercontent.com/96910404/187906850-0c1c6226-6848-41d8-8d52-c32929b5eb1f.gif)

강의를 보면서 새롭게 Controller 대신 ViewModel 을 적용시켜 View에 관여하도록 코드를 구현했는데 

음..?

Scene과 대응하는 Controller는 역시 제거를 안하는구나,,(Controller -> ViewModel 완벽 대체가 아니었군)

좀 더 MVVM 패턴 공부를 해봐야겠다는 생각이 들었습니다. 

## GoodNews->ViewModel->ArticleViewModel.swift

다만 ViewModel은 Model과는 달랐다고 느낀게 Model은 데이터 그 자체 틀인건 분명한데

**ViewModel**에서는 Model 한개의 인스턴스를 참조로 하는 구조체를 생성합니다.(ArticleViewModel)

**현재 클라이언트에 필수적으로 표시되기 위한 데이터** 한 덩어리(ex_cell을 이루는 데이터 한 덩어리 == article)와 이 데이터를 반환할 수 있는 연산 프로퍼티들을 정의한 것이 색달랐습니다.

원래는 그냥?? 파싱한 데이터들을 곧바로 꺼내서 테이블 뷰 셀cellForRowAt에 적용시키는 건데......

또 한가지 눈여겨 본 점은 방금 정의한 **ArticleViewModel은 단 한 뭉치의 데이터에 대해서만 참조**를 하는 것이므로 단 한개의 cell만 정보를 채워넣을 수 있기에 실제로 이 한덩어리의 **ArticleViewModel**을 여러 개로 저장할 수있는 List를 정의해야되는데 어디에 정의하나 궁금했습니다. 평소같으면 UserDefaults나 AppDelegate, 그냥 Scene의 VC에 정의했는데,,

이를 상위모델로 추가한다는 것입니다.**(ArticleListViewModel)** 

여기서 또 눈여겨 볼 점은 단순히 List만 갖는게 아니라 실제 프로퍼티 셀의 NewsListTableViewController **tableView 델리게이트 메소드에 필요한 정보들 또한 연산 프로퍼티나 함수**로 미리 입력해뒀다는 것입니다.( 이러면 Controller의 비중이 쫌 줄거 같다는 생각이 들었습니다.)

![image](https://user-images.githubusercontent.com/96910404/187989786-644d12be-d71e-449b-afdc-571701e007e1.png)

---

그 밖에 새로 배운점은 

- 데이터를 파싱할때 네이밍을 Service 로 Group하는것?!
- TableViewCell detailTextLabel의 numberOfLines를 0으로 설정하면 모든 String을 볼 수 있다는 점
- numberOfLines를 쓸 때 tableView(_:heightForRowAt:)를쓰면 Line이 늘어나지 않는다는점
- <a href="https://dev-with-precious-dreams.tistory.com/131">appearance 복습</a>
- appearance .largeTitleTextAttributes를 navigationBar text가 커졌다가 다시 원래대로 작아진다는점

---

이대로 끝난게 좀 아쉬웠지만 그래도 남아 있는 JSON parameter중에 url이있어서 cell을 터치하면 WKWebView로 띄우는 것을 추가 구현했습니다.

![Simulator Screen Recording - iPhone 13 Pro Max - 2022-09-02 at 02 52 54](https://user-images.githubusercontent.com/96910404/187980491-3bdb74d1-9ff9-428b-bb2f-b48df35354fc.gif)

- (여기서 한가지 어려웠던 점은 navigation Bar를 추가 구현해야 back 버튼을 추가할 수 있다는 점)

- (마지막으로 어려웠던 것은 커스텀으로 navigation title을 설정했는데 .largeTitleTextAttributes 적용이 어려웠다는 점)
