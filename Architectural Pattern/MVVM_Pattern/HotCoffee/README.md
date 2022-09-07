# HotCoffee

1. 강의 보기전에 대략적인 UI를 구현했습니다. 이번엔 Autoresizing 레이아웃을 사용하지 않고 구현해봤다.


![일단 초기구현](https://user-images.githubusercontent.com/96910404/188262725-91e63009-8f40-4984-9676-3a49a371499a.gif)

오호.. Hiroku로 간단하게 아주간단하게 웹 서버가 동작하는 법을 살짝 맛봤다.


1. 초기 order 서버에는 빈 배열만있는데 iOS로 새로운 데이터 전송을 하지않고 (네트워킹 툴)포스트맨에서도 쉽게 value를 추가 할 수있다. 근데 이 강의에서 소개한 서버는 한번 실행하면 몇시간만에 저장해둔 db 값들을 다시 싹 날려버린다. (헛;; 기존 서버가 만료됬나..  요청 안됬는데 다행히 공지사항을 보니 새 서버 주소가 있네 휴..)
2. 실제로 Web API를 test할 때는 포스트맨 같은 네트워킹 툴을 사용하면 휠씬 편하다.(잘 응답 되는지 등등+ 문서화도 가능)
3. //이미지1 서버 정상동작
![eb360e210c2f7cbaa2641cc733bf01ae.png](:/8c35ef21dbfa4512b0c383a0bd570a7b)

4. 포스트맨을 사용하면 어플리케이션에서 POST방식으로 값을 서버로 전달하지 않고도 포스트맨에서 POST방식으로 값을 추가해준 후에 GET방식으로 변환해서 성공적으로 값이 서버에 저장되었는지 요청하면 볼 수있다. 정말 편하고 신기하다.

---

## 돌발상황 #1 


오늘 마주한 에러이다...

Date: 22.09.03~22.09.04

새로운 개념을 알게 되었다 Codable... 그냥 데이터를 JSON형식으로 모델에 적용하는것은 쉬운데 Codable 프로토콜로 채택하는 것은 아주 많이 까다로웠다.

![Can't applied](https://user-images.githubusercontent.com/96910404/188299660-d3f87306-6a03-4a4c-a67e-9cc9f3bc4bfc.png)

간단하게 responseString으로 값을 확인했을 때는 성공적으로 데이터가 존재하는데 decode(_:from:)를 했을 때 Codable 프로토콜이 적용되지 않은 채로 존재한다. 데이터 -> decode가 적용이 되지 않는다. 왜그럴까? 해결하려고 온갖 방법을 썼는데 그덕에 Alamofire의 여러 response 메소드를 강제로 다루게 되고 익숙해져버렸다;;;;;.... 하지만 문제는 여전히 해결할 수 없었다. URLRequest로 HTTP메서드 정의해서 URLSession으로 데이터를 파싱하려고해도 에러가...발생했다.

---


Date: 22.09.03~22.09.06 위에서 마주한 에러를 해결하기 위해 약간의 공부를 했다. 간단하게 끝날 줄 알았는데 시간은 계속 흘렀다.

위의에러를 해결하기 위해서 <a href="https://dev-with-precious-dreams.tistory.com/132">RESTful API JSON 데이터 파싱 개념을 공부했고  URLSession과 URLReqeust에 대해 자세하게 공부했다</a>. Codable을 적용하기 위해 <a href="https://dev-with-precious-dreams.tistory.com/134">Alamofire 도 공부</a>를 했다.  URLRequest + URLSession 과 Alamofire 공부를 충분히 한 후에 <a href="https://dev-with-precious-dreams.tistory.com/135">Codable 공부를 했다</a>.  그리고 <a href="https://dev-with-precious-dreams.tistory.com/136">Codable이 진짜 좋은 프로토콜임을</a>임을 알게 되었다.

근데 가장 좋은 건 친절하게 알려주신 <a href="https://stackoverflow.com/questions/73596588/ios-how-can-i-parse-json-codable-array-with-alamofire">StackOF 천사같은 어느 한 개발자님</a>..정말 감사했다. 선 정답 답변을 통해 알고도 곧바로 이해를 못했지만 Codable공부를 완벽하게 끝낸 이후엔 내 코드에 CodingKeys정의부터 몇몇 문제가 있었음을 알 수 있었다. 그리고 에러를 해결했다.

---


## 새로 알게된 개념

새로 알게된 개념인데 RESTful API의 JSON 에서 **root object as Array**인 경우 OrderList라는 list구조체를 굳이 만들지 않아도 된다.

load(resource<[Order]>) { result in
   // handle the response but now you will get the list of orders
}

를 통해 배열로된 list를 받을 수 있기 때문이다.

이와 반면에 root object as Object의 경우 OrderList를 생성해야 한다.
