# BindingMVVM 

### MVVM의 꽃이라 할 수 있는 바인딩을 하는 방법은 크게 두가지가 있다.

- View to ViewModel binding
- ViewModel to View binding

## Q1> What is View to ViewModel binding?

> 사용자가 클라이언트에 입력을 할 때 자동적으로 연관된 ViewModel 인스턴스 내 특정 프로퍼티 값이 없데이트 되어야 한다.

클라이언트에 한개의 TextField가 있고 VM안에 temp 프로퍼티가 있다고 가정한다면, 사용자가 TextField를 입력했을 때 temp 프로퍼티 또한 그 값이 바로 바로 할당되야 한다. ( 내 추측인데 이런 바인딩은 더욱 Controller의 의존성을 떨칠 수 있다. )

---

이제부터 정리하는 글의 컨텐츠는 <a href="https://github.com/SHcommit/LearnMoreSwiftInUdemy/tree/master/Architectural%20Pattern/MVVM_Pattern/BindingMVVM/BindingMVVM/BindingMVVM">이 코드를 기반으로</a> 강의에서 한 실습을 바탕으로 간단하게 배운 내용을 요약할 것이다.

UI에는 username , password TextField 두개가 있다. 이를 저장할 수 있는 VM은 LoginViewModel로 정의를 했다.

LoginViewModel의 주요 기능은 단순히 특정 값을 입력하고 '완료' 버튼을 눌렀을 때 VM의 인스턴스 값이 갱신되는게 아니라 View가 반응이 보이면 그 순간 변화된 특정 TextField의 값이 연관된 VM의 인스턴스 프로퍼티 값에 자동적으로 대입이 되는게 바인딩의 주 목적이다.

- 그렇다면 어떻게 자동적으로 TextField의 값을 연관된 VM의 특정 프로퍼티로 바인딩 할 수 있을까?

SwiftUI에는 이러한 기능이 있지만 storyboard를 사용하는 iOS개발에서는 이러한 메커니즘이 없기에 개발자가 스스로 구현해야 한다.

TextField를 상속받는 <a href="https://github.com/SHcommit/LearnMoreSwiftInUdemy/blob/master/Architectural%20Pattern/MVVM_Pattern/BindingMVVM/BindingMVVM/BindingMVVM/CustomViews/BindingTextField.swift">커스텀 클래스</a>를 구현하는데 이때 간단하지만 정말 주요한 로직은 초기화 할 때 addTarget함수를 추가하는 것이다. 이때 세번째 매개변수의 for에는 .editingChanged 조건을 부여함으로써 TextField가 입력이 될 때마다 addTarget의 #selected() 안에 특정한 메서드가 계속해서 실행되는 것이다. +_+

그 함수 이름은 textFieldDidChange(_:)인데 이제 사용자의 입력시에 매번 이 Event Handler 함수가 호출되기 때문에 이 함수를 통해 TextField.text를 자유롭게 얻을 수 있는 것이다. **다시말해**, 해당 TextField가 변할 때마다 우리에게 호출자가 변경함을 subscribe할 수 있는 기회를 얻을 수 있는 것이다. 크으...

이 값을 얻기 위해 (String) -> Void 타입의 클로저 변수(==textChanged)를 하나 선언함으로써 매번 값이 변경할 때 이 클로저 타입의 String은 textFieldDidChange(_:)로부터 변경된 text가 인자값으로 전달되어 우리는 **바인딩에 필요한 특정 로직**을 textChanged에 정의해주면 되는 것이다.

이 로직은 bind(callback:) 함수를 통해 초기화 할 수 있다. 왜 bind(callback:) 을 사용하는가? 아래 나왔지만 내 추측이다..

---

![p0](https://user-images.githubusercontent.com/96910404/189542984-2d798e65-59ff-49ef-bca3-effca99c3ca3.png)

그전에 위 사진을 보면 textChanged에 클로저를 직접 설정해주어도 바인딩은 잘 잘 작동된다. 하지만 bind(callback:) 함수를 추가로 선언한 이유는 아무래도 프로퍼티를 사용하는 것 보단 함수를 호출하는게 캡슐화 측면에서 좋은 방안이어서 아래와 같은 함수를 선언 한 것 같다. // **UI에 등록을 허용**하는 기능이다.


![p1](https://user-images.githubusercontent.com/96910404/189542983-e41b221c-7431-4820-946b-c3013999c7c1.png)

textChanged를 바로 사용할 수 는 없다. 디폴트로 {_ in} 초기화만 되어있기 때문에 바인딩의 목적에 맞는 클로저 할당이 우선 필요하다.

---

여기서 궁금한게 그저 usernameTextField에 bind(callback:) 함수 딱 한번 달아줬는데 왜 계속 바인딩이 될까?????????? 

>bind(callback:) 함수는 단 한번 실행이 된다. 이때 주요  역할은 @escaping을 통해 BindingTextField의 textChanged 클로저 역할을 대입해준다.
>
> 이제 사용자가 TextField를 입력할 때마다 addTarget의 .editingChanged 조건에 의해 textFieldDidChanged(_:)메소드가 호출되는데 이때마다 textChanged클로저가 실행되기 때문에 지속적으로 값이 갱신되는 것이다. bind에 의해 textChanded 로직이 정의됬는데 주요 로직은 self?.loginVM의 username에 값을 지속적으로 할당하는 것이다.

---

## Q2> What is ViewModel to View binding?

> 개발자가 ViewModel의 프로퍼티 값을 바꾸면 변경된 값이 TextField에도 자동으로 적용되야 한다.

View to VIewModel 와 비슷하다. 한가지 차이점은 ViewModel to View에서 View의 예로 TextField를 들었는데 바인딩을 사용하려면 커스터마이징을 해야했다.

View to ViewModel은 반대로 TextField에 bind를 걸어주는데 값은 다양하기때문에 제너릭 타입으로 선언되서 사용했다. ViewModel의 타입을 단순한 "" String에서 Dynamic타입으로 함으로써 값이 변경되면 Dynamic의 value가 변하는데 이때 didSet가 실행되면서 bind 함수의 callback 클로저 내용이 실행된다. 이때 TextField의 값이 변하는 것이다.

bind(callback:) 는 최초로 불러지면 listener에 대입되는데 이는 UI에 바인딩 됬다는 것을 의미하기 위해 func bind ( callback: @escape Listener) 로 listener를 초기화하는 것이다.

---

### 공부하면서 궁금했던 점

왜 클로저일때만 [weak self] 키워드를 붙이는 것일까? 어차피 VC의 인스턴스가 없다면 실행되 되지 않을 것인데?

> self 키워드는 참조를 유지하고 VC가 사라진 후에도 계속 참조를 유지한다. 클로저의 특성과 맞지 않기에 [weak self] 를 선언함으로써 모든 리소스를 garbage collected를 통해 관리하게 한다. 그럼 VC가 벗어난 이후에는 garbage collected가 처리한다.

앗 참고로 클로저는 내부 컨텐츠에 대해서 캡처 ,저장 가능한 특징이 있다. @escaping 인 경우에 그리고 만약 비동기 처리된다는 가정 하에 self키워드가 소멸된 후에 self를 호출할 수 있는데 이때 그.. 캡처?! 클로저 안의 내용중 self또한 캡쳐할 수 있는데 이미 그 self는 소멸되어서 문제가 발생함. ( 얫날에 공부해서 다시 진지하게 공부해 볼 필요가 있다!!!! _)_
