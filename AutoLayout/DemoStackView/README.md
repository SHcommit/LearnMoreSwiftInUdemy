# StackView

### UIStackView.Alignment.fill

스택뷰의 축에 수직 공간으로 채울 수 있도록 정렬된 뷰들을 resize한다.

---

![1](https://user-images.githubusercontent.com/96910404/190897626-67617786-6713-411f-8ed5-6d6cffbc3bf2.png)

- 초록 버튼 width=100, height=100
- 빨간 버튼 width=200, height = 300
- 노란 버튼. width=250, height=100

버튼의 width, height를 정해줬고

StackView의 Axis = vertical, Alignment = Fill, Distribution = Fill로 한 상태이다.
AutoLayout 경고창이 떴다.

![2](https://user-images.githubusercontent.com/96910404/190897632-1339405e-2a65-47f1-bec5-a00336c20d7c.png)

AutoLayout에 의해 빌드가 되긴 하는데 StackView의 버튼 width Constraint들에 대해서 Conflict Constraint 경고가 발생했다. 뭐를 우선시 해서 StackView의 width로 정해야 할지 몰라 발생되는 경고 상황이다.

여기서 난 노란 button의 width만큼 다른 위에 뷰 길이들도 늘려주고 싶었다. 그래서 노란색 버튼의 CH은 제일 작게, CR은 제일 크게 설정했는데 작동되지 않았다.

width에 대해 required priority를 제일 큰 값으로 해주어야 비로소 변경이 됬다. 왜 CH CR은 작동이 안된건지 해결 방법을 알 수 없어 <a href="https://stackoverflow.com/questions/73760927/ios-autolayout-i-wonder-set-stackviews-views-view-priority-what-is-different">질문</a>했는데 명쾨하게 답을 알 수 있었다.

잊고있었는데.. Content Hugging 또는 Compression Resistance는 Intrinsic Content Size의Content에 해 관련이 있다. 버튼안 text에 대해서가 아니라 버튼의 width에 대해서 Conflict Constraint가 발생되는 것이므로 width에 대한 required priority를 정해야 한다...

---

	반면 Label들로 stackView를 채운 경우 Intrinsic Content Size에 의해 가장 큰 view의 width를 기준으로 나머지 Label들도 Fill이 됬다.


![5](https://user-images.githubusercontent.com/96910404/190897635-0f75e027-832a-438c-aa99-90fa40fef6de.png)
