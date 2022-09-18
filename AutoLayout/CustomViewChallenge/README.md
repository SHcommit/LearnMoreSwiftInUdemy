# CustomViewChallenge

커스텀 뷰를 작성할 때 intrinsicContentSize를 재 정의 해주어야 한다.

 ```
override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 61)        
}
```



그리고 중요한 것이 해당 클래스의 **translatesAutoresizingMaskIntoConstraints** 또한 false처리해야 subView에 대한 AutoLayout을 설정할 수 있다.

이번 첼린지를 하면서 그냥 AutoLayout Anchor로 만들어보고 그 후에 StackView를 사용했는데 정말 간편하다는 것을 알게 됬다.

![s](https://user-images.githubusercontent.com/96910404/190915708-abac7eab-d833-46fb-b633-ecc082eaddbe.png)
