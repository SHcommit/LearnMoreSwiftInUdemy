# GoodWeather

## 새로 적용한 것 & 느낀점
1. 강의 계획을 보고 사전에 UI 구현
<img src="https://user-images.githubusercontent.com/96910404/189283949-1d05439d-6bfc-4015-97fc-4f000b1787ec.gif"  width="200" height="400"/>

2. 클린코드를 읽으며 TDD 개념에 대해 알게 되었다. 한번 TestModule로 데이터 파싱에 대한 테스트 코드를 만들어 봤다. test code 모듈에 대한 의미와 구현 방법을 정확하게 구현하기 위해 추가적으로 공부 해야겠다.

3. 테스트 코드를 통해 성공적으로 작동될 경우에 VM 등을 만들어서 하는 것도 좋은 방법임을 알게 되었다. 테스트 코드를 몇가지 상황에서 작성을 해봤다.

---

 VM의 역할은 클라이언트에 데이터를 채울때 그 모든 정보를 VM에서 제공하는 것. 그래서 VM은 Controller한테 특정 데이터들 값을 바로 바로 제공하면 되는 것! Controller는 VM의 처리과정에 대한 연산 없이 결과값을 반환 받기만 할 정도로 Controller역할이 낮아지고 VM역할이 커지는 것을 알게 됨.


## 배운점
1. UINavigationController를 세그로 연결받은 뷰에는 자동으로 뒤로가기 버튼이 구현되는데 이 값 또한 appearance로 적용 해야한다.

> UIBarButtonItem.appearance().tintColor = UIColor.white

2. JSON으로 gif 적용.(with Lottie open source)
> UIBarButtonItem의 customView에 AnimationView타입 적용. 버튼 터치이벤트 인식 안되서 Gesture를 달아주니 잘 됨!

3. final 키워드를 통해 더 이상 상속으로 변경할 수 없는 클래스 선언할수 있음.
4. **서버**에서 URLSession이나 Alamofire로 **데이터를 요청**할 때 **@escaping completion**으로 데이터 파싱 결과값을 처리한다.
> **completion은 백그라운드 thread**(sub thread)에서 실행이 된다. completion 인자값으로 전달받은 데이터를 UI를 위한 값으로 처리하게 된다면 문제가 생긴다. ( UI업데이트 이슈가 생김)
> > service에서 load한 데이터 값 completion으로 escaping할땐 **main thread**로 completion을 넘겨주어야 한다.
5. 아는 친한 형한테 배웠는데 이때 메인큐에서 sync를 사용하게 되면 기존에 실행되던 기존에 진행되던 main Queue 흐름과 충돌이 된다. 그래서 async로 처리를 해야한다.
6. **apiKey**가 노출되면 안될 경우가 있는데 이를 간과했다.(부랴부랴 api key노출된 코드 관련 커밋을 전부 삭제했다.) 담부터는 .gitignore에 민감한 정보는 따로 빼서 깃 커밋을 배제 해야겠다...

---

7. **와우.** 이번에 Service/Webservice.swift에서 Resource는 load<T>(resource:completion:)에서 파싱된 데이터를 저장해서 codable 제너릭타입으로 반환할 수 있는 parse 클로저를 갖고 있다. Alamofire를 쓰지 않아도 될 정도로 코드가 작게 분리됬다. 하지만 responseDecodable을 쓰면 JSonDeocder().decoe(_:from:)을 자동으로 해주니까 훨씬 간결한 코드를 작성할 수 있지만, 이번 강의를 통해 또 하나 새로 배워간다.

---

## 구현 완료!

<img src="https://user-images.githubusercontent.com/96910404/189528644-f9f097fa-13c4-44e3-8025-0a32e4cd2da9.gif"  width="200" height="400"/>
