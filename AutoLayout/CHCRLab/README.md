## CHCDlab

Intrinsic Content Size와 Content Hugging, Compression Resistence에 대한 공부!!

---

name의 프로퍼티는 label, TextField의 프로퍼티는 tf라고 표현을 할 것이당.

현제 목적은 name은 contents size에 맞는 크기를 할당하고, name과 tf의 offset을 8로 한 후에 tf의 길이를 view.trailingAnchor offset -8로 쭉 늘릴려고 한다.

---

우선 label의 top, leading Anchor를 선언하고 추가로 tf의 leading  Anchor에 label의 trailing Anchor를 추가한 경우 + firstBaselineAnchor를 적용한 경우이다.

![CHCR1](https://user-images.githubusercontent.com/96910404/190858827-4dce7a79-8b49-4187-819c-78fbb2349bce.png)


이제 여기에 tf의 trailingAnchor를 view.trailingAnchor offset - 8로 선언 할 경우

![CHCR2](https://user-images.githubusercontent.com/96910404/190858830-243a40ad-0e77-48cd-a3f7-4f77815eb8e5.png)

내 생각과는 다르게 바뀌었다.

(이해가 안 간다...)

레이블은 손을 안 댔는데 어떻게 레이블은 확장하고 textField는 가만히 있는 걸까? textFiled의 trailing Anchor를 손댔는데..?..?

---


![CHCR3](https://user-images.githubusercontent.com/96910404/190858837-0afb5ab0-ea33-4e94-bbec-c3c557335d25.png)

label의 길이는 모호하다는 경고를 띄고 있고, TextFiled는 길이와 horizontal position이 모호하다는 경고가 나온다.

왜그럴까?

**TextField를 추가하기 전** label의 경우 intrinstic content size를 자동으로 갖게 된다. text 길이에 의해. 그래서 Constraint는 제약이 없지만 나의 경우 topAnchor와 leadingAnchor로 제약을 걸어줬기 때문에 자동으로 Label은 natural size인 width, height를 갖게 된다.

이제 TextField를 label의 trailingAnchor에 constraint할 경우 각 앵커의 너비를 파악할 수 없게 된다.

이것이 content hugging, compression resistance(aka CHCR)의 intrinsic content size에 대해서 알고 있어야 하는 이유이다. 이것은 Auto Layuot에서 거의 자주자주! 나타난다.


---
### cf

Apple은 CHCR을 도입하면서 control에게 option constraint에 대한 priority를 부여했다.

다른 view들 간 Constraint에의 해 본래의 Intrinsic Content Size보다 늘어난 경우 CHCR를 부여해야한다.

CHCR의 간단 요약
- Content Hugging : control이 늘어날 때 intrinsic size를 지키면서 감싼다. 즉 늘어나야 할 상황인데 늘어나지 않고 가만히 있다. 더 늘어나야 하는것에 대해 늘어나지 않고 계속해서 품어준다.
- Compression Resitance : control이 늘어날 때 우선순위가 낮은 경우 Intrinsic Control Size가 줄어든다. 이 경우 Control의 컨텐츠가 잘려 별로 선호x

왜 늘어나고 줄어들까?

기준은?

> priority다. UILayoutPriority에선 required는 1000으로 되어있는데 ( 앵커 )

ContentHugging의 경우 defaultLow == 250. CompressionResitance == 750으로 되어 있다. 그래서 기본적으로 control의 Size말고 Anchor로 정의 할 때 control들이 늘어나고 줄어드는 이유이다.

.defaultLow, .defaultHeight 이 두가지가 optional Constraint에 해당한다.

---

다시 돌아와서. label과 tf 둘다 Anchor로 각각의 intrinstic content size를 정의했는데 이 경우 각각의 content hugging, compression resistance 값이  값 250, 750 값으로 동일하다. 우선순위 부여 할 수가 없다.

이들 중의 hugging값 하나를 변경하면 된다. 그럼 priority에 의해 어느 한 contorl은 늘어나고 다른 control은 기존의 본질적인 크기를 갖게 된다.


---

초기 목표처럼 label은 늘어나지 않게 hugging을 해야한다. 따라서 label의 hugging을 높이면 늘어나지 않고 스스로 hugging을 하게 된다.

label.setContentHuggingPriority(UILayoutPriority(rawValue: 251), for: .horizontal)

![CHCR4](https://user-images.githubusercontent.com/96910404/190858832-42565c70-6920-4158-b134-d532ee79db6f.png)

이젠 다시 label의 Intrinsic Content Size가 정해졌다.


---

위와 같은 상황은 때때로 발생한다. 이런 Ambiguity(모호)한 상황에서 CHCR의 우선순위를 부여함으로 해결 할 수 있다. 물론 에러가 나지는 않는데 수정 해줘야 한다.


---

 위 상황은 둘다 작은데 커졌을때 뭘 줄이고(hugging한다는 말-> 그대로 == 커지지않고 그대로다 == 커져야할 상황에 커지지않고 그대로다 == 작아졌다?)뭘 키울지에 대한 Content Hugging의 상황이었다.

반대로 label에 text를 엄청 길게 썼다고 가정한다면 또 에러가 난다.

 이번엔 Compression Resistance가 같기 때문에 그렇다. 이번엔 둘다 커져야 하는 상황인데 뭐를 줄어야 할지에 대한 우선순위를 부여해야 한다. 우선순위가 높은 control은 Instrinsic Content Size를 유지할 것이고 우선순위가 상대적으로 낮은 Control이 본래의 크기보다 작아진다.
